// Package initcmd implements aa init: bootstrap a repository with what needs no agent, then
// hand off to /aa-fw-health and /aa-fw-init (features/cli/init.feature, design 3.6).
package initcmd

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/content"
	"aasdlc.com/aa/internal/targets"
	"aasdlc.com/aa/internal/tools"
)

// Options are the flags aa init accepts.
type Options struct {
	Path           string // repository to initialise; default the current directory
	TicketProject  string // key of the one ticket project (O-09); prompted for if empty and interactive
	TicketURL      string
	KnowledgeSpace string
	KnowledgeURL   string
	Shell          string       // pwsh (default) or sh: the shell for the root script stubs
	Targets        []string     // harness ids to install into at project scope; asked for if empty and interactive
	Yes            bool         // consent to every proposal without asking
	Interactive    bool         // stdin is a terminal; prompts are allowed
	UserConfigPath string       // override for tests; default config.UserPath()
	Home           string       // override for tests; default the user's home
	Run            tools.Runner // runs tool checks and installs; default tools.Shell
	Now            func() time.Time
}

// Run performs aa init and writes a report to out.
func Run(opts Options, in io.Reader, out io.Writer) error {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	dir := opts.Path
	if dir == "" {
		dir = "."
	}
	dir, err := filepath.Abs(dir)
	if err != nil {
		return err
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	reader := bufio.NewReader(in)
	report := func(format string, a ...any) { fmt.Fprintf(out, format+"\n", a...) }
	report("aa init in %s", dir)

	// 1. Source control (R-05). Offer to initialise; proceed only with consent.
	if !isDir(filepath.Join(dir, ".git")) {
		if consent(opts, reader, out, "This directory is not a repository. Initialise one with git init?") {
			cmd := exec.Command("git", "init", "-q")
			cmd.Dir = dir
			if outb, err := cmd.CombinedOutput(); err != nil {
				report("  git init failed: %s", strings.TrimSpace(string(outb)))
			} else {
				report("  initialised a repository (R-05); add a remote before finishing a branch")
			}
		} else {
			report("  not a repository; skipped (R-05 will report unmet)")
		}
	}

	// 2. Merge scopes and write the project config (R-07), only if absent.
	userPath := opts.UserConfigPath
	if userPath == "" {
		userPath, err = config.UserPath()
		if err != nil {
			return err
		}
	}
	scopes, err := config.LoadScopes(userPath)
	if err != nil {
		return err
	}
	defaults := config.Defaults()
	merged, err := config.Merge(append([]*config.Config{&defaults}, scopes...)...)
	if err != nil {
		return err
	}
	projectPath := filepath.Join(dir, config.FileName)
	existing, err := config.Load(projectPath)
	if err != nil {
		return err
	}
	header := "aa.config.yaml (project scope), written by aa init. See https://aasdlc.com and docs/formats.md.\n" +
		"conventions.ticket.project is the ONE ticket project this repository maps to (O-09).\n" +
		"Edit freely; aa init never overwrites this file."
	created := existing == nil
	if created {
		project := *merged
		project.Scope = "project"
		project.Install = nil
		project.Organisation = nil
		// The harnesses aa setup found on this machine are not the repository's; step 6 asks.
		// Tools and the stack from wider scopes are merged in when read, not copied here.
		project.Targets = nil
		project.Tools = nil
		project.Stack = nil
		// 3. The one ticket project (O-09, R-22): ask unless given.
		key, url := opts.TicketProject, opts.TicketURL
		if key == "" && opts.Interactive && !opts.Yes {
			key = ask(reader, out, "Which ticket system project or group does this repository map to? (key or URL, empty to skip): ")
		}
		if key != "" {
			if strings.Contains(key, "://") && url == "" {
				url = key
				key = keyFromURL(key)
			}
			project.Conventions.Ticket.Project = key
			project.Conventions.Ticket.URL = url
			if re := regexp.MustCompile(`^[A-Za-z][A-Za-z0-9_]*$`); re.MatchString(key) && project.Conventions.Ticket.Pattern == defaults.Conventions.Ticket.Pattern {
				project.Conventions.Ticket.Pattern = strings.ToUpper(key) + `-\d+`
			}
		}
		if opts.KnowledgeSpace != "" || opts.KnowledgeURL != "" {
			project.Conventions.Knowledge.Space = opts.KnowledgeSpace
			project.Conventions.Knowledge.URL = opts.KnowledgeURL
		}
		if err := config.Write(projectPath, &project, header); err != nil {
			return err
		}
		if project.Conventions.Ticket.Project == "" {
			report("  wrote %s (no ticket project recorded; /aa-fw-init will ask)", config.FileName)
		} else {
			report("  wrote %s (ticket project %s)", config.FileName, project.Conventions.Ticket.Project)
		}
		existing = &project
	} else {
		report("  %s exists; left as is", config.FileName)
	}

	// 4. Conventional folders (O-05, R-06, R-16, R-18, R-21) and the decision records (O-18, R-32).
	folders := merged.Folders
	for k, v := range existing.Folders {
		folders[k] = v
	}
	for _, key := range []string{"documents", "features", "scripts", "source", "tests"} {
		mkdirReport(dir, folders[key], report)
	}
	// The knowledge base in the documents folder, for a project with none in scope; its pages use
	// the knowledge base's format, so moving them into one later is an upload (T-12, R-03).
	knowledge := folders["knowledge"]
	if knowledge == "" {
		knowledge = filepath.Join(folders["documents"], "knowledge")
	}
	mkdirReport(dir, filepath.Join(knowledge, "Requirements"), report)
	mkdirReport(dir, filepath.Join(folders["tests"], "integration"), report)
	mkdirReport(dir, filepath.Join(folders["tests"], "e2e"), report)
	decisions := folders["decisions"]
	if decisions == "" {
		decisions = filepath.Join(folders["documents"], "decisions")
	}
	mkdirReport(dir, decisions, report)
	writeIfMissing(dir, filepath.Join(decisions, "TEMPLATE.md"), decisionTemplate, report)
	writeIfMissing(dir, filepath.Join(decisions, "0001-adopt-aa-sdlc.md"), strings.ReplaceAll(decision0001, "{date}", opts.Now().Format("2006-01-02")), report)

	// 5. Root script stubs (O-06, R-10, R-11, R-19, R-20, R-35), honest until filled in.
	shell := opts.Shell
	if shell == "" {
		shell = "pwsh"
	}
	for _, stub := range stubs(shell) {
		writeIfMissing(dir, stub.name, stub.body, report)
	}

	// 5b. A commit-message hook where git allows one (T-09): Conventional Commit subject from
	// the configured types (O-14, R-28) and no agent attribution (O-17, R-31). Never overwrites
	// a hook the project already has.
	hooksDir := filepath.Join(dir, ".git", "hooks")
	if isDir(hooksDir) {
		hookPath := filepath.Join(hooksDir, "commit-msg")
		if _, err := os.Stat(hookPath); err != nil {
			types := existing.Conventions.Commit.Types
			if len(types) == 0 {
				types = config.DefaultCommitTypes
			}
			if err := os.WriteFile(hookPath, []byte(commitMsgHook(types)), 0o755); err == nil {
				report("  wrote .git/hooks/commit-msg (Conventional Commit subject, no agent attribution)")
			}
		}
	}

	// 5c. The feature-page scripts, kept in the repository so the pre-commit hook and the pipeline
	// run them without the aa CLI, and a pre-commit hook that refuses a feature file not pulled
	// from its page (T-12, R-46, R-47). Never overwrites a hook the project already has.
	scriptsDir := filepath.Join(folders["scripts"], ScriptsFolder)
	if err := InstallScripts(dir, scriptsDir); err != nil {
		return err
	}
	report("  wrote %s/ (feature pages: pull, check, seed, assign ids)", filepath.ToSlash(scriptsDir))
	if isDir(hooksDir) {
		hookPath := filepath.Join(hooksDir, "pre-commit")
		if _, err := os.Stat(hookPath); err != nil {
			if err := os.WriteFile(hookPath, []byte(preCommitHook(filepath.ToSlash(scriptsDir), filepath.ToSlash(folders["features"]))), 0o755); err == nil {
				report("  wrote .git/hooks/pre-commit (feature files must be pulled from their pages)")
			}
		} else if b, _ := os.ReadFile(hookPath); !strings.Contains(string(b), preCommitMarker) {
			report("  .git/hooks/pre-commit exists and is not ours; add %s/Test-FeatureProvenance.ps1 to it (R-47)", filepath.ToSlash(scriptsDir))
		}
	}

	// 6. Project-scope skills and commands for the harnesses named with -targets, or recorded in
	// the project config, or chosen from those found on this machine or in the repository
	// (decision record 0014). A project config written by this run records the choice.
	home := opts.Home
	if home == "" {
		home, _ = os.UserHomeDir()
	}
	chosen, err := chooseTargets(opts, existing, home, dir, reader, out)
	if err != nil {
		return err
	}
	if created {
		for _, t := range chosen {
			existing.Targets = append(existing.Targets, t.ID)
		}
		if err := config.Write(projectPath, existing, header); err != nil {
			return err
		}
	}
	if len(chosen) > 0 {
		scope := targets.ProjectScope(dir)
		res, err := targets.Install(scope, chosen)
		if err != nil {
			return err
		}
		targets.ReportInstall(out, scope, chosen, res)

		// 7. The instruction file each harness reads points at the framework; only the marked
		// block is ours, and it is replaced, never duplicated.
		body := instructionBlock(existing)
		for _, file := range targets.InstructionFiles(chosen) {
			changed, err := targets.WriteInstructionBlock(dir, file, body)
			if err != nil {
				return err
			}
			if changed {
				report("  %s: AA-SDLC block written (the rest of the file is left as it was)", file)
			}
		}
	}

	// 8. Tools on this machine (R-45): the framework's own prerequisites, installed with consent,
	// then the tools the project config lists. A project's install commands come from a file
	// anyone can commit to, so they run only when the user agrees to each one; -yes is not enough.
	if opts.Run == nil {
		opts.Run = tools.Shell
	}
	report("  prerequisites:")
	tools.Ensure(tools.Prerequisites(shell), opts.Run, func(q string) bool { return consent(opts, reader, out, q) }, "", out)
	withProject, err := config.Merge(merged, existing)
	if err != nil {
		return err
	}
	if len(withProject.Tools) == 0 {
		report("  no project tools recorded yet: /aa-fw-init infers the stack, or asks what the project is when it cannot, and records the tools it needs (R-44)")
	} else {
		report("  project tools (%s):", config.FileName)
		askEach := func(q string) bool {
			if !opts.Interactive {
				return false
			}
			answer := ask(reader, out, q+" [y/N]: ")
			return strings.EqualFold(answer, "y") || strings.EqualFold(answer, "yes")
		}
		tools.Ensure(withProject.Tools, opts.Run, askEach, "run the root initialize script, which installs the project's tools", out)
	}

	// 9. Hand off.
	report("")
	report("Next, in your agent: run /aa-fw-health, then /aa-fw-init.")
	return nil
}

// chooseTargets settles the harnesses this repository gets. Harnesses named with -targets win,
// then those the project config records. Otherwise the harnesses found on this machine or already
// in the repository are offered as a checklist with only the repository's own ticked; with nobody
// to ask, the repository's own are kept.
func chooseTargets(opts Options, cfg *config.Config, home, dir string, reader *bufio.Reader, out io.Writer) ([]targets.Spec, error) {
	if len(opts.Targets) > 0 {
		named, unknown, err := targets.ByID(opts.Targets)
		if err != nil {
			return nil, err
		}
		if len(unknown) > 0 {
			return nil, fmt.Errorf("no supported target named %s; run aa init -targets with ids from: %s", strings.Join(unknown, ", "), strings.Join(supportedIDs(), ", "))
		}
		return named, nil
	}
	if len(cfg.Targets) > 0 {
		recorded, _, err := targets.ByID(cfg.Targets)
		if err != nil {
			return nil, err
		}
		fmt.Fprintf(out, "  harnesses from %s: %s (edit its targets, or run aa uninstall -scope project, to change them)\n", config.FileName, targetNames(recorded))
		return recorded, nil
	}
	ticked, found := map[string]bool{}, map[string]bool{}
	for _, t := range targets.InRepo(dir) {
		ticked[t.ID] = true
	}
	onMachine, _ := targets.Detect(home, "")
	for _, t := range onMachine {
		found[t.ID] = true
	}
	all, err := targets.All()
	if err != nil {
		return nil, err
	}
	var offered []targets.Spec
	for _, t := range all {
		if ticked[t.ID] || found[t.ID] {
			offered = append(offered, t)
		}
	}
	if len(offered) == 0 {
		fmt.Fprintf(out, "  no supported agent harness found on this machine or in the repository (supported: %s); run aa init -targets <id,...> after installing one\n", strings.Join(targets.SupportedNames(), ", "))
		return nil, nil
	}
	if opts.Interactive && !opts.Yes {
		targets.Checklist("Which agent harnesses should this repository have? Ticked are the ones it already has folders for. Enter numbers to tick or untick, then Enter to continue.", offered, ticked, found, reader, out)
	}
	var chosen []targets.Spec
	for _, t := range offered {
		if ticked[t.ID] {
			chosen = append(chosen, t)
		}
	}
	if len(chosen) == 0 {
		var ids []string
		for _, t := range offered {
			ids = append(ids, t.ID)
		}
		fmt.Fprintf(out, "  no agent harness chosen for this repository; run aa init -targets <id,...> to add one (found: %s)\n", strings.Join(ids, ", "))
	}
	return chosen, nil
}

func targetNames(ts []targets.Spec) string {
	var names []string
	for _, t := range ts {
		names = append(names, t.Name)
	}
	return strings.Join(names, ", ")
}

func supportedIDs() []string {
	all, _ := targets.All()
	var ids []string
	for _, t := range all {
		if t.Supported() {
			ids = append(ids, t.ID)
		}
	}
	return ids
}

func consent(opts Options, reader *bufio.Reader, out io.Writer, question string) bool {
	if opts.Yes {
		return true
	}
	if !opts.Interactive {
		return false
	}
	answer := ask(reader, out, question+" [y/N]: ")
	return strings.EqualFold(answer, "y") || strings.EqualFold(answer, "yes")
}

func ask(reader *bufio.Reader, out io.Writer, prompt string) string {
	fmt.Fprint(out, prompt)
	line, err := reader.ReadString('\n')
	if err != nil && !errors.Is(err, io.EOF) {
		return ""
	}
	return strings.TrimSpace(line)
}

func keyFromURL(u string) string {
	// .../projects/AA/... or .../projects/AA -> AA; otherwise the last path segment
	parts := strings.Split(strings.TrimRight(u, "/"), "/")
	for i, p := range parts {
		if (p == "projects" || p == "project") && i+1 < len(parts) {
			return parts[i+1]
		}
	}
	return parts[len(parts)-1]
}

func mkdirReport(dir, rel string, report func(string, ...any)) {
	p := filepath.Join(dir, rel)
	if isDir(p) {
		return
	}
	if err := os.MkdirAll(p, 0o755); err == nil {
		report("  created %s/", filepath.ToSlash(rel))
	}
}

func writeIfMissing(dir, rel, body string, report func(string, ...any)) {
	p := filepath.Join(dir, rel)
	if _, err := os.Stat(p); err == nil {
		return
	}
	if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
		return
	}
	if err := os.WriteFile(p, []byte(body), 0o644); err == nil {
		report("  wrote %s", filepath.ToSlash(rel))
	}
}

func isDir(p string) bool {
	info, err := os.Stat(p)
	return err == nil && info.IsDir()
}

// instructionBlock is what aa init keeps in the project's instruction files: enough for an agent
// arriving cold to know the project follows AA-SDLC, where its work and knowledge live, and where
// to start.
func instructionBlock(cfg *config.Config) string {
	ticket := "not yet recorded; /aa-fw-init will ask"
	if cfg.Conventions.Ticket.Project != "" {
		ticket = cfg.Conventions.Ticket.Project
		if cfg.Conventions.Ticket.URL != "" {
			ticket += " (" + cfg.Conventions.Ticket.URL + ")"
		}
	}
	knowledge := "not yet recorded; /aa-fw-init will ask"
	if cfg.Conventions.Knowledge.Space != "" || cfg.Conventions.Knowledge.URL != "" {
		knowledge = strings.TrimSpace(cfg.Conventions.Knowledge.Space + " " + cfg.Conventions.Knowledge.URL)
	}
	return "## AA-SDLC\n\n" +
		"This repository follows the AA-SDLC software life cycle (https://aasdlc.com). Its conventions are in\n" +
		"`aa.config.yaml`, its requirements are the feature files, and every step is a skill with an\n" +
		"`/aa-` command.\n\n" +
		"- Ticket project: " + ticket + "\n" +
		"- Knowledge base: " + knowledge + "\n" +
		"- Not sure what to do? Run `/aa-fw-whatsnext`. To check the setup, run `/aa-fw-health`.\n"
}

// ScriptsFolder is the folder under the project's scripts folder that holds the framework's
// helper scripts; aa update refreshes it.
const ScriptsFolder = "aa-sdlc"

// InstallScripts writes the package's helper scripts to rel under the repository, replacing what
// is there: they are the framework's, and aa update keeps them current.
func InstallScripts(repo, rel string) error {
	files, err := content.Scripts()
	if err != nil {
		return err
	}
	target := filepath.Join(repo, rel)
	if err := os.MkdirAll(target, 0o755); err != nil {
		return err
	}
	for name, b := range files {
		if err := os.WriteFile(filepath.Join(target, name), b, 0o644); err != nil {
			return err
		}
	}
	return nil
}

const preCommitMarker = "aa-sdlc: feature files are pulled"

// preCommitHook refuses a commit when a feature file was not pulled from its knowledge base page
// or was edited since (R-47). It needs PowerShell; without it the check is skipped with a warning.
func preCommitHook(scripts, features string) string {
	return `#!/bin/sh
# ` + preCommitMarker + ` from knowledge base pages and never edited by hand (T-12, R-47).
# Written by aa init; the same check runs in the pipeline through the build script's lint switch.
command -v pwsh >/dev/null 2>&1 || { echo "aa-sdlc: pwsh not found; feature-file check skipped" >&2; exit 0; }
problems=$(pwsh -NoProfile -NonInteractive -File "` + scripts + `/Test-FeatureProvenance.ps1" -FeaturesRoot "` + features + `")
if [ -n "$problems" ]; then
  echo "$problems" >&2
  echo "aa-sdlc: change the knowledge base page and pull it instead of editing a feature file" >&2
  exit 1
fi
`
}

// commitMsgHook is the git commit-msg hook aa init writes: the subject must be a Conventional
// Commit with one of the project's types (O-14, R-28), and the message may not carry an
// attribution trailer naming an agent (O-17, R-31). It is a plain POSIX shell script so it
// runs under git on every platform, and the project may edit it; aa init never overwrites it.
func commitMsgHook(types []string) string {
	return fmt.Sprintf(`#!/bin/sh
# Written by aa init (AA-SDLC). Edit freely; aa init never overwrites this file.
# 1. The subject is a Conventional Commit: <type>(<scope>)!: <subject>, type from aa.config.yaml (O-14, R-28).
# 2. No trailer or line attributes the commit to an agent: the person who commits is the author (O-17, R-31).
msg_file="$1"
subject=$(grep -v '^#' "$msg_file" | sed -n '1p')
types='%s'
if [ -z "$subject" ]; then
  echo "aa: empty commit message" >&2
  exit 1
fi
if ! printf '%%s' "$subject" | grep -Eq "^($types)(\([^)]+\))?!?: .+"; then
  echo "aa: the commit subject must be a Conventional Commit: <type>(<scope>): <subject>, with type one of: $(printf '%%s' "$types" | tr '|' ' ')" >&2
  echo "aa: got: $subject" >&2
  exit 1
fi
# Attribution patterns are the ones agents add by default; extend the list if your tools use another.
if grep -Eiq '^(Co-Authored-By|Generated-By|Generated with|Signed-off-by):?.*(noreply@anthropic\.com|noreply@openai\.com|noreply@github\.com|\bclaude\b|\bcopilot\b|\bgpt\b|\bgemini\b|\bagent\b)' "$msg_file"; then
  echo "aa: commits carry no agent attribution; the person who commits is the author (O-17, R-31)" >&2
  exit 1
fi
exit 0
`, strings.Join(types, "|"))
}

type stub struct{ name, body string }

// stubs returns the four root scripts as honest stubs: each says what it must do and exits
// non-zero until it is filled in (O-06, /aa-fw-init guidance).
func stubs(shell string) []stub {
	if shell == "sh" {
		return []stub{
			{"initialize.sh", shStub("initialize", "Bootstrap a fresh clone: install every tool aa.config.yaml lists under tools that is missing or too old, with its install command for this platform (via the package manager, never by hand), create local folders, seed data if any. Safe to run repeatedly. (O-06, R-19, R-45)")},
			{"build.sh", shStub("build", "Build every project in this repository from a fresh clone. Accept --lint to run the formatter in check mode, each configured linter, and the feature-file check (pwsh scripts/aa-sdlc/Test-FeatureProvenance.ps1), and fail on a finding (O-21, R-35, R-47). Languages with no known linter: <fill in>. (O-06, R-10)")},
			{"test.sh", shStub("test", "Run the tests by tier: --tier unit|integration|e2e|all (default all), --filter <name>. Run even with zero tests. (O-06, O-07, R-11)")},
			{"pack.sh", shStub("pack", "Produce the distributable artifacts into .dist/ after build and test, built once with an immutable identity (O-06, O-24, R-20)")},
		}
	}
	return []stub{
		{"initialize.ps1", pwshStub("initialize", "Bootstrap a fresh clone: install every tool aa.config.yaml lists under tools that is missing or too old, with its install command for this platform (via the package manager, never by hand), create local folders, seed data if any. Safe to run repeatedly. (O-06, R-19, R-45)", "")},
		{"build.ps1", pwshStub("build", "Build every project in this repository from a fresh clone. With -Lint, run the formatter in check mode, each configured linter, and scripts/aa-sdlc/Test-FeatureProvenance.ps1, and fail on a finding (O-21, R-35, R-47). Languages with no known linter: <fill in>. (O-06, R-10)", "[switch]$Lint")},
		{"test.ps1", pwshStub("test", "Run the tests by tier (unit, integration, e2e, all) with an optional -Filter. Run even with zero tests. (O-06, O-07, R-11)", "[ValidateSet('all','unit','integration','e2e')][string]$Tier = 'all', [string]$Filter")},
		{"pack.ps1", pwshStub("pack", "Produce the distributable artifacts into .dist/ after build and test, built once with an immutable identity (O-06, O-24, R-20)", "")},
	}
}

func pwshStub(verb, must, params string) string {
	return fmt.Sprintf(`#Requires -Version 7.0
<#
.SYNOPSIS
    STUB written by aa init: the root %s script (O-06).
.DESCRIPTION
    This script must: %s
    Replace this stub. It exits non-zero until it does what it says.
#>
[CmdletBinding()]
param(%s)
$ErrorActionPreference = 'Stop'
Write-Error "%s.ps1 is a stub written by aa init. Fill it in: %s"
exit 1
`, verb, must, params, verb, must)
}

func shStub(verb, must string) string {
	return fmt.Sprintf(`#!/bin/sh
# STUB written by aa init: the root %s script (O-06).
# This script must: %s
# Replace this stub. It exits non-zero until it does what it says.
set -eu
echo "%s.sh is a stub written by aa init. Fill it in: %s" >&2
exit 1
`, verb, must, verb, must)
}

const decisionTemplate = `# NNNN: <Decision in one line>

**Date:** YYYY-MM-DD | **Status:** proposed | accepted | superseded by NNNN | **Ticket:** <id or none>

## Context

What is true that makes a decision necessary. Two or three sentences. Link the scenarios,
ticket, or opinion that raised it.

## Options

- **A.** What it is, in one line. Why it was not chosen, in one line.
- **B.** ...

## Decision

Which option, and the one or two reasons that decided it.

## Consequences

What becomes easier, what becomes harder, what must now happen.

<!--
One screen. If it needs more, it is several decisions.
Never edit an accepted record; write a new one that supersedes it and add "superseded by NNNN"
to this record's status line. (AA-SDLC O-18)
-->
`

const decision0001 = `# 0001: This repository adopts the AA-SDLC framework

**Date:** {date} | **Status:** accepted | **Ticket:** none

## Context

The repository was initialised with ` + "`aa init`" + ` on {date}. AA-SDLC is opinionated
(https://aasdlc.com); adopting it means accepting its opinions, which are listed in the
framework's README, and running its steps through the agent commands it installs.

## Options

- **A. Adopt the framework.** Chosen.
- **B. Do not.** Then this folder, the project config, and the installed commands are removed.

## Decision

Option A. The project config, the conventional folders, the root script stubs, and this
decision record sequence were laid down by ` + "`aa init`" + `. The next step is
` + "`/aa-fw-health`" + ` then ` + "`/aa-fw-init`" + ` in the agent.

## Consequences

- Every significant decision from here on is the next numbered record in this folder (O-18).
- Every unit of work anchors on a ticket in the one configured ticket project (O-03, O-09).
- The root scripts are the contract for building, testing, and packaging (O-06).
`

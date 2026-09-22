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
	"aasdlc.com/aa/internal/targets"
)

// Options are the flags aa init accepts.
type Options struct {
	Path           string // repository to initialise; default the current directory
	TicketProject  string // key of the one ticket project (O-09); prompted for if empty and interactive
	TicketURL      string
	KnowledgeSpace string
	KnowledgeURL   string
	Shell          string // pwsh (default) or sh: the shell for the root script stubs
	Yes            bool   // consent to every proposal without asking
	Interactive    bool   // stdin is a terminal; prompts are allowed
	UserConfigPath string // override for tests; default config.UserPath()
	Home           string // override for tests; default the user's home
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
	if existing == nil {
		project := *merged
		project.Scope = "project"
		project.Install = nil
		project.Organisation = nil
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
		header := "aa.config.yaml (project scope), written by aa init. See https://aasdlc.com and docs/formats.md.\n" +
			"conventions.ticket.project is the ONE ticket project this repository maps to (O-09).\n" +
			"Edit freely; aa init never overwrites this file."
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

	// 6. Project-scope skills and commands for each detected target.
	home := opts.Home
	if home == "" {
		home, _ = os.UserHomeDir()
	}
	found := targets.Detect(home, dir)
	if len(found) == 0 {
		report("  no supported agent target detected (supported: %s); run aa setup after installing one", targetNames(targets.Supported))
	}
	for _, t := range found {
		switch t.ID {
		case targets.ClaudeCode.ID:
			res, err := targets.InstallClaudeCode(dir, ".claude/skills")
			if err != nil {
				return err
			}
			report("  %s: %d skills and %d commands installed at project scope", t.Name, res.Skills, res.Commands)
		}
	}

	// 7. Hand off.
	report("")
	report("Next, in your agent: run /aa-fw-health, then /aa-fw-init.")
	return nil
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

func targetNames(ts []targets.Target) string {
	names := make([]string, len(ts))
	for i, t := range ts {
		names[i] = t.Name
	}
	return strings.Join(names, ", ")
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
			{"initialize.sh", shStub("initialize", "Bootstrap a fresh clone: install the tools this repository needs (via the package manager, never by hand), create local folders, seed data if any. Safe to run repeatedly. (O-06, R-19)")},
			{"build.sh", shStub("build", "Build every project in this repository from a fresh clone. Accept --lint to run the formatter in check mode and each configured linter and fail on a finding (O-21, R-35). Languages with no known linter: <fill in>. (O-06, R-10)")},
			{"test.sh", shStub("test", "Run the tests by tier: --tier unit|integration|e2e|all (default all), --filter <name>. Run even with zero tests. (O-06, O-07, R-11)")},
			{"pack.sh", shStub("pack", "Produce the distributable artifacts into .dist/ after build and test, built once with an immutable identity (O-06, O-24, R-20)")},
		}
	}
	return []stub{
		{"initialize.ps1", pwshStub("initialize", "Bootstrap a fresh clone: install the tools this repository needs (via the package manager, never by hand), create local folders, seed data if any. Safe to run repeatedly. (O-06, R-19)", "")},
		{"build.ps1", pwshStub("build", "Build every project in this repository from a fresh clone. With -Lint, run the formatter in check mode and each configured linter and fail on a finding (O-21, R-35). Languages with no known linter: <fill in>. (O-06, R-10)", "[switch]$Lint")},
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

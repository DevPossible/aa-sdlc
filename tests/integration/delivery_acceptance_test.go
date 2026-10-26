package integration

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/initcmd"
	"aasdlc.com/aa/internal/setupcmd"
	"aasdlc.com/aa/internal/tools"
	"github.com/cucumber/godog"
)

// These bindings complete F-006, F-008 and F-009. Ordinary scenarios execute the
// built CLI. Tool installation scenarios use the production command ports with a
// recording Runner, so acceptance tests never install software on their host.
func registerDeliveryAcceptanceSteps(sc *godog.ScenarioContext, w *world) {
	checkClaude := func() error { return w.projectTargets("claude-code") }
	sc.Step(`^project-scope skills and commands are installed for each harness chosen for this repository$`, checkClaude)
	sc.Step(`^project-scope skills and commands are installed only for the harnesses I leave ticked$`, checkClaude)
	sc.Step(`^the project config records exactly those harnesses as its targets$`, checkClaude)
	sc.Step(`^the project config's targets name only Claude Code$`, checkClaude)
	sc.Step(`^it installs for those targets without asking$`, func() error {
		if strings.Contains(w.out, "Which agent harnesses") {
			return errors.New("recorded project targets prompted again")
		}
		return checkClaude()
	})
	sc.Step(`^Claude Code, Gemini CLI, and Qwen Code are found on this machine$`, func() error {
		for _, rel := range []string{".gemini", ".qwen"} {
			if err := os.MkdirAll(filepath.Join(w.home, rel), 0o755); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^I run "aa init" interactively$`, func() error {
		return w.run(w.project, "1\n\n", "init", "-interactive", "-ticket-project", "ABC")
	})
	sc.Step(`^it lists only the harnesses found on this machine or already in the repository as a checklist$`, func() error {
		for _, name := range []string{"Claude Code", "Gemini CLI", "Qwen Code"} {
			if !strings.Contains(w.out, "] "+name+" (found on this machine)") {
				return fmt.Errorf("checklist is missing %s:\n%s", name, w.out)
			}
		}
		if strings.Contains(w.out, "] Codex") || strings.Contains(w.out, "] Windsurf") {
			return fmt.Errorf("checklist includes an absent harness:\n%s", w.out)
		}
		return nil
	})
	sc.Step(`^it ticks only the harnesses the repository already has folders for$`, func() error {
		// The first display precedes the user's selection; this fixture has no harness folders.
		displays := strings.Split(w.out, "Which agent harnesses")
		if len(displays) < 2 {
			return errors.New("no harness checklist was shown")
		}
		first := displays[1]
		rows := regexp.MustCompile(`(?m)^\s+\d+\. \[([ x])\]`).FindAllStringSubmatch(first, -1)
		if len(rows) != 3 {
			return fmt.Errorf("want three initial checklist rows, got %d", len(rows))
		}
		for _, row := range rows {
			if row[1] != " " {
				return errors.New("a machine-only harness was initially ticked")
			}
		}
		return nil
	})
	sc.Step(`^"aa setup" recorded Claude Code, Gemini CLI, and Windsurf in the user config$`, func() error {
		return w.run(w.project, "", "setup", "-targets", "claude-code,gemini-cli,windsurf")
	})
	sc.Step(`^I run "aa init" and tick only Claude Code$`, func() error {
		return w.run(w.project, "1\n\n", "init", "-interactive", "-ticket-project", "ABC")
	})
	sc.Step(`^no \.gemini or \.windsurf folder is created in the repository$`, func() error {
		return w.noProjectHarnesses(".gemini", ".windsurf")
	})
	sc.Step(`^I run "aa init -targets claude-code,codex"$`, func() error {
		return w.run(w.project, "", "init", "-targets", "claude-code,codex", "-ticket-project", "ABC")
	})
	sc.Step(`^it does not ask which harnesses to install into$`, func() error {
		if strings.Contains(w.out, "Which agent harnesses") {
			return errors.New("explicit targets prompted for a checklist")
		}
		return w.success()
	})
	sc.Step(`^project-scope skills and commands are installed for Claude Code and Codex only$`, func() error {
		return w.projectTargets("claude-code", "codex")
	})
	sc.Step(`^no terminal is attached and no harness is named$`, func() error {
		w.unnamed, w.noInput = true, true
		return os.MkdirAll(filepath.Join(w.project, ".claude"), 0o755)
	})
	sc.Step(`^project-scope skills and commands are installed only for harnesses the repository already has folders for$`, checkClaude)
	sc.Step(`^when there are none, it installs none and says how to name them with -targets$`, func() error {
		if err := w.run(w.project, "", "init", "-path", w.other); err != nil {
			return err
		}
		if err := w.outputContains("aa init -targets"); err != nil {
			return err
		}
		cfg, err := config.Load(filepath.Join(w.other, config.FileName))
		if err != nil || cfg == nil || len(cfg.Targets) != 0 {
			return fmt.Errorf("empty repository recorded targets: %v", err)
		}
		for _, root := range []string{".claude", ".agents", ".gemini"} {
			if _, err := os.Stat(filepath.Join(w.other, root)); !os.IsNotExist(err) {
				return fmt.Errorf("unselected %s was created: %v", root, err)
			}
		}
		return w.success()
	})
	sc.Step(`^the project config names its targets$`, func() error {
		w.unnamed = true
		return w.run(w.project, "", "init", "-targets", "claude-code", "-ticket-project", "ABC")
	})
	sc.Step(`^it says to edit the project config's targets, or run "aa uninstall -scope project", to change them$`, func() error {
		return w.outputContains("edit its targets, or run aa uninstall -scope project, to change them")
	})
	sc.Step(`^the repository has no code to infer a stack from$`, func() error {
		if _, err := os.Stat(filepath.Join(w.project, "src")); !os.IsNotExist(err) {
			return fmt.Errorf("blank source fixture is not empty: %v", err)
		}
		return nil
	})
	sc.Step(`^it says "/aa-fw-init" will ask what the project is and which tools it needs$`, func() error {
		return w.outputContains("/aa-fw-init infers the stack, or asks what the project is")
	})
	sc.Step(`^the project config names no targets$`, func() error {
		cfg := config.Defaults()
		cfg.Scope, cfg.Targets = "project", nil
		if err := config.Write(filepath.Join(w.project, config.FileName), &cfg, "fixture"); err != nil {
			return err
		}
		old := filepath.Join(w.project, ".claude", "skills", "aa-fw-health", "SKILL.md")
		if err := os.MkdirAll(filepath.Dir(old), 0o755); err != nil {
			return err
		}
		return os.WriteFile(old, []byte("old core\n"), 0o644)
	})
	sc.Step(`^"aa setup" installed into more harnesses on this machine than the repository has folders for$`, func() error {
		return w.run(w.project, "", "setup", "-targets", "claude-code,gemini-cli,windsurf")
	})
	sc.Step(`^I run "aa update" inside the repository$`, func() error {
		w.snapshotConfig()
		return w.run(w.project, "", "update")
	})
	sc.Step(`^project scope is refreshed only for the harnesses the repository already has folders for$`, func() error {
		if err := w.exists(w.project, ".claude/skills/aa-dev-implement/SKILL.md"); err != nil {
			return err
		}
		return w.noProjectHarnesses(".gemini", ".windsurf", ".agents")
	})

	registerToolAcceptanceSteps(sc, w)
}

func (w *world) runInit() error {
	args := []string{"init"}
	if !w.noInput {
		args = append(args, "-interactive")
	}
	if !w.unnamed {
		args = append(args, "-targets", w.initTargets())
	}
	return w.run(w.project, "ABC\n", args...)
}

func (w *world) success() error {
	if w.exit != 0 {
		return fmt.Errorf("CLI exit %d:\n%s\n%s", w.exit, w.out, w.errOut)
	}
	return nil
}

func (w *world) projectTargets(want ...string) error {
	if err := w.success(); err != nil {
		return err
	}
	cfg, err := config.Load(filepath.Join(w.project, config.FileName))
	if err != nil || cfg == nil {
		return fmt.Errorf("project configuration: %v", err)
	}
	got := slices.Clone(cfg.Targets)
	want = slices.Clone(want)
	slices.Sort(got)
	slices.Sort(want)
	if !slices.Equal(got, want) {
		return fmt.Errorf("project targets = %v, want %v", got, want)
	}
	for _, id := range want {
		root := ".claude/skills"
		if id == "codex" {
			root = ".agents/skills"
		}
		if err := w.exists(w.project, root+"/aa-fw-health/SKILL.md"); err != nil {
			return err
		}
	}
	return w.noProjectHarnesses(".gemini", ".windsurf")
}

func (w *world) noProjectHarnesses(roots ...string) error {
	for _, root := range roots {
		if _, err := os.Stat(filepath.Join(w.project, root)); !os.IsNotExist(err) {
			return fmt.Errorf("unselected project harness %s exists: %v", root, err)
		}
	}
	return nil
}

type toolFixture struct {
	calls     []string
	installed bool
	missingPS bool
}

func (f *toolFixture) run(command string) (string, error) {
	f.calls = append(f.calls, command)
	switch command {
	case "fixture-present --version":
		return "1.2", nil
	case "fixture-old --version":
		return "0.5", nil
	case "fixture-missing --version", "fixture-installable --version":
		if !f.installed {
			return "", errors.New("not installed")
		}
		return "1.2", nil
	case "pwsh --version":
		if f.missingPS && !f.installed {
			return "", errors.New("not installed")
		}
	}
	if command == "fixture-install" || strings.Contains(command, "winget install") || strings.Contains(command, "brew install") {
		f.installed = true
	}
	return "99.0.0", nil
}

func (w *world) runWithTools(dir, stdin string, args ...string) error {
	var out bytes.Buffer
	var err error
	switch args[0] {
	case "setup":
		err = setupcmd.Run(setupcmd.Options{Home: w.home, UserConfigPath: filepath.Join(w.home, ".aa", config.FileName), Targets: []string{"claude-code"}, Run: w.tools.run, Interactive: slices.Contains(args, "-interactive"), In: strings.NewReader(stdin)}, &out)
	case "init":
		err = initcmd.Run(initcmd.Options{Home: w.home, UserConfigPath: filepath.Join(w.home, ".aa", config.FileName), Path: dir, TicketProject: "ABC", Targets: []string{"claude-code"}, Run: w.tools.run, Interactive: slices.Contains(args, "-interactive"), Yes: slices.Contains(args, "-yes")}, strings.NewReader(stdin), &out)
	}
	w.out, w.errOut, w.exit = out.String(), "", 0
	if err != nil {
		w.errOut, w.exit = err.Error(), 1
	}
	return nil
}

func registerToolAcceptanceSteps(sc *godog.ScenarioContext, w *world) {
	sc.Step(`^the project config lists tools with check commands$`, func() error {
		return w.seedTools([]config.Tool{
			{Name: "Present", Version: "1.0", Check: "fixture-present --version"},
			{Name: "Old", Version: "1.0", Check: "fixture-old --version"},
			{Name: "Missing", Version: "1.0", Check: "fixture-missing --version"},
			{Name: "Uncheckable"},
		})
	})
	sc.Step(`^it runs each check and reports each tool as found with its version, too old, or missing$`, func() error {
		for _, check := range []string{"fixture-present --version", "fixture-old --version", "fixture-missing --version"} {
			if !slices.Contains(w.tools.calls, check) {
				return fmt.Errorf("tool check %s did not run: %v", check, w.tools.calls)
			}
		}
		for _, result := range []string{"Present 1.2: found", "Old 0.5: too old", "Missing: missing"} {
			if err := w.outputContains(result); err != nil {
				return err
			}
		}
		return w.success()
	})
	sc.Step(`^a tool with no check command is left to "/aa-fw-health" in the agent$`, func() error {
		if slices.Contains(w.tools.calls, "") {
			return errors.New("a tool without a check was executed")
		}
		return w.outputContains("/aa-fw-health")
	})
	sc.Step(`^the project config lists a missing tool with an install command for this platform$`, func() error {
		return w.seedTools([]config.Tool{{Name: "Formatter", Version: "1.0", Check: "fixture-installable --version", Install: map[string]string{tools.Platform(): "fixture-install"}}})
	})
	sc.Step(`^it shows the exact install command and runs it only if I agree$`, func() error {
		if err := w.outputContains("fixture-install"); err != nil {
			return err
		}
		if slices.Contains(w.tools.calls, "fixture-install") {
			return errors.New("project installer ran without consent")
		}
		if err := w.run(w.project, "y\n", "init", "-interactive"); err != nil {
			return err
		}
		if !slices.Contains(w.tools.calls, "fixture-install") || !w.tools.installed {
			return errors.New("agreed project installer was not run")
		}
		return w.success()
	})
	sc.Step(`^"-yes" alone never runs an install command from a project config$`, func() error {
		w.tools.installed, w.tools.calls = false, nil
		if err := w.run(w.project, "", "init", "-yes"); err != nil {
			return err
		}
		if slices.Contains(w.tools.calls, "fixture-install") {
			return errors.New("-yes executed a project-provided installer")
		}
		return w.success()
	})
	sc.Step(`^with no install command for this platform it says to run the root initialize script$`, func() error {
		if err := w.seedTools([]config.Tool{{Name: "Formatter", Check: "fixture-installable --version"}}); err != nil {
			return err
		}
		if err := w.run(w.project, "", "init"); err != nil {
			return err
		}
		return w.outputContains("run the root initialize script")
	})
	sc.Step(`^it checks this machine has a source control client and PowerShell 7 or newer$`, func() error {
		for _, tool := range []string{"Git", "PowerShell"} {
			if !regexp.MustCompile(tool + `(?: [\d.]+)?: (?:found|missing|too old)`).MatchString(w.out) {
				return fmt.Errorf("no prerequisite result for %s:\n%s", tool, w.out)
			}
		}
		return nil
	})
	sc.Step(`^it reports each as found with its version, too old, or missing$`, func() error {
		return w.success()
	})
	sc.Step(`^PowerShell 7 is not installed on this machine$`, func() error {
		w.tools = &toolFixture{missingPS: true}
		return nil
	})
	sc.Step(`^I run "aa setup" interactively and agree to install it$`, func() error {
		return w.run(w.project, "y\n", "setup", "-interactive")
	})
	sc.Step(`^it installs PowerShell with the platform's package manager and checks it again$`, func() error {
		for _, prerequisite := range tools.Prerequisites("pwsh") {
			if prerequisite.Name != "PowerShell" {
				continue
			}
			install := prerequisite.Install[tools.Platform()]
			if install == "" {
				return w.outputContains(prerequisite.Docs)
			}
			at := slices.Index(w.tools.calls, install)
			if at < 0 || !slices.Contains(w.tools.calls[at+1:], "pwsh --version") {
				return fmt.Errorf("missing consented install or subsequent check: %v", w.tools.calls)
			}
			return w.outputContains("installed:")
		}
		return errors.New("PowerShell prerequisite not declared")
	})
	sc.Step(`^where the platform has no package manager it knows, it says where to get it instead$`, func() error {
		fixture := &toolFixture{}
		var out bytes.Buffer
		tools.Ensure([]config.Tool{{Name: "External", Check: "fixture-missing --version", Docs: "https://example.invalid/tool"}}, fixture.run, func(string) bool { return false }, "", &out)
		if !strings.Contains(out.String(), "get it from https://example.invalid/tool") || fixture.installed {
			return fmt.Errorf("missing non-installable prerequisite guidance:\n%s", out.String())
		}
		return nil
	})
}

func (w *world) seedTools(projectTools []config.Tool) error {
	w.tools = &toolFixture{}
	cfg := config.Defaults()
	cfg.Scope, cfg.Targets, cfg.Tools = "project", []string{"claude-code"}, projectTools
	return config.Write(filepath.Join(w.project, config.FileName), &cfg, "owned tool fixture")
}

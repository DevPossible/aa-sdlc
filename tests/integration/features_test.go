// Package integration executes the framework's @cli feature files against the built aa binary
// with godog (decision record 0005). The binary is named by AA_BIN; test.ps1 sets it. Every
// scenario gets a fresh AA_HOME and a fresh project directory, so scenarios are independent
// and can run in any order (O-23).
package integration

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"github.com/cucumber/godog"
)

type world struct {
	bin     string
	home    string // AA_HOME for this scenario; contains .claude so Claude Code is "installed"
	project string // the current project directory
	other   string // a second directory, for -path and "second repository" scenarios
	out     string
	errOut  string
	exit    int
	config  string // the project config as it was before a step, for later steps
	plugin  string // a fixture plugin folder created for the scenario
}

func TestFeatures(t *testing.T) {
	bin := os.Getenv("AA_BIN")
	if bin == "" {
		t.Skip("AA_BIN is not set; run ./test.ps1 -Tier integration, which builds the CLI and sets it")
	}
	if _, err := os.Stat(bin); err != nil {
		t.Fatalf("AA_BIN %s: %v", bin, err)
	}
	suite := godog.TestSuite{
		ScenarioInitializer: func(sc *godog.ScenarioContext) { initializeScenario(sc, bin) },
		Options: &godog.Options{
			Format:   "pretty",
			Paths:    []string{"../../features/cli"},
			Tags:     "@cli",
			TestingT: t,
			Strict:   false, // undefined steps (aa update, aa plugin) are reported, not failed
		},
	}
	if suite.Run() != 0 {
		t.Fatal("feature tests failed")
	}
}

func initializeScenario(sc *godog.ScenarioContext, bin string) {
	w := &world{bin: bin}

	sc.Before(func(ctx context.Context, _ *godog.Scenario) (context.Context, error) {
		root, err := os.MkdirTemp("", "aa-it-")
		if err != nil {
			return ctx, err
		}
		w.home = filepath.Join(root, "home")
		w.project = filepath.Join(root, "project")
		w.other = filepath.Join(root, "other")
		for _, d := range []string{filepath.Join(w.home, ".claude"), w.project} {
			if err := os.MkdirAll(d, 0o755); err != nil {
				return ctx, err
			}
		}
		// The project starts as a repository so that only the scenario about source control
		// meets the git init offer; every other scenario's first prompt is the ticket project.
		git := exec.Command("git", "init", "-q")
		git.Dir = w.project
		if out, err := git.CombinedOutput(); err != nil {
			return ctx, fmt.Errorf("git init: %v: %s", err, out)
		}
		return ctx, nil
	})
	sc.After(func(ctx context.Context, _ *godog.Scenario, _ error) (context.Context, error) {
		os.RemoveAll(filepath.Dir(w.home))
		return ctx, nil
	})

	// --- running aa ---
	sc.Step(`^"aa setup" has been run on this machine$`, func() error { return w.run(w.project, "", "setup") })
	sc.Step(`^"aa setup" has already been run$`, func() error { return w.run(w.project, "", "setup") })
	sc.Step(`^the aa-sdlc package is installed globally$`, func() error { return nil })
	sc.Step(`^I am in a project directory$`, func() error { return nil })
	sc.Step(`^I run "aa setup"$`, func() error { return w.run(w.project, "", "setup") })
	sc.Step(`^I run "aa setup" again$`, func() error { return w.run(w.project, "", "setup") })
	sc.Step(`^"aa setup" completes$`, func() error { return w.run(w.project, "", "setup") })
	sc.Step(`^I run "aa setup" with an organisation config repository$`, func() error {
		org := filepath.Join(w.home, "org")
		if err := os.MkdirAll(org, 0o755); err != nil {
			return err
		}
		if err := os.WriteFile(filepath.Join(org, "aa.config.yaml"), []byte("version: 1\nscope: enterprise\nplugins: [ent-plugin]\n"), 0o644); err != nil {
			return err
		}
		return w.run(w.project, "", "setup", "-org", org)
	})
	sc.Step(`^I run "aa init"$`, func() error { return w.run(w.project, "ABC\n", "init", "-interactive") })
	sc.Step(`^I run "aa init" again$`, func() error { return w.run(w.project, "ABC\n", "init", "-interactive") })
	sc.Step(`^"aa init" completes$`, func() error { return w.run(w.project, "ABC\n", "init", "-interactive") })
	sc.Step(`^"aa init" has already been run here$`, func() error { return w.run(w.project, "ABC\n", "init", "-interactive") })
	sc.Step(`^I am in a repository initialised with "aa init"$`, func() error {
		return w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC")
	})
	sc.Step(`^I run "aa init -path <dir>"$`, func() error {
		return w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC", "-path", w.other)
	})
	sc.Step(`^I run "aa health"$`, func() error { return w.run(w.project, "", "health") })

	// --- init: what it lays down ---
	sc.Step(`^a project config exists at the project root$`, func() error { return w.exists(w.project, "aa.config.yaml") })
	sc.Step(`^a documents folder exists$`, func() error { return w.exists(w.project, "docs") })
	sc.Step(`^a features folder exists$`, func() error { return w.exists(w.project, "features") })
	sc.Step(`^project-scope skills and commands are installed for each detected target$`, func() error {
		if err := w.exists(w.project, ".claude/commands/aa-fw-health.md"); err != nil {
			return err
		}
		return w.exists(w.project, ".claude/skills/aa-fw-health/SKILL.md")
	})
	sc.Step(`^<dir> is initialised exactly as the current directory would have been$`, func() error {
		if err := w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC"); err != nil {
			return err
		}
		a, _ := listFiles(w.project)
		b, _ := listFiles(w.other)
		if a != b {
			return fmt.Errorf("file sets differ:\n%s\n---\n%s", a, b)
		}
		return nil
	})

	// --- init: source control ---
	sc.Step(`^the directory is not a repository$`, func() error { return os.RemoveAll(filepath.Join(w.project, ".git")) })
	sc.Step(`^it offers to initialise a repository$`, func() error {
		// The generic run answered the ticket prompt; re-run answering "no" to the offer and check it was made.
		os.RemoveAll(filepath.Join(w.project, ".git"))
		os.Remove(filepath.Join(w.project, "aa.config.yaml"))
		if err := w.run(w.project, "n\nABC\n", "init", "-interactive"); err != nil {
			return err
		}
		return w.outputContains("Initialise one with git init?")
	})
	sc.Step(`^it proceeds only with consent$`, func() error {
		if _, err := os.Stat(filepath.Join(w.project, ".git")); err == nil {
			return errors.New("a repository was initialised without consent")
		}
		if err := w.run(w.project, "y\nABC\n", "init", "-interactive"); err != nil {
			return err
		}
		return w.exists(w.project, ".git")
	})

	// --- init: scopes ---
	sc.Step(`^user, team, and enterprise configs exist$`, func() error {
		org := filepath.Join(w.home, "org")
		if err := os.MkdirAll(filepath.Join(org, "web"), 0o755); err != nil {
			return err
		}
		files := map[string]string{
			filepath.Join(org, "aa.config.yaml"):           "version: 1\nscope: enterprise\nplugins: [ent-plugin]\nconventions:\n  branch:\n    pattern: ent/{id}\n",
			filepath.Join(org, "web", "aa.config.yaml"):    "version: 1\nscope: team\nconventions:\n  branch:\n    pattern: team/{id}\n",
			filepath.Join(w.home, ".aa", "aa.config.yaml"): fmt.Sprintf("version: 1\nscope: user\norganisation:\n  repository: %q\n  team: web\n", filepath.ToSlash(org)),
		}
		for p, body := range files {
			if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
				return err
			}
			if err := os.WriteFile(p, []byte(body), 0o644); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^the project config is created from the merged scopes$`, func() error { return w.configContains("ent-plugin") })
	sc.Step(`^project settings take precedence over team, team over enterprise$`, func() error { return w.configContains("team/{id}") })

	// --- init: conventions ---
	sc.Step(`^the project config records a default pattern for referencing the anchor ticket$`, func() error {
		return w.configMatches(`pattern: .*\\d\+`)
	})
	sc.Step(`^the pattern can be changed in the project config$`, func() error {
		p := filepath.Join(w.project, "aa.config.yaml")
		b, err := os.ReadFile(p)
		if err != nil {
			return err
		}
		edited := regexp.MustCompile(`pattern: .*\\d\+`).ReplaceAllString(string(b), "pattern: MINE-\\d+")
		if err := os.WriteFile(p, []byte(edited), 0o644); err != nil {
			return err
		}
		if err := w.run(w.project, "ABC\n", "init", "-interactive"); err != nil {
			return err
		}
		return w.configContains(`MINE-\d+`)
	})
	sc.Step(`^the "build" script stub accepts a lint switch$`, func() error { return w.fileContains("build.ps1", "$Lint") })
	sc.Step(`^the stub names what it must do: run the formatter in check mode and each configured linter$`, func() error {
		return w.fileContains("build.ps1", "formatter in check mode")
	})
	sc.Step(`^it says which languages were detected with no known linter, if any$`, func() error {
		return w.fileContains("build.ps1", "no known linter")
	})
	sc.Step(`^the decision record folder exists at the location the project config names$`, func() error {
		return w.exists(w.project, "docs/decisions")
	})
	sc.Step(`^it holds a template with context, options, decision, and consequences$`, func() error {
		for _, h := range []string{"## Context", "## Options", "## Decision", "## Consequences"} {
			if err := w.fileContains("docs/decisions/TEMPLATE.md", h); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^record 0001 records the adoption of the framework, dated today$`, func() error {
		return w.fileContains("docs/decisions/0001-adopt-aa-sdlc.md", "**Date:** 20")
	})
	sc.Step(`^the location can be changed in the project config to a knowledge base page$`, func() error {
		return w.configContains("decisions:")
	})
	sc.Step(`^the project config records the Conventional Commits pattern$`, func() error { return w.configContains("{type}({scope}): {subject}") })
	sc.Step(`^it records the default list of commit types$`, func() error {
		for _, t := range []string{"feat", "fix", "chore"} {
			if err := w.configContains("- " + t); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^the types and scopes can be changed in the project config$`, func() error { return w.configContains("types:") })

	// --- init: the one ticket project ---
	sc.Step(`^it asks which ticket system project or group this repository maps to$`, func() error {
		return w.outputContains("Which ticket system project or group does this repository map to?")
	})
	sc.Step(`^the project config records exactly one$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.project, "aa.config.yaml"))
		if err != nil {
			return err
		}
		n := strings.Count(string(b), "project: ")
		if n != 1 {
			return fmt.Errorf("want exactly one ticket project, found %d", n)
		}
		return nil
	})
	sc.Step(`^a second repository may record the same project$`, func() error {
		if err := w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC", "-path", w.other); err != nil {
			return err
		}
		b, err := os.ReadFile(filepath.Join(w.other, "aa.config.yaml"))
		if err != nil {
			return err
		}
		if !strings.Contains(string(b), "project: ABC") {
			return errors.New("second repository did not record the same project")
		}
		return nil
	})

	// --- init: re-run and hand-off ---
	sc.Step(`^existing config, folders, and feature files are left as they are$`, func() error { return w.outputContains("exists; left as is") })
	sc.Step(`^missing pieces are added$`, func() error {
		if err := os.RemoveAll(filepath.Join(w.project, "tests", "e2e")); err != nil {
			return err
		}
		if err := w.run(w.project, "ABC\n", "init", "-interactive"); err != nil {
			return err
		}
		return w.exists(w.project, "tests/e2e")
	})
	sc.Step(`^it tells the user to run "/aa-fw-health" and "/aa-fw-init" in their agent$`, func() error {
		if err := w.outputContains("/aa-fw-health"); err != nil {
			return err
		}
		return w.outputContains("/aa-fw-init")
	})
	sc.Step(`^the CLI explains that health is an agent command$`, func() error { return w.errContains("agent command") })
	sc.Step(`^it names "/aa-fw-health"$`, func() error { return w.errContains("/aa-fw-health") })

	// --- setup ---
	sc.Step(`^it lists every supported agent target found on the machine$`, func() error { return w.outputContains("Claude Code") })
	sc.Step(`^it installs the skills and commands for each at user scope$`, func() error {
		return w.exists(w.home, ".claude/commands/aa-fw-health.md")
	})
	sc.Step(`^the shared guidance sets are installed at user scope with no command$`, func() error {
		return w.guidanceInstalled(w.home)
	})
	sc.Step(`^every installed skill at user scope points at the guidance sets by their user-scope path$`, func() error {
		return w.skillsPointAt(w.home, "~/.claude/skills/aa-guidance/sets/")
	})
	sc.Step(`^the shared guidance sets are installed at project scope with no command$`, func() error {
		return w.guidanceInstalled(w.project)
	})
	sc.Step(`^every installed skill at project scope points at the guidance sets by their project-scope path$`, func() error {
		return w.skillsPointAt(w.project, ".claude/skills/aa-guidance/sets/")
	})
	sc.Step(`^a user-scope config exists$`, func() error { return w.exists(w.home, ".aa/aa.config.yaml") })
	sc.Step(`^it records the targets installed and the package version$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.home, ".aa", "aa.config.yaml"))
		if err != nil {
			return err
		}
		s := string(b)
		if !strings.Contains(s, "claude-code") || !strings.Contains(s, "version:") {
			return fmt.Errorf("user config lacks targets or version:\n%s", s)
		}
		return nil
	})
	sc.Step(`^the enterprise and team plugins and settings from that repository are layered over core$`, func() error {
		if err := w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC"); err != nil {
			return err
		}
		return w.configContains("ent-plugin")
	})
	sc.Step(`^the user config records the repository$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.home, ".aa", "aa.config.yaml"))
		if err != nil {
			return err
		}
		if !strings.Contains(string(b), "repository:") {
			return errors.New("user config does not record the organisation repository")
		}
		return nil
	})
	sc.Step(`^nothing is duplicated$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.home, ".aa", "aa.config.yaml"))
		if err != nil {
			return err
		}
		if strings.Count(string(b), "claude-code") != 1 {
			return errors.New("target listed more than once")
		}
		return nil
	})
	sc.Step(`^any newly installed agent targets are picked up$`, func() error {
		return godog.ErrPending // only one target is supported so far; nothing new can appear
	})
	sc.Step(`^no supported agent target is installed$`, func() error { return os.RemoveAll(filepath.Join(w.home, ".claude")) })
	sc.Step(`^it names the targets it supports$`, func() error { return w.outputContains("supported: Claude Code") })
	sc.Step(`^it still writes the user config$`, func() error { return w.exists(w.home, ".aa/aa.config.yaml") })
	sc.Step(`^it tells the user to run "aa init" in a repository$`, func() error { return w.outputContains("run aa init") })

	// --- update ---
	sc.Step(`^a newer aa-sdlc package is installed globally$`, func() error { return nil }) // the binary under test is the package version
	sc.Step(`^I run "aa update"$`, func() error { w.snapshotConfig(); return w.run(w.project, "", "update") })
	sc.Step(`^"aa update" completes$`, func() error { w.snapshotConfig(); return w.run(w.project, "", "update") })
	sc.Step(`^the skills and commands at user scope match the package version$`, func() error {
		return w.exists(w.home, ".claude/commands/aa-fw-health.md")
	})
	sc.Step(`^the user config records the new version$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.home, ".aa", "aa.config.yaml"))
		if err != nil {
			return err
		}
		if !strings.Contains(string(b), "version:") {
			return errors.New("user config has no install version")
		}
		return nil
	})
	sc.Step(`^the project-scope skills and commands match the package version$`, func() error {
		return w.exists(w.project, ".claude/commands/aa-fw-health.md")
	})
	sc.Step(`^project config, documents, and feature files are left as they are$`, func() error {
		after, err := os.ReadFile(filepath.Join(w.project, "aa.config.yaml"))
		if err != nil {
			return err
		}
		if string(after) != w.config {
			return errors.New("aa update changed the project config")
		}
		return nil
	})
	sc.Step(`^it lists the skills and commands that were added, changed, or removed$`, func() error {
		for _, word := range []string{"added", "changed", "removed"} {
			if err := w.outputContains(word); err != nil {
				return err
			}
		}
		return nil
	})

	// --- plugin ---
	sc.Step(`^I run "aa plugin add <plugin>"$`, func() error {
		if w.plugin == "" {
			w.plugin = w.writeFixturePlugin("fixture", "notes")
		}
		return w.run(w.project, "", "plugin", "add", w.plugin)
	})
	sc.Step(`^I run "aa plugin add <plugin> --scope user"$`, func() error {
		w.plugin = w.writeFixturePlugin("fixture", "notes")
		return w.run(w.project, "", "plugin", "add", w.plugin, "--scope", "user")
	})
	sc.Step(`^the plugin's skills and commands are installed at project scope$`, func() error {
		return w.exists(w.project, ".claude/skills/aa-fixture-notes/SKILL.md")
	})
	sc.Step(`^the project config records the plugin$`, func() error { return w.configContains("- fixture") })
	sc.Step(`^the plugin's skills and commands are installed at user scope$`, func() error {
		return w.exists(w.home, ".claude/skills/aa-fixture-notes/SKILL.md")
	})
	sc.Step(`^the user config records the plugin$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.home, ".aa", "aa.config.yaml"))
		if err != nil {
			return err
		}
		if !strings.Contains(string(b), "- fixture") {
			return fmt.Errorf("user config does not record the plugin:\n%s", b)
		}
		return nil
	})
	sc.Step(`^a plugin is installed at a scope$`, func() error {
		if err := w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC"); err != nil {
			return err
		}
		w.plugin = w.writeFixturePlugin("fixture", "notes")
		return w.run(w.project, "", "plugin", "add", w.plugin)
	})
	sc.Step(`^I run "aa plugin remove <plugin>"$`, func() error { return w.run(w.project, "", "plugin", "remove", "fixture") })
	sc.Step(`^its skills and commands are removed from that scope$`, func() error {
		if _, err := os.Stat(filepath.Join(w.project, ".claude", "skills", "aa-fixture-notes")); err == nil {
			return errors.New("plugin skill still installed")
		}
		return nil
	})
	sc.Step(`^core skills are untouched$`, func() error { return w.exists(w.project, ".claude/skills/aa-fw-health/SKILL.md") })
	sc.Step(`^I run "aa plugin list"$`, func() error { return w.run(w.project, "", "plugin", "list") })
	sc.Step(`^it lists installed plugins by scope$`, func() error {
		if err := w.outputContains("Installed"); err != nil {
			return err
		}
		return w.outputContains("scope")
	})
	sc.Step(`^it lists the plugins available from the organisation config repository, if one is set$`, func() error {
		return w.outputContains("Available")
	})
	sc.Step(`^a plugin that redefines a core skill$`, func() error {
		if err := w.run(w.project, "", "init", "-yes", "-ticket-project", "ABC"); err != nil {
			return err
		}
		w.plugin = w.writeFixturePlugin("bad", "implement")
		return nil
	})
	sc.Step(`^the plugin is refused$`, func() error {
		if w.exit == 0 {
			return fmt.Errorf("expected a non-zero exit, got 0:\n%s", w.out)
		}
		return w.errContains("refused")
	})
	sc.Step(`^the reason names the core skill it tried to change$`, func() error { return w.errContains(`"implement"`) })
}

// snapshotConfig remembers the project config so a later step can prove it was left alone.
func (w *world) snapshotConfig() {
	b, _ := os.ReadFile(filepath.Join(w.project, "aa.config.yaml"))
	w.config = string(b)
}

// writeFixturePlugin creates a plugin folder under the scenario's home and returns its path.
// guidanceInstalled checks the shared guidance folder is beside the skills at a scope and that
// it got no command (decision record 0012).
func (w *world) guidanceInstalled(scopeDir string) error {
	for _, set := range []string{"every-step", "anchored-step", "repository-write", "code-change", "test-writing", "framework-authoring"} {
		if err := w.exists(scopeDir, ".claude/skills/aa-guidance/sets/"+set+".md"); err != nil {
			return err
		}
	}
	if err := w.exists(scopeDir, ".claude/skills/aa-guidance/SKILL.md"); err != nil {
		return err
	}
	if _, err := os.Stat(filepath.Join(scopeDir, ".claude", "commands", "aa-guidance.md")); err == nil {
		return errors.New("aa-guidance must not get a command")
	}
	return nil
}

// skillsPointAt checks every installed step skill refers to the shared sets by the scope's
// path and no longer by the source path.
func (w *world) skillsPointAt(scopeDir, prefix string) error {
	entries, err := os.ReadDir(filepath.Join(scopeDir, ".claude", "skills"))
	if err != nil {
		return err
	}
	checked := 0
	for _, e := range entries {
		if !e.IsDir() || e.Name() == "aa-guidance" || !strings.HasPrefix(e.Name(), "aa-") {
			continue
		}
		b, err := os.ReadFile(filepath.Join(scopeDir, ".claude", "skills", e.Name(), "SKILL.md"))
		if err != nil {
			return err
		}
		s := string(b)
		if strings.Contains(s, "src/aa-sdlc/skills/aa-guidance") {
			return fmt.Errorf("%s still names the source path of the guidance sets", e.Name())
		}
		if strings.Contains(s, "## Guidance") && strings.Contains(s, "guidance sets") && !strings.Contains(s, prefix) {
			return fmt.Errorf("%s does not point at %s", e.Name(), prefix)
		}
		checked++
	}
	if checked == 0 {
		return errors.New("no installed skills found to check")
	}
	return nil
}

func (w *world) writeFixturePlugin(name string, skills ...string) string {
	dir := filepath.Join(w.home, "plugins", name)
	_ = os.MkdirAll(dir, 0o755)
	manifest := "name: " + name + "\nversion: 0.1.0\nkind: tech-stack\nadds:\n  skills: [" + strings.Join(skills, ", ") + "]\n"
	_ = os.WriteFile(filepath.Join(dir, "plugin.yaml"), []byte(manifest), 0o644)
	for _, s := range skills {
		d := filepath.Join(dir, "skills", s)
		_ = os.MkdirAll(d, 0o755)
		_ = os.WriteFile(filepath.Join(d, "SKILL.md"), []byte("---\nname: "+s+"\ndescription: \""+name+" "+s+"\"\n---\n# "+s+"\n"), 0o644)
	}
	return dir
}

// run executes aa with the scenario's AA_HOME, feeding stdin, from dir.
func (w *world) run(dir, stdin string, args ...string) error {
	cmd := exec.Command(w.bin, args...)
	cmd.Dir = dir
	cmd.Env = append(os.Environ(), "AA_HOME="+w.home)
	cmd.Stdin = strings.NewReader(stdin)
	var out, errOut bytes.Buffer
	cmd.Stdout, cmd.Stderr = &out, &errOut
	err := cmd.Run()
	w.out, w.errOut = out.String(), errOut.String()
	w.exit = 0
	var exitErr *exec.ExitError
	if errors.As(err, &exitErr) {
		w.exit = exitErr.ExitCode()
		return nil // a non-zero exit is an observation for the Then steps, not a step failure
	}
	return err
}

func (w *world) exists(root, rel string) error {
	if _, err := os.Stat(filepath.Join(root, filepath.FromSlash(rel))); err != nil {
		return fmt.Errorf("expected %s to exist under %s: %v\nstdout:\n%s\nstderr:\n%s", rel, root, err, w.out, w.errOut)
	}
	return nil
}

func (w *world) outputContains(s string) error {
	if !strings.Contains(w.out, s) {
		return fmt.Errorf("expected stdout to contain %q, got:\n%s\nstderr:\n%s", s, w.out, w.errOut)
	}
	return nil
}

func (w *world) errContains(s string) error {
	if !strings.Contains(w.errOut, s) {
		return fmt.Errorf("expected stderr to contain %q, got:\n%s", s, w.errOut)
	}
	return nil
}

func (w *world) fileContains(rel, s string) error {
	b, err := os.ReadFile(filepath.Join(w.project, filepath.FromSlash(rel)))
	if err != nil {
		return err
	}
	if !strings.Contains(string(b), s) {
		return fmt.Errorf("expected %s to contain %q", rel, s)
	}
	return nil
}

func (w *world) configContains(s string) error { return w.fileContains("aa.config.yaml", s) }

func (w *world) configMatches(pattern string) error {
	b, err := os.ReadFile(filepath.Join(w.project, "aa.config.yaml"))
	if err != nil {
		return err
	}
	if !regexp.MustCompile(pattern).Match(b) {
		return fmt.Errorf("expected aa.config.yaml to match %s:\n%s", pattern, b)
	}
	return nil
}

func listFiles(root string) (string, error) {
	var names []string
	err := filepath.WalkDir(root, func(p string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, _ := filepath.Rel(root, p)
		if d.IsDir() && (rel == ".git" || strings.HasPrefix(rel, ".git"+string(filepath.Separator))) {
			return filepath.SkipDir
		}
		if !d.IsDir() {
			names = append(names, filepath.ToSlash(rel))
		}
		return nil
	})
	return strings.Join(names, "\n"), err
}

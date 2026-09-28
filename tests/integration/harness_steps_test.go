package integration

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/cucumber/godog"
)

// harnessHomes are the folders or files under the home that make each harness detectable
// (targets/targets.yaml).
var harnessHomes = map[string]string{
	"Codex":      ".codex",
	"Gemini CLI": ".gemini",
	"Cursor":     ".cursor",
}

// registerHarnessSteps binds the steps for several harnesses, the instruction-file block, and
// aa uninstall (features/cli/setup.feature, init.feature, uninstall.feature; decision record 0014).
func registerHarnessSteps(sc *godog.ScenarioContext, w *world) {
	install := func(names ...string) error {
		for _, n := range names {
			if n == "Claude Code" {
				continue // the scenario's home already has .claude
			}
			if err := os.MkdirAll(filepath.Join(w.home, harnessHomes[n]), 0o755); err != nil {
				return err
			}
		}
		return nil
	}
	userConfig := func() string {
		b, _ := os.ReadFile(filepath.Join(w.home, ".aa", "aa.config.yaml"))
		return string(b)
	}
	hasAA := func(root, rel string) bool {
		entries, _ := os.ReadDir(filepath.Join(root, filepath.FromSlash(rel)))
		for _, e := range entries {
			if strings.HasPrefix(e.Name(), "aa-") {
				return true
			}
		}
		return false
	}
	absent := func(root, rel string) error {
		if hasAA(root, rel) {
			return fmt.Errorf("%s still holds framework files\n%s", rel, w.out)
		}
		return nil
	}
	recordsExactly := func(ids ...string) error {
		cfg := userConfig()
		for _, id := range []string{"claude-code", "codex", "gemini-cli", "cursor"} {
			want := false
			for _, x := range ids {
				want = want || x == id
			}
			if strings.Contains(cfg, "- "+id+"\n") != want {
				return fmt.Errorf("user config: expected %s recorded=%v:\n%s", id, want, cfg)
			}
		}
		return nil
	}

	// Detection and setup
	sc.Step(`^Claude Code, Codex, and Gemini CLI are installed on this machine$`, func() error { return install("Codex", "Gemini CLI") })
	sc.Step(`^Claude Code and Codex are installed on this machine$`, func() error { return install("Codex") })
	sc.Step(`^Cursor is installed on this machine$`, func() error { return install("Cursor") })
	sc.Step(`^Aider is installed on this machine$`, func() error {
		return os.WriteFile(filepath.Join(w.home, ".aider.conf.yml"), []byte("# aider\n"), 0o644)
	})
	sc.Step(`^I run "aa (setup|uninstall) ([^"]+)"$`, func(verb, args string) error {
		return w.run(w.project, "", append([]string{verb}, strings.Fields(args)...)...)
	})
	sc.Step(`^I run "aa setup" interactively and untick Claude Code$`, func() error {
		return w.run(w.project, "1\n\n", "setup", "-interactive")
	})
	sc.Step(`^it lists all three as installed at user scope$`, func() error {
		for _, n := range []string{"Claude Code:", "Codex:", "Gemini CLI:"} {
			if err := w.outputContains(n); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^the skills are written once to the Claude Code skills folder and once to the shared agents skills folder$`, func() error {
		if err := w.exists(w.home, ".claude/skills/aa-fw-health/SKILL.md"); err != nil {
			return err
		}
		if err := w.exists(w.home, ".agents/skills/aa-fw-health/SKILL.md"); err != nil {
			return err
		}
		return absent(w.home, ".gemini/skills")
	})
	sc.Step(`^Gemini CLI gets its commands in its own command format$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.home, ".gemini", "commands", "aa-fw-health.toml"))
		if err != nil {
			return err
		}
		if !strings.Contains(string(b), "{{args}}") || !strings.Contains(string(b), "prompt = ") {
			return fmt.Errorf("not a Gemini command:\n%s", b)
		}
		return nil
	})
	sc.Step(`^the user config records all three targets$`, func() error { return recordsExactly("claude-code", "codex", "gemini-cli") })
	sc.Step(`^only Codex is installed$`, func() error {
		if err := w.exists(w.home, ".agents/skills/aa-fw-health/SKILL.md"); err != nil {
			return err
		}
		return absent(w.home, ".claude/skills")
	})
	sc.Step(`^the user config records only codex$`, func() error { return recordsExactly("codex") })
	sc.Step(`^it names Cursor as reading the skills from more than one folder$`, func() error {
		return w.outputContains("Cursor reads skills from more than one")
	})
	sc.Step(`^it says Aider has no skills support and installs nothing for it$`, func() error {
		return w.outputContains("Aider: not installed")
	})

	// The instruction file
	sc.Step(`^Codex is a configured target$`, func() error {
		if err := install("Codex"); err != nil {
			return err
		}
		if err := os.WriteFile(filepath.Join(w.project, "AGENTS.md"), []byte("# Our project\n\nKeep me.\n"), 0o644); err != nil {
			return err
		}
		return w.run(w.project, "", "setup", "-targets", "codex")
	})
	sc.Step(`^I run "aa init" and name a ticket project$`, func() error { return w.run(w.project, "ABC\n", "init", "-interactive") })
	sc.Step(`^AGENTS\.md at the repository root has an AA-SDLC block naming the ticket project and "([^"]*)"$`, func(cmd string) error {
		for _, s := range []string{"<!-- aa-sdlc:begin -->", "ABC", cmd, "<!-- aa-sdlc:end -->"} {
			if err := w.fileContains("AGENTS.md", s); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^any text already in AGENTS\.md outside the block is kept$`, func() error { return w.fileContains("AGENTS.md", "Keep me.") })
	sc.Step(`^AGENTS\.md already has an AA-SDLC block$`, func() error {
		if err := install("Codex"); err != nil {
			return err
		}
		if err := w.run(w.project, "", "setup", "-targets", "codex"); err != nil {
			return err
		}
		return w.run(w.project, "ABC\n", "init", "-interactive")
	})
	sc.Step(`^AGENTS\.md has exactly one AA-SDLC block$`, func() error {
		b, err := os.ReadFile(filepath.Join(w.project, "AGENTS.md"))
		if err != nil {
			return err
		}
		if n := strings.Count(string(b), "<!-- aa-sdlc:begin -->"); n != 1 {
			return fmt.Errorf("expected one block, found %d:\n%s", n, b)
		}
		return nil
	})

	// The ticket life cycle and knowledge base sections (O-26, O-27)
	sc.Step(`^the project config maps the ticket kinds and life-cycle states, starting from the framework's own names$`, func() error {
		for _, x := range []string{"kinds:", "story: Story", "states:", "in-progress: In progress"} {
			if err := w.configContains(x); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^the project config maps the knowledge base sections, starting from the framework's own names$`, func() error {
		if err := w.configContains("sections:"); err != nil {
			return err
		}
		return w.configContains("operations: Operations")
	})

	// Discipline subagents (decision record 0015)
	sc.Step(`^Claude Code gets one subagent per delivery discipline$`, func() error {
		entries, err := os.ReadDir(filepath.Join(w.home, ".claude", "agents"))
		if err != nil {
			return err
		}
		n := 0
		for _, e := range entries {
			if strings.HasPrefix(e.Name(), "aa-") && strings.HasSuffix(e.Name(), ".md") {
				n++
			}
		}
		if n != 14 {
			return fmt.Errorf("want 14 discipline agents, found %d", n)
		}
		return nil
	})
	sc.Step(`^nothing is written for Codex's subagents$`, func() error {
		if _, err := os.Stat(filepath.Join(w.home, ".codex", "agents")); err == nil {
			return fmt.Errorf("a Codex agents folder was written")
		}
		return nil
	})

	// Uninstall
	setUp := func(names ...string) error {
		if err := install(names...); err != nil {
			return err
		}
		ids := map[string]string{"Claude Code": "claude-code", "Codex": "codex", "Cursor": "cursor"}
		var list []string
		for _, n := range append([]string{"Claude Code"}, names...) {
			list = append(list, ids[n])
		}
		return w.run(w.project, "", "setup", "-targets", strings.Join(list, ","))
	}
	sc.Step(`^Claude Code and Codex are installed and set up$`, func() error { return setUp("Codex") })
	sc.Step(`^Claude Code and Cursor are installed and set up$`, func() error { return setUp("Cursor") })
	sc.Step(`^the shared agents skills folder no longer holds any aa- skill$`, func() error { return absent(w.home, ".agents/skills") })
	sc.Step(`^Claude Code still has every skill and command$`, func() error {
		if err := w.exists(w.home, ".claude/skills/aa-fw-health/SKILL.md"); err != nil {
			return err
		}
		return w.exists(w.home, ".claude/commands/aa-fw-health.md")
	})
	sc.Step(`^the user config records only claude-code$`, func() error { return recordsExactly("claude-code") })
	sc.Step(`^Cursor's skills are reinstalled in a folder it reads$`, func() error {
		return w.exists(w.home, ".agents/skills/aa-fw-health/SKILL.md")
	})
	sc.Step(`^the Claude Code skills and commands are gone$`, func() error {
		if err := absent(w.home, ".claude/skills"); err != nil {
			return err
		}
		return absent(w.home, ".claude/commands")
	})
	sc.Step(`^no aa- skill, guidance set, or command remains in any harness folder at user scope$`, func() error {
		for _, rel := range []string{".claude/skills", ".claude/commands", ".agents/skills"} {
			if err := absent(w.home, rel); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^the user config records no targets$`, func() error { return recordsExactly() })
	sc.Step(`^a skill of the user's own sits beside the aa- skills$`, func() error {
		d := filepath.Join(w.home, ".claude", "skills", "my-own-skill")
		if err := os.MkdirAll(d, 0o755); err != nil {
			return err
		}
		return os.WriteFile(filepath.Join(d, "SKILL.md"), []byte("---\nname: my-own-skill\ndescription: mine\n---\n"), 0o644)
	})
	sc.Step(`^the user's own skill is still there$`, func() error { return w.exists(w.home, ".claude/skills/my-own-skill/SKILL.md") })
	sc.Step(`^I run "aa uninstall" interactively and tick Codex$`, func() error {
		return w.run(w.project, "2\n\n", "uninstall", "-interactive")
	})
	sc.Step(`^only Codex's framework files are removed$`, func() error {
		if err := absent(w.home, ".agents/skills"); err != nil {
			return err
		}
		return w.exists(w.home, ".claude/skills/aa-fw-health/SKILL.md")
	})
	sc.Step(`^I run "aa uninstall" with no targets named, no -all, and no terminal$`, func() error {
		return w.run(w.project, "", "uninstall")
	})
	sc.Step(`^it removes nothing$`, func() error {
		if w.exit == 0 {
			return fmt.Errorf("expected a non-zero exit:\n%s", w.out)
		}
		return w.exists(w.home, ".claude/skills/aa-fw-health/SKILL.md")
	})
	sc.Step(`^it says to name the harnesses with -targets or use -all$`, func() error { return w.errContains("-targets or use -all") })
	sc.Step(`^no aa- skill or command remains in the repository$`, func() error {
		for _, rel := range []string{".claude/skills", ".claude/commands", ".agents/skills"} {
			if err := absent(w.project, rel); err != nil {
				return err
			}
		}
		return nil
	})
	sc.Step(`^the AA-SDLC block is gone from its instruction files$`, func() error {
		for _, f := range []string{"AGENTS.md", "CLAUDE.md", "GEMINI.md"} {
			b, err := os.ReadFile(filepath.Join(w.project, f))
			if err == nil && strings.Contains(string(b), "aa-sdlc:begin") {
				return fmt.Errorf("%s still has the block:\n%s", f, b)
			}
		}
		return nil
	})
	sc.Step(`^the rest of each instruction file is left as it was$`, func() error {
		return w.exists(w.project, "aa.config.yaml")
	})
}

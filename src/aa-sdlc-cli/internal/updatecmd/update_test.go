package updatecmd

import (
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/initcmd"
	"aasdlc.com/aa/internal/setupcmd"
)

func TestUpdate_ReinstallsUserAndProjectScopeAndReportsChanges(t *testing.T) {
	home := filepath.Join(t.TempDir(), "home")
	if err := os.MkdirAll(filepath.Join(home, ".claude"), 0o755); err != nil {
		t.Fatal(err)
	}
	userPath := filepath.Join(home, ".aa", config.FileName)
	var out bytes.Buffer
	if err := setupcmd.Run(setupcmd.Options{Home: home, UserConfigPath: userPath}, &out); err != nil {
		t.Fatal(err)
	}
	project := t.TempDir()
	if err := initcmd.Run(initcmd.Options{Path: project, Yes: true, Home: home, UserConfigPath: userPath, TicketProject: "AA"}, strings.NewReader(""), &out); err != nil {
		t.Fatal(err)
	}

	// Simulate drift: a stale core command and a changed skill at user scope, and a user edit to the project config.
	stale := filepath.Join(home, ".claude", "commands", "aa-fw-obsolete.md")
	if err := os.WriteFile(stale, []byte("stale"), 0o644); err != nil {
		t.Fatal(err)
	}
	skill := filepath.Join(home, ".claude", "skills", "aa-fw-health", "SKILL.md")
	if err := os.WriteFile(skill, []byte("old"), 0o644); err != nil {
		t.Fatal(err)
	}
	cfgPath := filepath.Join(project, config.FileName)
	edited, _ := os.ReadFile(cfgPath)
	edited = append(edited, []byte("# keep me\n")...)
	if err := os.WriteFile(cfgPath, edited, 0o644); err != nil {
		t.Fatal(err)
	}

	out.Reset()
	if err := Run(Options{Path: project, Home: home, UserConfigPath: userPath}, &out); err != nil {
		t.Fatalf("update: %v\n%s", err, out.String())
	}
	s := out.String()
	if !strings.Contains(s, "~ .claude/skills/aa-fw-health/SKILL.md") {
		t.Errorf("changed skill not reported:\n%s", s)
	}
	if !strings.Contains(s, "- .claude/commands/aa-fw-obsolete.md") {
		t.Errorf("stale command not removed and reported:\n%s", s)
	}
	if _, err := os.Stat(stale); err == nil {
		t.Error("stale command still exists")
	}
	if b, _ := os.ReadFile(skill); string(b) == "old" {
		t.Error("skill was not brought back to the package version")
	}
	if after, _ := os.ReadFile(cfgPath); !bytes.Equal(after, edited) {
		t.Error("project config was changed by update")
	}
	user, _ := config.Load(userPath)
	if user.Install == nil || user.Install.Version == "" {
		t.Error("user config does not record the version")
	}
}

func TestUpdate_WithoutSetupSaysSo(t *testing.T) {
	home := t.TempDir()
	var out bytes.Buffer
	if err := Run(Options{Path: t.TempDir(), Home: home, UserConfigPath: filepath.Join(home, ".aa", config.FileName)}, &out); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(out.String(), "run aa setup first") {
		t.Errorf("want a pointer to aa setup, got:\n%s", out.String())
	}
}

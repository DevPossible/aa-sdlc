package updatecmd

import (
	"bytes"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/initcmd"
	"aasdlc.com/aa/internal/plugincmd"
	"aasdlc.com/aa/internal/setupcmd"
)

func TestUpdate_ReinstallsUserAndProjectScopeAndReportsChanges(t *testing.T) {
	home := filepath.Join(t.TempDir(), "home")
	if err := os.MkdirAll(filepath.Join(home, ".claude"), 0o755); err != nil {
		t.Fatal(err)
	}
	userPath := filepath.Join(home, ".aa", config.FileName)
	var out bytes.Buffer
	if err := setupcmd.Run(setupcmd.Options{Run: present, Home: home, UserConfigPath: userPath}, &out); err != nil {
		t.Fatal(err)
	}
	project := t.TempDir()
	if err := initcmd.Run(initcmd.Options{Run: present, Path: project, Yes: true, Targets: []string{"claude-code"}, Home: home, UserConfigPath: userPath, TicketProject: "AA"}, strings.NewReader(""), &out); err != nil {
		t.Fatal(err)
	}

	// Simulate drift: a command an earlier release wrote and a changed skill at user scope, and a user edit to the project config.
	stale := filepath.Join(home, ".claude", "commands", "aa-fw-obsolete.md")
	if err := os.MkdirAll(filepath.Dir(stale), 0o755); err != nil {
		t.Fatal(err)
	}
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
	if !regexp.MustCompile(`(?m)^  USER \.claude: \d+ files \(0 added, 1 changed, 1 removed\)$`).MatchString(s) {
		t.Errorf("the changed skill and the removed stale command should be counted under USER .claude:\n%s", s)
	}
	if !regexp.MustCompile(`(?m)^  PROJECT \.claude: \d+ files \(`).MatchString(s) {
		t.Errorf("the project scope's root folder should be reported:\n%s", s)
	}
	if strings.Contains(s, "SKILL.md") {
		t.Errorf("files should be counted, not listed:\n%s", s)
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

func TestUpdate_UpdatesThePluginsAtProjectScope(t *testing.T) {
	home := filepath.Join(t.TempDir(), "home")
	if err := os.MkdirAll(filepath.Join(home, ".claude"), 0o755); err != nil {
		t.Fatal(err)
	}
	userPath := filepath.Join(home, ".aa", config.FileName)
	var out bytes.Buffer
	if err := setupcmd.Run(setupcmd.Options{Run: present, Home: home, UserConfigPath: userPath}, &out); err != nil {
		t.Fatal(err)
	}
	project := t.TempDir()
	if err := initcmd.Run(initcmd.Options{Run: present, Path: project, Yes: true, Targets: []string{"claude-code"}, Home: home, UserConfigPath: userPath, TicketProject: "AA"}, strings.NewReader(""), &out); err != nil {
		t.Fatal(err)
	}
	plugin := filepath.Join(t.TempDir(), "k6")
	skill := filepath.Join(plugin, "skills", "load")
	if err := os.MkdirAll(skill, 0o755); err != nil {
		t.Fatal(err)
	}
	must := func(err error) {
		t.Helper()
		if err != nil {
			t.Fatal(err)
		}
	}
	must(os.WriteFile(filepath.Join(plugin, "plugin.yaml"), []byte("name: k6\nversion: 0.1.0\nkind: tool\n"), 0o644))
	must(os.WriteFile(filepath.Join(skill, "SKILL.md"), []byte("---\nname: load\ndescription: \"k6 load\"\naa:\n  attaches_to: [performance-test]\n---\n# load\n"), 0o644))
	must(plugincmd.Install(plugin, plugincmd.Options{Path: project, Home: home, UserConfigPath: userPath}, &out))
	must(os.WriteFile(filepath.Join(plugin, "plugin.yaml"), []byte("name: k6\nversion: 0.2.0\nkind: tool\n"), 0o644))

	out.Reset()
	must(Run(Options{Path: project, Home: home, UserConfigPath: userPath}, &out))
	s := out.String()
	if !strings.Contains(s, "aa plugin update k6: 0.1.0 -> 0.2.0") {
		t.Errorf("update should update the project's plugins:\n%s", s)
	}
	if _, err := os.Stat(filepath.Join(project, ".claude", "skills", "aa-k6-load", "SKILL.md")); err != nil {
		t.Errorf("plugin files must not be removed as stale core files: %v\n%s", err, s)
	}
}

// present stands in for a machine where every tool is installed, so no test runs a real check
// or installer.
func present(string) (string, error) { return "99.0.0", nil }

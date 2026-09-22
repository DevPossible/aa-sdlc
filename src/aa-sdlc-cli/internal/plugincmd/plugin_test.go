package plugincmd

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

// writePlugin creates a plugin folder: plugin.yaml plus one skill per name given.
func writePlugin(t *testing.T, dir, name string, skills ...string) {
	t.Helper()
	if err := os.MkdirAll(dir, 0o755); err != nil {
		t.Fatal(err)
	}
	manifest := "name: " + name + "\nversion: 0.1.0\nkind: tech-stack\nadds:\n  skills: [" + strings.Join(skills, ", ") + "]\nrequires: [R-" + name + "-01]\n"
	if err := os.WriteFile(filepath.Join(dir, "plugin.yaml"), []byte(manifest), 0o644); err != nil {
		t.Fatal(err)
	}
	for _, s := range skills {
		d := filepath.Join(dir, "skills", s)
		if err := os.MkdirAll(d, 0o755); err != nil {
			t.Fatal(err)
		}
		body := "---\nname: " + s + "\ndescription: \"" + name + " guidance for " + s + "\"\n---\n# " + s + "\n"
		if err := os.WriteFile(filepath.Join(d, "SKILL.md"), []byte(body), 0o644); err != nil {
			t.Fatal(err)
		}
	}
}

type fixture struct {
	home, userPath, project, org string
}

func setUp(t *testing.T) fixture {
	t.Helper()
	root := t.TempDir()
	f := fixture{home: filepath.Join(root, "home"), project: filepath.Join(root, "project"), org: filepath.Join(root, "org")}
	f.userPath = filepath.Join(f.home, ".aa", config.FileName)
	if err := os.MkdirAll(filepath.Join(f.home, ".claude"), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(filepath.Join(f.org, "plugins"), 0o755); err != nil {
		t.Fatal(err)
	}
	var out bytes.Buffer
	if err := setupcmd.Run(setupcmd.Options{Home: f.home, UserConfigPath: f.userPath, OrgRepository: f.org}, &out); err != nil {
		t.Fatal(err)
	}
	if err := initcmd.Run(initcmd.Options{Path: f.project, Yes: true, Home: f.home, UserConfigPath: f.userPath, TicketProject: "AA"}, strings.NewReader(""), &out); err != nil {
		t.Fatal(err)
	}
	return f
}

func TestPlugin_AddAtProjectScopeFromOrganisationRepository(t *testing.T) {
	f := setUp(t)
	writePlugin(t, filepath.Join(f.org, "plugins", "dotnet"), "dotnet", "implement-notes", "test-notes")
	var out bytes.Buffer
	if err := Add("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatalf("add: %v", err)
	}
	for _, rel := range []string{".claude/skills/aa-dotnet-implement-notes/SKILL.md", ".claude/commands/aa-dotnet-test-notes.md"} {
		if _, err := os.Stat(filepath.Join(f.project, rel)); err != nil {
			t.Errorf("expected %s: %v", rel, err)
		}
	}
	cfg, _ := config.Load(filepath.Join(f.project, config.FileName))
	if len(cfg.Plugins) != 1 || cfg.Plugins[0] != "dotnet" {
		t.Errorf("project config should record the plugin, got %v", cfg.Plugins)
	}
	if !strings.Contains(out.String(), "R-dotnet-01") {
		t.Errorf("declared requirements should be reported:\n%s", out.String())
	}
}

func TestPlugin_AddAtUserScopeByPath(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "proc")
	writePlugin(t, dir, "compliance", "review-change")
	var out bytes.Buffer
	if err := Add(dir, Options{Scope: "user", Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatalf("add: %v", err)
	}
	if _, err := os.Stat(filepath.Join(f.home, ".claude", "skills", "aa-compliance-review-change", "SKILL.md")); err != nil {
		t.Error("skill not installed at user scope")
	}
	user, _ := config.Load(f.userPath)
	if len(user.Plugins) != 1 || user.Plugins[0] != "compliance" {
		t.Errorf("user config should record the plugin, got %v", user.Plugins)
	}
}

func TestPlugin_RemoveLeavesCoreUntouched(t *testing.T) {
	f := setUp(t)
	writePlugin(t, filepath.Join(f.org, "plugins", "dotnet"), "dotnet", "implement-notes")
	var out bytes.Buffer
	if err := Add("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatal(err)
	}
	if err := Remove("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatal(err)
	}
	if _, err := os.Stat(filepath.Join(f.project, ".claude", "skills", "aa-dotnet-implement-notes")); err == nil {
		t.Error("plugin skill still present after remove")
	}
	if _, err := os.Stat(filepath.Join(f.project, ".claude", "skills", "aa-fw-health", "SKILL.md")); err != nil {
		t.Error("core skill was removed")
	}
	cfg, _ := config.Load(filepath.Join(f.project, config.FileName))
	if len(cfg.Plugins) != 0 {
		t.Errorf("project config still lists the plugin: %v", cfg.Plugins)
	}
}

func TestPlugin_RefusesOneThatRedefinesCore(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "bad")
	writePlugin(t, dir, "bad", "implement") // "implement" is a core step
	var out bytes.Buffer
	err := Add(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out)
	if err == nil || !strings.Contains(err.Error(), "refused") || !strings.Contains(err.Error(), `"implement"`) {
		t.Fatalf("want a refusal naming the core skill, got %v", err)
	}
	if _, statErr := os.Stat(filepath.Join(f.project, ".claude", "skills", "aa-bad-implement")); statErr == nil {
		t.Error("refused plugin was installed anyway")
	}
}

func TestPlugin_ListShowsInstalledByScopeAndAvailable(t *testing.T) {
	f := setUp(t)
	writePlugin(t, filepath.Join(f.org, "plugins", "dotnet"), "dotnet", "implement-notes")
	var out bytes.Buffer
	if err := Add("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatal(err)
	}
	out.Reset()
	if err := List(Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatal(err)
	}
	s := out.String()
	if !strings.Contains(s, "project scope") || !strings.Contains(s, "dotnet") || !strings.Contains(s, "from the organisation repository") {
		t.Errorf("list output incomplete:\n%s", s)
	}
}

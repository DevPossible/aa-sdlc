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
		body := "---\nname: " + s + "\ndescription: \"" + name + " guidance for " + s + "\"\naa:\n  attaches_to: [implement]\n---\n# " + s + "\n"
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
	if err := setupcmd.Run(setupcmd.Options{Run: present, Home: f.home, UserConfigPath: f.userPath, OrgRepository: f.org}, &out); err != nil {
		t.Fatal(err)
	}
	if err := initcmd.Run(initcmd.Options{Run: present, Path: f.project, Yes: true, Targets: []string{"claude-code"}, Home: f.home, UserConfigPath: f.userPath, TicketProject: "AA"}, strings.NewReader(""), &out); err != nil {
		t.Fatal(err)
	}
	return f
}

func TestPlugin_InstallAtProjectScopeFromOrganisationRepository(t *testing.T) {
	f := setUp(t)
	writePlugin(t, filepath.Join(f.org, "plugins", "dotnet"), "dotnet", "implement-notes", "test-notes")
	var out bytes.Buffer
	if err := Install("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatalf("add: %v", err)
	}
	for _, rel := range []string{".claude/skills/aa-dotnet-implement-notes/SKILL.md", ".claude/commands/aa-dotnet-test-notes.md"} {
		if _, err := os.Stat(filepath.Join(f.project, rel)); err != nil {
			t.Errorf("expected %s: %v", rel, err)
		}
	}
	cfg, _ := config.Load(filepath.Join(f.project, config.FileName))
	if len(cfg.Plugins) != 1 || cfg.Plugins[0].Name != "dotnet" || cfg.Plugins[0].Source != "organisation" || cfg.Plugins[0].Version != "0.1.0" {
		t.Errorf("project config should record the plugin, got %v", cfg.Plugins)
	}
	if !strings.Contains(out.String(), "R-dotnet-01") {
		t.Errorf("declared requirements should be reported:\n%s", out.String())
	}
}

func TestPlugin_InstallAtUserScopeByPath(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "proc")
	writePlugin(t, dir, "compliance", "review-change")
	var out bytes.Buffer
	if err := Install(dir, Options{Scope: "user", Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
		t.Fatalf("add: %v", err)
	}
	if _, err := os.Stat(filepath.Join(f.home, ".claude", "skills", "aa-compliance-review-change", "SKILL.md")); err != nil {
		t.Error("skill not installed at user scope")
	}
	user, _ := config.Load(f.userPath)
	if len(user.Plugins) != 1 || user.Plugins[0].Name != "compliance" {
		t.Errorf("user config should record the plugin, got %v", user.Plugins)
	}
}

func TestPlugin_RemoveLeavesCoreUntouched(t *testing.T) {
	f := setUp(t)
	writePlugin(t, filepath.Join(f.org, "plugins", "dotnet"), "dotnet", "implement-notes")
	var out bytes.Buffer
	if err := Install("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
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
	err := Install(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out)
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
	if err := Install("dotnet", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &out); err != nil {
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

// setSkill overwrites one fixture skill's SKILL.md with the frontmatter given.
func setSkill(t *testing.T, dir, skill, front string) {
	t.Helper()
	body := "---\nname: " + skill + "\ndescription: \"a skill\"\n" + front + "---\n# " + skill + "\n"
	if err := os.WriteFile(filepath.Join(dir, "skills", skill, "SKILL.md"), []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
}

func TestPlugin_RefusesAnUnknownKind(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "flux")
	writePlugin(t, dir, "flux", "render")
	manifest := "name: flux\nversion: 0.1.0\nkind: media\n"
	if err := os.WriteFile(filepath.Join(dir, "plugin.yaml"), []byte(manifest), 0o644); err != nil {
		t.Fatal(err)
	}
	err := Install(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &bytes.Buffer{})
	if err == nil || !strings.Contains(err.Error(), "tech-stack, tool, process") {
		t.Fatalf("want a refusal naming the three kinds, got %v", err)
	}
}

func TestPlugin_RefusesASkillThatAttachesToNothing(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "csharp")
	writePlugin(t, dir, "csharp", "codegen")
	setSkill(t, dir, "codegen", "")
	err := Install(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &bytes.Buffer{})
	if err == nil || !strings.Contains(err.Error(), `"codegen"`) || !strings.Contains(err.Error(), "ordinary agent skill") {
		t.Fatalf("want a refusal naming the skill and the alternative, got %v", err)
	}
	if _, statErr := os.Stat(filepath.Join(f.project, ".claude", "skills", "aa-csharp-codegen")); statErr == nil {
		t.Error("refused plugin was installed anyway")
	}
}

func TestPlugin_RefusesAnAttachmentCoreDoesNotDefine(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "k6")
	writePlugin(t, dir, "k6", "load")
	setSkill(t, dir, "load", "aa:\n  attaches_to: [soak-test]\n")
	err := Install(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &bytes.Buffer{})
	if err == nil || !strings.Contains(err.Error(), `"soak-test"`) {
		t.Fatalf("want a refusal naming the unknown step, got %v", err)
	}
}

func TestPlugin_AcceptsAToolPackThatSatisfiesARequirement(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "prettier")
	writePlugin(t, dir, "prettier", "format")
	if err := os.WriteFile(filepath.Join(dir, "plugin.yaml"), []byte("name: prettier\nversion: 0.1.0\nkind: tool\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	setSkill(t, dir, "format", "aa:\n  satisfies: [R-09]\n")
	if err := Install(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &bytes.Buffer{}); err != nil {
		t.Fatalf("a tool pack satisfying R-09 should install: %v", err)
	}
}

func TestPlugin_RefusesANameThatShadowsACoreDiscipline(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(t.TempDir(), "qa")
	writePlugin(t, dir, "qa", "extra")
	err := Install(dir, Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &bytes.Buffer{})
	if err == nil || !strings.Contains(err.Error(), "discipline code") {
		t.Fatalf("want a refusal for a plugin named like a discipline code, got %v", err)
	}
}

func TestPlugin_UpdateReinstallsFromTheRecordedPath(t *testing.T) {
	f := setUp(t)
	dir := filepath.Join(f.project, "..", "plugins-clone", "k6")
	writePlugin(t, dir, "k6", "load", "baseline")
	opts := Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}
	if err := Install(dir, opts, &bytes.Buffer{}); err != nil {
		t.Fatal(err)
	}
	cfg, _ := config.Load(filepath.Join(f.project, config.FileName))
	if cfg.Plugins[0].Source != "../plugins-clone/k6" {
		t.Errorf("a folder source is recorded relative to the config, got %q", cfg.Plugins[0].Source)
	}

	// The source moves on: a new version adds a skill and drops one.
	if err := os.RemoveAll(dir); err != nil {
		t.Fatal(err)
	}
	writePlugin(t, dir, "k6", "load", "soak")
	if err := os.WriteFile(filepath.Join(dir, "plugin.yaml"), []byte("name: k6\nversion: 0.2.0\nkind: tech-stack\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	var out bytes.Buffer
	if err := Update("k6", opts, &out); err != nil {
		t.Fatalf("update: %v", err)
	}
	s := out.String()
	for _, want := range []string{"0.1.0 -> 0.2.0", "+ .claude/skills/aa-k6-soak/SKILL.md", "- .claude/skills/aa-k6-baseline/SKILL.md"} {
		if !strings.Contains(s, want) {
			t.Errorf("update output lacks %q:\n%s", want, s)
		}
	}
	if _, err := os.Stat(filepath.Join(f.project, ".claude", "skills", "aa-k6-baseline")); err == nil {
		t.Error("the dropped skill is still installed")
	}
	if _, err := os.Stat(filepath.Join(f.project, ".claude", "skills", "aa-fw-health", "SKILL.md")); err != nil {
		t.Error("core skill was touched")
	}
	cfg, _ = config.Load(filepath.Join(f.project, config.FileName))
	if cfg.Plugins[0].Version != "0.2.0" {
		t.Errorf("config should record the new version, got %v", cfg.Plugins)
	}

	out.Reset()
	if err := Update("", opts, &out); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(out.String(), "0.2.0 is current") {
		t.Errorf("an unchanged plugin is reported as current:\n%s", out.String())
	}
}

func TestPlugin_UpdateOfAPluginNotInstalledIsAnError(t *testing.T) {
	f := setUp(t)
	err := Update("nope", Options{Path: f.project, Home: f.home, UserConfigPath: f.userPath}, &bytes.Buffer{})
	if err == nil || !strings.Contains(err.Error(), "not installed") {
		t.Fatalf("want a not-installed error, got %v", err)
	}
}

// present stands in for a machine where every tool is installed, so no test runs a real check
// or installer.
func present(string) (string, error) { return "99.0.0", nil }

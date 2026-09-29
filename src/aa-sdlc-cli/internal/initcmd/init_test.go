package initcmd

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"aasdlc.com/aa/internal/config"
)

func fixedNow() time.Time { return time.Date(2026, 9, 22, 12, 0, 0, 0, time.UTC) }

func execLookPath(name string) (string, error) { return exec.LookPath(name) }

// runHook runs the commit-msg hook under sh with the message file, as git would.
func runHook(sh, hook, msgFile string) error {
	cmd := exec.Command(sh, filepath.ToSlash(hook), filepath.ToSlash(msgFile))
	return cmd.Run()
}

func runInit(t *testing.T, dir string, extra func(*Options)) string {
	t.Helper()
	home := filepath.Join(t.TempDir(), "home")
	if err := os.MkdirAll(filepath.Join(home, ".claude"), 0o755); err != nil { // Claude Code is "installed"
		t.Fatal(err)
	}
	opts := Options{Path: dir, Yes: true, Targets: []string{"claude-code"}, Home: home, UserConfigPath: filepath.Join(home, ".aa", config.FileName), Now: fixedNow}
	if extra != nil {
		extra(&opts)
	}
	var out bytes.Buffer
	if err := Run(opts, strings.NewReader(""), &out); err != nil {
		t.Fatalf("init failed: %v\n%s", err, out.String())
	}
	return out.String()
}

func TestInit_LaysDownConfigFoldersStubsDecisionsAndCommands(t *testing.T) {
	dir := t.TempDir()
	out := runInit(t, dir, func(o *Options) {
		o.TicketProject = "AA"
		o.TicketURL = "https://example.atlassian.net/jira/software/projects/AA"
	})

	for _, rel := range []string{config.FileName, "docs", "features", "scripts", "src", "tests/integration", "tests/e2e", "docs/decisions/TEMPLATE.md", "docs/decisions/0001-adopt-aa-sdlc.md", "initialize.ps1", "build.ps1", "test.ps1", "pack.ps1", ".claude/commands/aa-fw-health.md", ".claude/skills/aa-fw-health/SKILL.md", ".claude/skills/aa-internal-new-step/SKILL.md"} {
		if _, err := os.Stat(filepath.Join(dir, rel)); err != nil {
			t.Errorf("expected %s to exist: %v", rel, err)
		}
	}
	// An internal step is named for "internal", not for its discipline (decision record 0017)
	if _, err := os.Stat(filepath.Join(dir, ".claude/skills/aa-fw-new-step")); err == nil {
		t.Error("internal step new-step was installed under its discipline code as aa-fw-new-step")
	}
	cfg, err := config.Load(filepath.Join(dir, config.FileName))
	if err != nil || cfg == nil {
		t.Fatalf("project config: %v", err)
	}
	if cfg.Scope != "project" || cfg.Conventions.Ticket.Project != "AA" || cfg.Conventions.Ticket.Pattern != `AA-\d+` {
		t.Errorf("config: %+v", cfg.Conventions.Ticket)
	}
	if len(cfg.Conventions.Commit.Types) != len(config.DefaultCommitTypes) {
		t.Errorf("commit types not recorded: %v", cfg.Conventions.Commit.Types)
	}
	if cfg.Folders["decisions"] != "docs/decisions" {
		t.Errorf("decisions folder not recorded: %v", cfg.Folders)
	}
	b, _ := os.ReadFile(filepath.Join(dir, "docs/decisions/0001-adopt-aa-sdlc.md"))
	if !strings.Contains(string(b), "2026-09-22") {
		t.Error("record 0001 is not dated today")
	}
	b, _ = os.ReadFile(filepath.Join(dir, "build.ps1"))
	if !strings.Contains(string(b), "$Lint") || !strings.Contains(string(b), "exit 1") {
		t.Error("build stub must accept -Lint and exit non-zero")
	}
	b, _ = os.ReadFile(filepath.Join(dir, ".claude/commands/aa-fw-health.md"))
	if !strings.Contains(string(b), "Read .claude/skills/aa-fw-health/SKILL.md") {
		t.Errorf("command must point at the project-scope skill, got:\n%s", b)
	}
	if !strings.Contains(out, "/aa-fw-health") || !strings.Contains(out, "/aa-fw-init") {
		t.Error("init must hand off to the agent commands")
	}
}

func TestInit_TicketURLGivesKeyAndPattern(t *testing.T) {
	dir := t.TempDir()
	runInit(t, dir, func(o *Options) { o.TicketProject = "https://example.atlassian.net/jira/software/projects/XY/boards/1" })
	cfg, _ := config.Load(filepath.Join(dir, config.FileName))
	if cfg.Conventions.Ticket.Project != "XY" || cfg.Conventions.Ticket.URL == "" || cfg.Conventions.Ticket.Pattern != `XY-\d+` {
		t.Errorf("want key XY from the URL, got %+v", cfg.Conventions.Ticket)
	}
}

func TestInit_RerunIsSafe(t *testing.T) {
	dir := t.TempDir()
	runInit(t, dir, func(o *Options) { o.TicketProject = "AA" })
	// The user edits their config and a stub; a second run must leave both alone.
	cfgPath := filepath.Join(dir, config.FileName)
	orig, _ := os.ReadFile(cfgPath)
	edited := append(orig, []byte("# my note\n")...)
	if err := os.WriteFile(cfgPath, edited, 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "build.ps1"), []byte("# real build\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	out := runInit(t, dir, nil)
	after, _ := os.ReadFile(cfgPath)
	if !bytes.Equal(after, edited) {
		t.Error("second run overwrote the project config")
	}
	b, _ := os.ReadFile(filepath.Join(dir, "build.ps1"))
	if string(b) != "# real build\n" {
		t.Error("second run overwrote a filled-in root script")
	}
	if !strings.Contains(out, "exists; left as is") {
		t.Errorf("second run should say the config was left as is:\n%s", out)
	}
}

func TestInit_LayersScopesIntoProjectConfig(t *testing.T) {
	dir := t.TempDir()
	home := filepath.Join(t.TempDir(), "home")
	org := filepath.Join(home, "org")
	must := func(err error) {
		if err != nil {
			t.Fatal(err)
		}
	}
	must(os.MkdirAll(filepath.Join(org, "web"), 0o755))
	must(config.Write(filepath.Join(org, config.FileName), &config.Config{Version: 1, Scope: "enterprise", Plugins: []config.PluginRef{{Name: "ent-plugin"}}, Conventions: config.Conventions{Branch: config.Branch{Pattern: "ent/{id}"}}}, "e"))
	must(config.Write(filepath.Join(org, "web", config.FileName), &config.Config{Version: 1, Scope: "team", Conventions: config.Conventions{Branch: config.Branch{Pattern: "team/{id}"}}}, "t"))
	userPath := filepath.Join(home, ".aa", config.FileName)
	must(config.Write(userPath, &config.Config{Version: 1, Scope: "user", Organisation: &config.Organisation{Repository: org, Team: "web"}}, "u"))

	var out bytes.Buffer
	must(Run(Options{Path: dir, Yes: true, Home: home, UserConfigPath: userPath, Now: fixedNow, TicketProject: "AA"}, strings.NewReader(""), &out))
	cfg, _ := config.Load(filepath.Join(dir, config.FileName))
	if len(cfg.Plugins) != 1 || cfg.Plugins[0].Name != "ent-plugin" {
		t.Errorf("enterprise plugin not layered: %v", cfg.Plugins)
	}
	if cfg.Conventions.Branch.Pattern != "team/{id}" {
		t.Errorf("team should win over enterprise: %s", cfg.Conventions.Branch.Pattern)
	}
	if cfg.Organisation != nil {
		t.Error("project config must not carry the organisation pointer")
	}
}

func TestInit_WritesCommitMsgHookOnceAndItRejectsBadMessages(t *testing.T) {
	dir := t.TempDir()
	runInit(t, dir, func(o *Options) { o.TicketProject = "AA" })
	hook := filepath.Join(dir, ".git", "hooks", "commit-msg")
	b, err := os.ReadFile(hook)
	if err != nil {
		t.Fatalf("hook not written: %v", err)
	}
	s := string(b)
	if !strings.Contains(s, "feat|fix|docs") || !strings.Contains(s, "agent attribution") {
		t.Errorf("hook lacks the types or the attribution check:\n%s", s)
	}
	// aa init never overwrites a hook the project already has
	if err := os.WriteFile(hook, []byte("#!/bin/sh\n# mine\n"), 0o755); err != nil {
		t.Fatal(err)
	}
	runInit(t, dir, nil)
	after, _ := os.ReadFile(hook)
	if string(after) != "#!/bin/sh\n# mine\n" {
		t.Error("second run overwrote the project's own hook")
	}
	// The hook's checks, exercised through sh when one is available
	sh, err := execLookPath("sh")
	if err != nil {
		t.Skip("no sh on this machine to exercise the hook")
	}
	if err := os.WriteFile(hook, b, 0o755); err != nil {
		t.Fatal(err)
	}
	cases := map[string]bool{
		"feat(cli): add update verb\n\nAA-12\n": true,
		"Update stuff\n":                        false,
		"fix: a thing\n\nCo-Authored-By: Claude <noreply@anthropic.com>\n":            false,
		"docs(readme): explain install\n\nCo-Authored-By: A Person <a@example.com>\n": true,
	}
	for msg, want := range cases {
		f := filepath.Join(t.TempDir(), "msg")
		if err := os.WriteFile(f, []byte(msg), 0o644); err != nil {
			t.Fatal(err)
		}
		got := runHook(sh, hook, f) == nil
		if got != want {
			t.Errorf("message %q: accepted=%v, want %v", msg, got, want)
		}
	}
}

func TestInit_ShStubs(t *testing.T) {
	dir := t.TempDir()
	runInit(t, dir, func(o *Options) { o.Shell = "sh"; o.TicketProject = "AA" })
	b, err := os.ReadFile(filepath.Join(dir, "test.sh"))
	if err != nil || !strings.HasPrefix(string(b), "#!/bin/sh") {
		t.Errorf("want a POSIX sh stub: %v", err)
	}
}

// harnessHome makes a home where Claude Code and Gemini CLI are "installed", with a user config
// in which aa setup recorded them and Windsurf. AA_HOME keeps the PATH out of detection.
func harnessHome(t *testing.T) (home, userPath string) {
	t.Helper()
	home = filepath.Join(t.TempDir(), "home")
	for _, d := range []string{".claude", ".gemini"} {
		if err := os.MkdirAll(filepath.Join(home, d), 0o755); err != nil {
			t.Fatal(err)
		}
	}
	t.Setenv("AA_HOME", home)
	userPath = filepath.Join(home, ".aa", config.FileName)
	if err := config.Write(userPath, &config.Config{Version: 1, Scope: "user", Targets: []string{"claude-code", "gemini-cli", "windsurf"}}, "test"); err != nil {
		t.Fatal(err)
	}
	return home, userPath
}

func initHarnesses(t *testing.T, dir string, opts Options, input string) string {
	t.Helper()
	opts.Path, opts.Now, opts.TicketProject = dir, fixedNow, "AA"
	var out bytes.Buffer
	if err := Run(opts, strings.NewReader(input), &out); err != nil {
		t.Fatalf("init failed: %v\n%s", err, out.String())
	}
	return out.String()
}

func recordedTargets(t *testing.T, dir string) []string {
	t.Helper()
	cfg, err := config.Load(filepath.Join(dir, config.FileName))
	if err != nil || cfg == nil {
		t.Fatalf("project config: %v", err)
	}
	return cfg.Targets
}

func TestInit_AsksWhichHarnessesTheRepositoryGets(t *testing.T) {
	home, userPath := harnessHome(t)
	dir := t.TempDir()
	// Decline git init; then offered: 1 Claude Code, 2 Gemini CLI, neither ticked; tick Claude Code.
	out := initHarnesses(t, dir, Options{Interactive: true, Home: home, UserConfigPath: userPath}, "n\n1\n\n")

	if !strings.Contains(out, "Which agent harnesses should this repository have?") || strings.Contains(out, "Windsurf") {
		t.Errorf("want a checklist of the harnesses found on this machine only:\n%s", out)
	}
	if _, err := os.Stat(filepath.Join(dir, ".claude", "skills", "aa-fw-health", "SKILL.md")); err != nil {
		t.Errorf("the ticked harness was not installed: %v", err)
	}
	for _, d := range []string{".gemini", ".windsurf"} {
		if _, err := os.Stat(filepath.Join(dir, d)); err == nil {
			t.Errorf("%s was created for a harness that was not ticked", d)
		}
	}
	if got := recordedTargets(t, dir); len(got) != 1 || got[0] != "claude-code" {
		t.Errorf("project config targets = %v, want [claude-code]", got)
	}
}

func TestInit_WithNobodyToAskKeepsOnlyTheRepositorysOwnHarnesses(t *testing.T) {
	home, userPath := harnessHome(t)

	empty := t.TempDir()
	out := initHarnesses(t, empty, Options{Home: home, UserConfigPath: userPath}, "")
	for _, d := range []string{".claude", ".gemini", ".windsurf"} {
		if _, err := os.Stat(filepath.Join(empty, d)); err == nil {
			t.Errorf("%s was created though nobody chose it", d)
		}
	}
	if !strings.Contains(out, "aa init -targets") || len(recordedTargets(t, empty)) != 0 {
		t.Errorf("want nothing installed or recorded, and the -targets hint:\n%s", out)
	}

	withClaude := t.TempDir()
	if err := os.MkdirAll(filepath.Join(withClaude, ".claude"), 0o755); err != nil {
		t.Fatal(err)
	}
	initHarnesses(t, withClaude, Options{Yes: true, Home: home, UserConfigPath: userPath}, "")
	if _, err := os.Stat(filepath.Join(withClaude, ".gemini")); err == nil {
		t.Error(".gemini was created though the repository only has .claude")
	}
	if got := recordedTargets(t, withClaude); len(got) != 1 || got[0] != "claude-code" {
		t.Errorf("project config targets = %v, want [claude-code]", got)
	}
}

func TestInit_RecordedHarnessesAreNotAskedAgain(t *testing.T) {
	home, userPath := harnessHome(t)
	dir := t.TempDir()
	initHarnesses(t, dir, Options{Targets: []string{"claude-code"}, Home: home, UserConfigPath: userPath}, "")
	out := initHarnesses(t, dir, Options{Interactive: true, Home: home, UserConfigPath: userPath}, "n\n2\n\n")
	if strings.Contains(out, "Which agent harnesses") || !strings.Contains(out, "harnesses from "+config.FileName+": Claude Code") {
		t.Errorf("want the recorded harnesses used without asking:\n%s", out)
	}
	if _, err := os.Stat(filepath.Join(dir, ".gemini")); err == nil {
		t.Error(".gemini was created on a re-run")
	}
}

func TestInit_UnknownTargetIsRefused(t *testing.T) {
	home, userPath := harnessHome(t)
	var out bytes.Buffer
	err := Run(Options{Path: t.TempDir(), Targets: []string{"nope"}, Home: home, UserConfigPath: userPath, Now: fixedNow}, strings.NewReader(""), &out)
	if err == nil || !strings.Contains(err.Error(), "nope") {
		t.Errorf("want an error naming the unknown target, got %v", err)
	}
}

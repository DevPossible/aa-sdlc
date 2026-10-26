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
	"aasdlc.com/aa/internal/targets"
)

// F-009-02, F-009-05: update all recorded targets without changing project-owned artifacts.
func TestUpdate_RefreshesDeliveryForkAcrossRecordedTargets(t *testing.T) {
	home := t.TempDir()
	project := t.TempDir()
	userPath := filepath.Join(home, ".aa", config.FileName)
	chosen := []string{"codex", "claude-code", "hermes"}
	var out bytes.Buffer
	if err := setupcmd.Run(setupcmd.Options{Run: present, Home: home, UserConfigPath: userPath, Targets: chosen}, &out); err != nil {
		t.Fatal(err)
	}
	if err := initcmd.Run(initcmd.Options{Run: present, Path: project, Yes: true, Targets: chosen, Home: home, UserConfigPath: userPath, TicketProject: "AA"}, strings.NewReader(""), &out); err != nil {
		t.Fatal(err)
	}

	// Real installation layouts: Hermes shares .agents at project scope.
	// Preserve every non-framework artifact while replacing only old core instructions.
	cfgPath := filepath.Join(project, config.FileName)
	configBefore, err := os.ReadFile(cfgPath)
	if err != nil {
		t.Fatal(err)
	}
	custom := filepath.Join(project, ".claude", "skills", "project-only", "SKILL.md")
	if err := os.MkdirAll(filepath.Dir(custom), 0o755); err != nil {
		t.Fatal(err)
	}
	customContent := []byte("project-owned instructions\n")
	if err := os.WriteFile(custom, customContent, 0o644); err != nil {
		t.Fatal(err)
	}

	expected := map[string][]byte{}
	for _, scope := range []targets.Scope{targets.UserScope(home), targets.ProjectScope(project)} {
		roots := []string{".agents/skills", ".claude/skills"}
		if scope.Name == "user" {
			roots = append(roots, ".hermes/skills")
		}
		for _, root := range roots {
			policy := filepath.Join(scope.Dir, filepath.FromSlash(root), "aa-guidance", "sets", "code-change.md")
			if _, err := os.Stat(policy); err != nil {
				t.Fatalf("recorded target %s has no delivery guidance at %s: %v", scope.Name, root, err)
			}
		}
		for path := range targets.Snapshot(scope) {
			if !strings.Contains(path, "/aa-guidance/") && !strings.HasSuffix(path, "/aa-dev-implement/SKILL.md") && !strings.HasSuffix(path, "/aa-dev-review/SKILL.md") {
				continue
			}
			full := filepath.Join(scope.Dir, filepath.FromSlash(path))
			content, err := os.ReadFile(full)
			if err != nil {
				t.Fatal(err)
			}
			if strings.HasSuffix(path, "/code-change.md") {
				for _, rule := range []string{"G-59", "G-60", "G-61", "standing permission"} {
					if !bytes.Contains(content, []byte(rule)) {
						t.Fatalf("installed %s is missing delivery policy %q", path, rule)
					}
				}
			}
			expected[full] = content
			if err := os.WriteFile(full, []byte("old project fork\n"), 0o644); err != nil {
				t.Fatal(err)
			}
		}
	}
	if len(expected) == 0 {
		t.Fatal("no framework instructions selected for update")
	}
	out.Reset()
	if err := Run(Options{Path: project, Home: home, UserConfigPath: userPath}, &out); err != nil {
		t.Fatalf("update: %v\n%s", err, out.String())
	}
	for path, want := range expected {
		if got, err := os.ReadFile(path); err != nil || !bytes.Equal(got, want) {
			t.Errorf("core instructions were not restored exactly at %s: %v", path, err)
		}
	}
	if got, err := os.ReadFile(cfgPath); err != nil || !bytes.Equal(got, configBefore) {
		t.Errorf("update changed project configuration: %v", err)
	}
	if got, err := os.ReadFile(custom); err != nil || !bytes.Equal(got, customContent) {
		t.Errorf("update changed project-owned instructions: %v", err)
	}
}

func TestUpdate_ReportsMalformedConfigurationAndPreservesUnknownTargets(t *testing.T) {
	for _, tc := range []struct {
		name, scope, contents string
		wantError             bool
	}{
		{"malformed user config", "user", "version: [broken", true},
		{"malformed project config", "project", "version: [broken", true},
		{"unknown user target", "user", "version: 1\nscope: user\ntargets: [missing-target]\n", false},
		{"unknown project target", "project", "version: 1\nscope: project\ntargets: [missing-target]\n", false},
	} {
		t.Run(tc.name, func(t *testing.T) {
			home := t.TempDir()
			project := t.TempDir()
			userPath := filepath.Join(home, ".aa", config.FileName)
			projectPath := filepath.Join(project, config.FileName)
			for path, contents := range map[string]string{
				userPath:    "version: 1\nscope: user\ntargets: [claude-code]\n",
				projectPath: "version: 1\nscope: project\ntargets: [claude-code]\n",
				filepath.Join(project, ".claude", "skills", "aa-fw-health", "SKILL.md"): "old core instructions\n",
			} {
				if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
					t.Fatal(err)
				}
				if err := os.WriteFile(path, []byte(contents), 0o644); err != nil {
					t.Fatal(err)
				}
			}
			invalid := userPath
			if tc.scope == "project" {
				invalid = projectPath
			}
			if err := os.WriteFile(invalid, []byte(tc.contents), 0o644); err != nil {
				t.Fatal(err)
			}
			var out bytes.Buffer
			err := Run(Options{Path: project, Home: home, UserConfigPath: userPath}, &out)
			if (err != nil) != tc.wantError {
				t.Fatalf("update error = %v, want error %t:\n%s", err, tc.wantError, out.String())
			}
			if tc.wantError || tc.scope == "project" {
				if got, err := os.ReadFile(invalid); err != nil || string(got) != tc.contents {
					t.Errorf("update rewrote project or malformed configuration: %v", err)
				}
			} else {
				updated, err := config.Load(invalid)
				if err != nil || updated == nil || len(updated.Targets) != 1 || updated.Targets[0] != "missing-target" {
					t.Fatalf("update lost the user's unsupported target: %v", err)
				}
				if !strings.Contains(out.String(), "missing-target") || !strings.Contains(out.String(), "skipped") {
					t.Error("unsupported user target was not reported as skipped")
				}
			}
		})
	}
}

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

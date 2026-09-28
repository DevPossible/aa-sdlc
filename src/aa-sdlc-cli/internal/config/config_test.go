package config

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestMerge_LaterScopeWins_ListsUnion_FoldersDeepMerge(t *testing.T) {
	enterprise := &Config{Version: 1, Scope: "enterprise", Plugins: []PluginRef{{Name: "gitlab-flow"}}, Targets: []string{"claude-code"},
		Conventions: Conventions{Commit: Commit{Types: []string{"feat", "fix"}}}, Folders: map[string]string{"documents": "documentation"}}
	team := &Config{Version: 1, Scope: "team", Plugins: []PluginRef{{Name: "dotnet"}}, Conventions: Conventions{Ticket: Ticket{Pattern: `TEAM-\d+`}}}
	user := &Config{Version: 1, Scope: "user", Targets: []string{"claude-code", "codex"}}
	project := &Config{Version: 1, Scope: "project", Conventions: Conventions{Ticket: Ticket{Project: "AA"}}, Folders: map[string]string{"features": "specs"}}

	got, err := Merge(enterprise, team, user, project)
	if err != nil {
		t.Fatal(err)
	}
	if got.Scope != "project" {
		t.Errorf("scope: want project, got %s", got.Scope)
	}
	if len(got.Plugins) != 2 || got.Plugins[0].Name != "gitlab-flow" || got.Plugins[1].Name != "dotnet" {
		t.Errorf("plugins: want union in scope order, got %v", got.Plugins)
	}
	if len(got.Targets) != 2 {
		t.Errorf("targets: want union without duplicates, got %v", got.Targets)
	}
	if got.Conventions.Ticket.Project != "AA" || got.Conventions.Ticket.Pattern != `TEAM-\d+` {
		t.Errorf("ticket: project from project scope and pattern from team scope, got %+v", got.Conventions.Ticket)
	}
	if len(got.Conventions.Commit.Types) != 2 {
		t.Errorf("commit types: want enterprise list kept, got %v", got.Conventions.Commit.Types)
	}
	if got.Folders["documents"] != "documentation" || got.Folders["features"] != "specs" {
		t.Errorf("folders: want deep merge, got %v", got.Folders)
	}
}

func TestMerge_ExcludeRemovesInheritedPlugin(t *testing.T) {
	got, err := Merge(&Config{Version: 1, Plugins: []PluginRef{{Name: "a"}, {Name: "b"}}}, &Config{Version: 1, PluginsExclude: []string{"a"}})
	if err != nil {
		t.Fatal(err)
	}
	if len(got.Plugins) != 1 || got.Plugins[0].Name != "b" {
		t.Errorf("want [b], got %v", got.Plugins)
	}
}

func TestMerge_VersionMismatchIsAnError(t *testing.T) {
	if _, err := Merge(&Config{Version: 1}, &Config{Version: 2}); err == nil {
		t.Error("want an error for mismatched versions")
	}
}

func TestWriteThenLoad_RoundTrips(t *testing.T) {
	dir := t.TempDir()
	p := filepath.Join(dir, FileName)
	in := Defaults()
	in.Scope = "project"
	in.Conventions.Ticket.Project = "AA"
	if err := Write(p, &in, "header line one\nheader line two"); err != nil {
		t.Fatal(err)
	}
	b, _ := os.ReadFile(p)
	if string(b[:2]) != "# " {
		t.Errorf("want a comment header, got %q", string(b[:20]))
	}
	out, err := Load(p)
	if err != nil {
		t.Fatal(err)
	}
	if out.Conventions.Ticket.Project != "AA" || out.Folders["decisions"] != "docs/decisions" || len(out.Conventions.Commit.Types) != len(DefaultCommitTypes) {
		t.Errorf("round trip lost data: %+v", out)
	}
}

func TestLoad_MissingFileIsNil(t *testing.T) {
	c, err := Load(filepath.Join(t.TempDir(), "nope.yaml"))
	if err != nil || c != nil {
		t.Errorf("want nil, nil; got %v, %v", c, err)
	}
}

func TestLoadScopes_ReadsEnterpriseAndTeamFromLocalOrganisationRepository(t *testing.T) {
	dir := t.TempDir()
	org := filepath.Join(dir, "org")
	if err := os.MkdirAll(filepath.Join(org, "platform"), 0o755); err != nil {
		t.Fatal(err)
	}
	must := func(err error) {
		if err != nil {
			t.Fatal(err)
		}
	}
	must(Write(filepath.Join(org, FileName), &Config{Version: 1, Scope: "enterprise", Plugins: []PluginRef{{Name: "ent"}}}, "e"))
	must(Write(filepath.Join(org, "platform", FileName), &Config{Version: 1, Scope: "team", Plugins: []PluginRef{{Name: "team"}}}, "t"))
	userPath := filepath.Join(dir, "user", FileName)
	must(Write(userPath, &Config{Version: 1, Scope: "user", Organisation: &Organisation{Repository: org, Team: "platform"}}, "u"))

	scopes, err := LoadScopes(userPath)
	if err != nil {
		t.Fatal(err)
	}
	if len(scopes) != 3 || scopes[0].Scope != "enterprise" || scopes[1].Scope != "team" || scopes[2].Scope != "user" {
		t.Fatalf("want enterprise, team, user; got %d scopes", len(scopes))
	}
	merged, _ := Merge(scopes...)
	if len(merged.Plugins) != 2 {
		t.Errorf("want plugins from enterprise and team, got %v", merged.Plugins)
	}
}

func TestPlugins_ReadPlainNamesAndMappings(t *testing.T) {
	path := filepath.Join(t.TempDir(), FileName)
	body := "version: 1\nplugins:\n  - dotnet\n  - name: k6\n    version: 0.2.0\n    source: ../plugins/k6\n"
	if err := os.WriteFile(path, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
	c, err := Load(path)
	if err != nil {
		t.Fatal(err)
	}
	want := []PluginRef{{Name: "dotnet"}, {Name: "k6", Version: "0.2.0", Source: "../plugins/k6"}}
	if len(c.Plugins) != 2 || c.Plugins[0] != want[0] || c.Plugins[1] != want[1] {
		t.Fatalf("want %v, got %v", want, c.Plugins)
	}
	if err := Write(path, c, "h"); err != nil {
		t.Fatal(err)
	}
	b, _ := os.ReadFile(path)
	if !strings.Contains(string(b), "- dotnet\n") || !strings.Contains(string(b), "- name: k6\n") {
		t.Errorf("a name-only entry writes as a plain name and a recorded one as a mapping:\n%s", b)
	}
}

func TestMerge_LaterScopeRecordsThePluginSource(t *testing.T) {
	got, err := Merge(&Config{Version: 1, Plugins: []PluginRef{{Name: "k6"}}}, &Config{Version: 1, Plugins: []PluginRef{{Name: "k6", Version: "0.2.0", Source: "organisation"}}})
	if err != nil {
		t.Fatal(err)
	}
	if len(got.Plugins) != 1 || got.Plugins[0].Source != "organisation" {
		t.Errorf("want one k6 entry with the later scope's source, got %v", got.Plugins)
	}
}

func TestMerge_TicketStatesMergePerKey(t *testing.T) {
	team := &Config{Version: 1, Conventions: Conventions{Ticket: Ticket{States: map[string]string{"new": "To Do", "done": "Closed"}}}}
	project := &Config{Version: 1, Conventions: Conventions{Ticket: Ticket{States: map[string]string{"done": "Done"}}}}
	got, err := Merge(team, project)
	if err != nil {
		t.Fatal(err)
	}
	if got.Conventions.Ticket.States["new"] != "To Do" || got.Conventions.Ticket.States["done"] != "Done" {
		t.Errorf("want per-key merge with the later scope winning, got %v", got.Conventions.Ticket.States)
	}
}

func TestDefaults_MapTheLifeCycleAndSections(t *testing.T) {
	d := Defaults()
	if len(d.Conventions.Ticket.Kinds) != 5 || len(d.Conventions.Ticket.States) != 7 || len(d.Conventions.Knowledge.Sections) != 6 {
		t.Errorf("defaults: kinds %v, states %v, sections %v", d.Conventions.Ticket.Kinds, d.Conventions.Ticket.States, d.Conventions.Knowledge.Sections)
	}
}

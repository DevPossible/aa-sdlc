package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestMerge_LaterScopeWins_ListsUnion_FoldersDeepMerge(t *testing.T) {
	enterprise := &Config{Version: 1, Scope: "enterprise", Plugins: []string{"gitlab-flow"}, Targets: []string{"claude-code"},
		Conventions: Conventions{Commit: Commit{Types: []string{"feat", "fix"}}}, Folders: map[string]string{"documents": "documentation"}}
	team := &Config{Version: 1, Scope: "team", Plugins: []string{"dotnet"}, Conventions: Conventions{Ticket: Ticket{Pattern: `TEAM-\d+`}}}
	user := &Config{Version: 1, Scope: "user", Targets: []string{"claude-code", "codex"}}
	project := &Config{Version: 1, Scope: "project", Conventions: Conventions{Ticket: Ticket{Project: "AA"}}, Folders: map[string]string{"features": "specs"}}

	got, err := Merge(enterprise, team, user, project)
	if err != nil {
		t.Fatal(err)
	}
	if got.Scope != "project" {
		t.Errorf("scope: want project, got %s", got.Scope)
	}
	if len(got.Plugins) != 2 || got.Plugins[0] != "gitlab-flow" || got.Plugins[1] != "dotnet" {
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
	got, err := Merge(&Config{Version: 1, Plugins: []string{"a", "b"}}, &Config{Version: 1, PluginsExclude: []string{"a"}})
	if err != nil {
		t.Fatal(err)
	}
	if len(got.Plugins) != 1 || got.Plugins[0] != "b" {
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
	must(Write(filepath.Join(org, FileName), &Config{Version: 1, Scope: "enterprise", Plugins: []string{"ent"}}, "e"))
	must(Write(filepath.Join(org, "platform", FileName), &Config{Version: 1, Scope: "team", Plugins: []string{"team"}}, "t"))
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

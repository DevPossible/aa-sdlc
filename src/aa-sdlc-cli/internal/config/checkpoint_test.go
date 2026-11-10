package config

import (
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

// F-094-08: literal YAML proves the public config contract survives unrelated writes.
func TestCheckpointPolicyRoundTrip(t *testing.T) {
	path := filepath.Join(t.TempDir(), FileName)
	const body = `version: 1
scope: project
testing:
  fullSuite:
    mode: checkpoint
    integrationBranch: develop
    perMerge: [build, lint, smoke, changed-components, security]
    checkpointBefore: [release, exposure, demonstration]
    backstop: {merges: 10, days: 3}
`
	if err := os.WriteFile(path, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
	c, err := Load(path)
	if err != nil {
		t.Fatal(err)
	}
	// Mutate an unrelated field as setup/init/plugin operations do.
	c.Conventions.Ticket.Project = "ABC"
	if err := Write(path, c, "updated config"); err != nil {
		t.Fatal(err)
	}
	b, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	for _, literal := range []string{"mode: checkpoint", "integrationBranch: develop", "- build", "- lint", "- smoke", "- changed-components", "- security", "- release", "- exposure", "- demonstration", "merges: 10", "days: 3"} {
		if !strings.Contains(string(b), literal) {
			t.Errorf("policy lost %q in unrelated write:\n%s", literal, b)
		}
	}
	got, err := Load(path)
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(c, got) {
		t.Fatalf("round trip changed config: want %+v, got %+v", c, got)
	}
}

// F-094-08: each scope either inherits or replaces the entire policy.
func TestMergeCheckpointPolicy(t *testing.T) {
	checkpoint := &Testing{FullSuite: &FullSuite{
		Mode: "checkpoint", IntegrationBranch: "develop",
		PerMerge:         []string{"build", "lint", "smoke", "changed-components"},
		CheckpointBefore: []string{"release", "exposure"}, Backstop: &Backstop{Merges: 10, Days: 3},
	}}
	for _, tc := range []struct {
		name  string
		later *Testing
		want  *Testing
	}{
		{"absent testing inherits", nil, checkpoint},
		{"absent policy inherits", &Testing{}, checkpoint},
		{"explicit per-branch replaces", &Testing{FullSuite: &FullSuite{Mode: "per-branch"}}, &Testing{FullSuite: &FullSuite{Mode: "per-branch"}}},
		{"absent mode replaces with default", &Testing{FullSuite: &FullSuite{}}, &Testing{FullSuite: &FullSuite{}}},
		{"new checkpoint replaces old branch and backstop", &Testing{FullSuite: &FullSuite{Mode: "checkpoint", IntegrationBranch: "trunk", PerMerge: []string{"build", "lint", "smoke", "changed-components"}, CheckpointBefore: []string{"demonstration"}}}, &Testing{FullSuite: &FullSuite{Mode: "checkpoint", IntegrationBranch: "trunk", PerMerge: []string{"build", "lint", "smoke", "changed-components"}, CheckpointBefore: []string{"demonstration"}}}},
	} {
		t.Run(tc.name, func(t *testing.T) {
			got, err := Merge(&Config{Version: 1, Scope: "enterprise", Testing: checkpoint}, &Config{Version: 1, Scope: "project", Testing: tc.later})
			if err != nil {
				t.Fatal(err)
			}
			if !reflect.DeepEqual(got.Testing, tc.want) {
				t.Errorf("want policy %+v, got %+v", tc.want, got.Testing)
			}
		})
	}
}

// F-094-01: omitted policies stay omitted across reads, merges and writes.
func TestAbsentCheckpointPolicyStaysDefault(t *testing.T) {
	c := Defaults()
	c.Scope = "project"
	got, err := Merge(&c, &Config{Version: 1, Scope: "project"})
	if err != nil {
		t.Fatal(err)
	}
	path := filepath.Join(t.TempDir(), FileName)
	if err := Write(path, got, "default policy"); err != nil {
		t.Fatal(err)
	}
	loaded, err := Load(path)
	if err != nil {
		t.Fatal(err)
	}
	if loaded.Testing != nil {
		t.Fatalf("absent policy must retain per-branch default, got %+v", loaded.Testing)
	}
}

func TestLoadRejectsMalformedCheckpointFields(t *testing.T) {
	for _, field := range []string{
		"mode: []", "integrationBranch: []", "perMerge: build", "checkpointBefore: release",
		"backstop: []", "backstop: {days: tomorrow}",
	} {
		t.Run(field, func(t *testing.T) {
			path := filepath.Join(t.TempDir(), FileName)
			body := "version: 1\nscope: project\ntesting:\n  fullSuite:\n    " + field + "\n"
			if err := os.WriteFile(path, []byte(body), 0o644); err != nil {
				t.Fatal(err)
			}
			if _, err := Load(path); err == nil {
				t.Fatal("want a decoding error for malformed checkpoint field")
			}
		})
	}
}

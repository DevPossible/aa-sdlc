package targets

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func specs(t *testing.T, ids ...string) []Spec {
	t.Helper()
	found, unknown, err := ByID(ids)
	if err != nil || len(unknown) > 0 {
		t.Fatalf("ByID(%v): %v, unknown %v", ids, err, unknown)
	}
	return found
}

func TestTable_EverySupportedTargetCanBeInstalled(t *testing.T) {
	all, err := All()
	if err != nil {
		t.Fatal(err)
	}
	seen := map[string]bool{}
	for _, s := range all {
		if seen[s.ID] {
			t.Errorf("%s appears twice", s.ID)
		}
		seen[s.ID] = true
		if s.Source == "" {
			t.Errorf("%s names no documentation source", s.ID)
		}
		if !s.Supported() {
			if s.Reason == "" {
				t.Errorf("%s is unsupported without a reason", s.ID)
			}
			continue
		}
		if len(s.Skills.User) == 0 || len(s.Skills.Project) == 0 {
			t.Errorf("%s has no skill folder at one of the scopes", s.ID)
		}
		if len(s.Detect.Home) == 0 && s.Detect.Command == "" {
			t.Errorf("%s cannot be detected", s.ID)
		}
		if c := s.Commands; c != nil && (c.User == "" || c.Project == "" || (c.Format != FormatMarkdownArguments && c.Format != FormatGeminiTOML && c.Format != FormatMarkdownBraces)) {
			t.Errorf("%s has an incomplete command entry: %+v", s.ID, *c)
		}
	}
}

func TestPlan_SharedFolderReachesEveryHarnessOnce(t *testing.T) {
	plan := PlanInstall(UserScope("home"), specs(t, "claude-code", "codex", "gemini-cli"))
	if got := strings.Join(plan.SkillDirs, ","); got != ".claude/skills,.agents/skills" {
		t.Errorf("skill folders: got %s", got)
	}
	for _, id := range []string{"claude-code", "codex", "gemini-cli"} {
		if len(plan.Reads[id]) != 1 {
			t.Errorf("%s reads %v; want exactly one planned folder", id, plan.Reads[id])
		}
	}
	formats := map[string]string{}
	for _, set := range plan.Commands {
		formats[set.Format] = set.Dir
	}
	if formats[FormatGeminiTOML] != ".gemini/commands" || formats[FormatMarkdownArguments] != ".claude/commands" {
		t.Errorf("command folders: got %v", formats)
	}
}

func TestPlan_DualReaderIsReportedNotDuplicated(t *testing.T) {
	plan := PlanInstall(ProjectScope("repo"), specs(t, "claude-code", "codex", "cursor"))
	if len(plan.SkillDirs) != 2 {
		t.Errorf("want two folders, got %v", plan.SkillDirs)
	}
	if len(plan.Reads["cursor"]) != 2 {
		t.Errorf("cursor should be seen reading both planned folders, got %v", plan.Reads["cursor"])
	}
}

func TestPlan_AloneAHarnessGetsTheSharedFolderWhereItReadsIt(t *testing.T) {
	plan := PlanInstall(UserScope("home"), specs(t, "cursor"))
	if got := strings.Join(plan.SkillDirs, ","); got != ".agents/skills" {
		t.Errorf("got %s", got)
	}
}

func TestInstructionBlock_WrittenReplacedAndRemovedWithoutTouchingTheRest(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "AGENTS.md")
	if err := os.WriteFile(path, []byte("# Ours\n\nKeep me.\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	if _, err := WriteInstructionBlock(dir, "AGENTS.md", "first"); err != nil {
		t.Fatal(err)
	}
	if _, err := WriteInstructionBlock(dir, "AGENTS.md", "second"); err != nil {
		t.Fatal(err)
	}
	b, _ := os.ReadFile(path)
	s := string(b)
	if strings.Count(s, blockBegin) != 1 || !strings.Contains(s, "second") || strings.Contains(s, "first") || !strings.Contains(s, "Keep me.") {
		t.Fatalf("after two writes:\n%s", s)
	}
	if _, err := RemoveInstructionBlock(dir, "AGENTS.md"); err != nil {
		t.Fatal(err)
	}
	b, _ = os.ReadFile(path)
	if string(b) != "# Ours\n\nKeep me.\n" {
		t.Fatalf("after removal the file should be as it was, got %q", b)
	}

	if _, err := WriteInstructionBlock(dir, "CLAUDE.md", "only ours"); err != nil {
		t.Fatal(err)
	}
	if _, err := RemoveInstructionBlock(dir, "CLAUDE.md"); err != nil {
		t.Fatal(err)
	}
	if _, err := os.Stat(filepath.Join(dir, "CLAUDE.md")); !os.IsNotExist(err) {
		t.Error("a file that held only our block should be deleted with it")
	}
}

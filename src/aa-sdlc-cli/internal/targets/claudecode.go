// Package targets adapts the content package to each agent target. Only what differs per
// target lives here: where skills go, how a command file is written, how the target is
// detected. The skills themselves are identical on every target (decision 5).
package targets

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"aasdlc.com/aa/internal/content"
)

// Target is an agent the CLI can install into.
type Target struct {
	ID   string
	Name string
}

// ClaudeCode is the first supported target.
var ClaudeCode = Target{ID: "claude-code", Name: "Claude Code"}

// Supported lists every target the CLI knows how to install into.
var Supported = []Target{ClaudeCode}

// Detect returns the supported targets present on this machine or in this repository.
// Claude Code is present when the user has a ~/.claude folder, the repository has a .claude
// folder, or the claude command is on the PATH.
func Detect(home, repo string) []Target {
	var found []Target
	if isDir(filepath.Join(home, ".claude")) || (repo != "" && isDir(filepath.Join(repo, ".claude"))) || onPath("claude") {
		found = append(found, ClaudeCode)
	}
	return found
}

// InstallResult says what an install wrote.
type InstallResult struct {
	Skills   int
	Commands int
}

// InstallClaudeCode writes the package's skills and one command per skill under dir/.claude.
// skillRef is the path the command file tells the agent to read, relative to how the agent
// will resolve it: ".claude/skills/..." at project scope, "~/.claude/skills/..." at user scope.
// Existing installed skills and commands are overwritten, because they belong to the package;
// nothing else under dir/.claude is touched.
func InstallClaudeCode(dir string, skillRefPrefix string) (InstallResult, error) {
	var res InstallResult
	steps, err := content.Steps()
	if err != nil {
		return res, err
	}
	disciplines, err := content.Disciplines()
	if err != nil {
		return res, err
	}
	stepByID := map[string]content.Step{}
	for _, s := range steps {
		stepByID[s.ID] = s
	}
	skills, err := content.Skills()
	if err != nil {
		return res, err
	}
	for _, sk := range skills {
		step, ok := stepByID[sk.StepID]
		if !ok {
			return res, fmt.Errorf("skill %s has no workflow step", sk.StepID)
		}
		d, ok := disciplines[step.Discipline]
		if !ok {
			return res, fmt.Errorf("step %s names unknown discipline %s", step.ID, step.Discipline)
		}
		name := fmt.Sprintf("aa-%s-%s", d.Code, step.ID)
		skillDir := filepath.Join(dir, ".claude", "skills", name)
		for rel, b := range sk.Files {
			p := filepath.Join(skillDir, filepath.FromSlash(rel))
			if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
				return res, err
			}
			if err := os.WriteFile(p, b, 0o644); err != nil {
				return res, err
			}
		}
		res.Skills++

		cmdDir := filepath.Join(dir, ".claude", "commands")
		if err := os.MkdirAll(cmdDir, 0o755); err != nil {
			return res, err
		}
		ref := skillRefPrefix + "/" + name + "/SKILL.md"
		body := fmt.Sprintf("---\ndescription: %s\n---\nRead %s and follow it exactly, with these arguments: $ARGUMENTS\n", oneLine(step.Summary), ref)
		if err := os.WriteFile(filepath.Join(cmdDir, name+".md"), []byte(body), 0o644); err != nil {
			return res, err
		}
		res.Commands++
	}
	return res, nil
}

func oneLine(s string) string {
	return strings.Join(strings.Fields(s), " ")
}

func isDir(p string) bool {
	info, err := os.Stat(p)
	return err == nil && info.IsDir()
}

func onPath(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

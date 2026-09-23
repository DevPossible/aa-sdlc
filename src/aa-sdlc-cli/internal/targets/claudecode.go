// Package targets adapts the content package to each agent target. Only what differs per
// target lives here: where skills go, how a command file is written, how the target is
// detected. The skills themselves are identical on every target (decision 5).
package targets

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
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
// folder, or the claude command is on the PATH. When AA_HOME relocates the home (decision
// record 0005), detection is confined to that home and the repository, so a test or an
// isolated install is not influenced by what the machine happens to have on its PATH.
func Detect(home, repo string) []Target {
	var found []Target
	isolated := os.Getenv("AA_HOME") != ""
	if isDir(filepath.Join(home, ".claude")) || (repo != "" && isDir(filepath.Join(repo, ".claude"))) || (!isolated && onPath("claude")) {
		found = append(found, ClaudeCode)
	}
	return found
}

// InstallResult says what an install wrote.
type InstallResult struct {
	Skills   int
	Commands int
	Written  []string // every path written, relative to dir, for stale-file removal
}

// InstallClaudeCode writes the package's skills and one command per skill under dir/.claude.
// skillRefPrefix is the path the command file tells the agent to read: ".claude/skills" at
// project scope, "~/.claude/skills" at user scope. Existing installed skills and commands are
// overwritten, because they belong to the package; nothing else under dir/.claude is touched.
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
	// The shared guidance sets: one folder beside the skills, no command; every skill's
	// reference to the source path becomes the scope's path (decision record 0012)
	guidancePath := skillRefPrefix + "/" + content.SharedGuidanceDir
	shared, err := content.SharedGuidance()
	if err != nil {
		return res, err
	}
	written, err := writeSkillFiles(dir, content.SharedGuidanceDir, shared)
	if err != nil {
		return res, err
	}
	res.Written = append(res.Written, written...)
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
		files := map[string][]byte{}
		for rel, b := range sk.Files {
			files[rel] = bytes.ReplaceAll(b, []byte(content.SourceGuidancePath), []byte(guidancePath))
		}
		written, err := writeSkillAndCommand(dir, name, files, skillRefPrefix, oneLine(step.Summary))
		if err != nil {
			return res, err
		}
		res.Written = append(res.Written, written...)
		res.Skills++
		res.Commands++
	}
	return res, nil
}

// InstallPluginClaudeCode writes a plugin's skills and commands under dir/.claude, named
// aa-<plugin>-<skill>, and returns the paths written.
func InstallPluginClaudeCode(dir string, p content.Plugin, skillRefPrefix string) (InstallResult, error) {
	var res InstallResult
	for _, sk := range p.Skills {
		name := fmt.Sprintf("aa-%s-%s", p.Name, sk.Name)
		written, err := writeSkillAndCommand(dir, name, sk.Files, skillRefPrefix, sk.Description)
		if err != nil {
			return res, err
		}
		res.Written = append(res.Written, written...)
		res.Skills++
		res.Commands++
	}
	return res, nil
}

// RemovePluginClaudeCode deletes a plugin's skills and commands under dir/.claude and returns
// what it removed. Core skills are named aa-<discipline code>-<step> and are never touched,
// because a plugin's prefix is its own name.
func RemovePluginClaudeCode(dir, plugin string) ([]string, error) {
	var removed []string
	prefix := "aa-" + plugin + "-"
	skillsDir := filepath.Join(dir, ".claude", "skills")
	entries, _ := os.ReadDir(skillsDir)
	for _, e := range entries {
		if e.IsDir() && strings.HasPrefix(e.Name(), prefix) {
			if err := os.RemoveAll(filepath.Join(skillsDir, e.Name())); err != nil {
				return removed, err
			}
			removed = append(removed, filepath.ToSlash(filepath.Join(".claude", "skills", e.Name())))
		}
	}
	cmdDir := filepath.Join(dir, ".claude", "commands")
	cmds, _ := os.ReadDir(cmdDir)
	for _, e := range cmds {
		if !e.IsDir() && strings.HasPrefix(e.Name(), prefix) && strings.HasSuffix(e.Name(), ".md") {
			if err := os.Remove(filepath.Join(cmdDir, e.Name())); err != nil {
				return removed, err
			}
			removed = append(removed, filepath.ToSlash(filepath.Join(".claude", "commands", e.Name())))
		}
	}
	sort.Strings(removed)
	return removed, nil
}

// SnapshotClaudeCode hashes every installed aa-* file under dir/.claude (skills and commands),
// keyed by path relative to dir, so an update can say what it added, changed, and removed.
func SnapshotClaudeCode(dir string) map[string]string {
	snap := map[string]string{}
	for _, sub := range []string{filepath.Join(".claude", "skills"), filepath.Join(".claude", "commands")} {
		root := filepath.Join(dir, sub)
		_ = filepath.WalkDir(root, func(p string, d os.DirEntry, err error) error {
			if err != nil || d.IsDir() {
				return nil
			}
			rel, _ := filepath.Rel(dir, p)
			parts := strings.Split(filepath.ToSlash(rel), "/")
			if len(parts) < 3 || !strings.HasPrefix(parts[2], "aa-") {
				return nil
			}
			b, err := os.ReadFile(p)
			if err != nil {
				return nil
			}
			sum := sha256.Sum256(b)
			snap[filepath.ToSlash(rel)] = hex.EncodeToString(sum[:])
			return nil
		})
	}
	return snap
}

// RemoveStaleClaudeCode deletes installed core files that were present before an install and
// were not written by it, which happens when a step or a file leaves the package. Plugin files
// (aa-<plugin>-*) are left alone: they are not the core install's to remove.
func RemoveStaleClaudeCode(dir string, before map[string]string, written []string) []string {
	keep := map[string]bool{}
	for _, w := range written {
		keep[filepath.ToSlash(w)] = true
	}
	corePrefixes := coreCommandPrefixes()
	var removed []string
	for p := range before {
		if keep[p] {
			continue
		}
		base := strings.Split(p, "/")[2]
		if !hasAnyPrefix(base, corePrefixes) {
			continue
		}
		if err := os.Remove(filepath.Join(dir, filepath.FromSlash(p))); err == nil {
			removed = append(removed, p)
			// drop the skill folder if it is now empty
			_ = os.Remove(filepath.Dir(filepath.Join(dir, filepath.FromSlash(p))))
		}
	}
	sort.Strings(removed)
	return removed
}

func coreCommandPrefixes() []string {
	ds, err := content.Disciplines()
	if err != nil {
		return nil
	}
	out := []string{content.SharedGuidanceDir}
	for _, d := range ds {
		out = append(out, "aa-"+d.Code+"-")
	}
	return out
}

func hasAnyPrefix(s string, prefixes []string) bool {
	for _, p := range prefixes {
		if strings.HasPrefix(s, p) {
			return true
		}
	}
	return false
}

// writeSkillFiles writes a skill folder's files under dir/.claude/skills/<name> and returns the
// paths written, relative to dir.
func writeSkillFiles(dir, name string, files map[string][]byte) ([]string, error) {
	var written []string
	skillDir := filepath.Join(dir, ".claude", "skills", name)
	for rel, b := range files {
		p := filepath.Join(skillDir, filepath.FromSlash(rel))
		if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
			return written, err
		}
		if err := os.WriteFile(p, b, 0o644); err != nil {
			return written, err
		}
		r, _ := filepath.Rel(dir, p)
		written = append(written, filepath.ToSlash(r))
	}
	return written, nil
}

func writeSkillAndCommand(dir, name string, files map[string][]byte, skillRefPrefix, description string) ([]string, error) {
	written, err := writeSkillFiles(dir, name, files)
	if err != nil {
		return written, err
	}
	cmdDir := filepath.Join(dir, ".claude", "commands")
	if err := os.MkdirAll(cmdDir, 0o755); err != nil {
		return written, err
	}
	ref := skillRefPrefix + "/" + name + "/SKILL.md"
	body := fmt.Sprintf("---\ndescription: %s\n---\nRead %s and follow it exactly, with these arguments: $ARGUMENTS\n", yamlQuote(description), ref)
	cmdPath := filepath.Join(cmdDir, name+".md")
	if err := os.WriteFile(cmdPath, []byte(body), 0o644); err != nil {
		return written, err
	}
	r, _ := filepath.Rel(dir, cmdPath)
	written = append(written, filepath.ToSlash(r))
	return written, nil
}

func yamlQuote(s string) string {
	return `"` + strings.ReplaceAll(strings.ReplaceAll(s, `\`, `\\`), `"`, `\"`) + `"`
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

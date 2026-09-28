// Package targets adapts the content package to each agent harness (decision record 0014). What
// differs per harness is data in targets/targets.yaml: where it reads skills, whether it needs
// command files and in which format, how it is detected, and which instruction file it reads.
// The skills themselves are identical on every harness.
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

	"gopkg.in/yaml.v3"

	"aasdlc.com/aa/internal/content"
)

// Spec is one harness from the target table.
type Spec struct {
	ID       string `yaml:"id"`
	Name     string `yaml:"name"`
	Status   string `yaml:"status"`
	Verified bool   `yaml:"verified"`
	Detect   struct {
		Home    []string `yaml:"home"`
		Command string   `yaml:"command"`
	} `yaml:"detect"`
	Skills struct {
		User    []string `yaml:"user"`
		Project []string `yaml:"project"`
	} `yaml:"skills"`
	Commands     *CommandSpec `yaml:"commands"`
	Agents       *AgentSpec   `yaml:"agents"`
	Instructions string       `yaml:"instructions"`
	Subagents    bool         `yaml:"subagents"`
	Reason       string       `yaml:"reason"`
	Source       string       `yaml:"source"`
}

// CommandSpec says where a harness reads command files and in which format.
type CommandSpec struct {
	Format  string `yaml:"format"`
	User    string `yaml:"user"`
	Project string `yaml:"project"`
}

// AgentSpec says where a harness reads subagent definitions and in which format (decision
// record 0015).
type AgentSpec struct {
	Format  string   `yaml:"format"`
	Suffix  string   `yaml:"suffix"`
	User    []string `yaml:"user"`
	Project []string `yaml:"project"`
}

// Agent file formats (targets/targets.yaml).
const (
	AgentMarkdown         = "markdown"
	AgentMarkdownOpenCode = "markdown-opencode"
)

// Command file formats (targets/targets.yaml).
const (
	FormatMarkdownArguments = "markdown-arguments"
	FormatGeminiTOML        = "gemini-toml"
	FormatMarkdownBraces    = "markdown-braces"
)

// Supported reports whether the CLI installs into the harness.
func (t Spec) Supported() bool { return t.Status == "supported" }

// All returns every harness in the target table, in table order.
func All() ([]Spec, error) {
	b, err := content.ReadFile("targets/targets.yaml")
	if err != nil {
		return nil, fmt.Errorf("reading the target table: %w", err)
	}
	var table struct {
		Targets []Spec `yaml:"targets"`
	}
	if err := yaml.Unmarshal(b, &table); err != nil {
		return nil, fmt.Errorf("targets/targets.yaml: %w", err)
	}
	return table.Targets, nil
}

// SupportedNames lists the names of every harness the CLI installs into.
func SupportedNames() []string {
	all, _ := All()
	var names []string
	for _, t := range all {
		if t.Supported() {
			names = append(names, t.Name)
		}
	}
	return names
}

// ByID returns the supported harnesses with the given ids, in table order, and the ids that name
// no supported harness.
func ByID(ids []string) ([]Spec, []string, error) {
	all, err := All()
	if err != nil {
		return nil, nil, err
	}
	want := map[string]bool{}
	for _, id := range ids {
		want[strings.TrimSpace(id)] = true
	}
	var found []Spec
	for _, t := range all {
		if want[t.ID] && t.Supported() {
			found = append(found, t)
			delete(want, t.ID)
		}
	}
	var unknown []string
	for id := range want {
		if id != "" {
			unknown = append(unknown, id)
		}
	}
	sort.Strings(unknown)
	return found, unknown, nil
}

// Detect returns the harnesses present on this machine or in this repository: supported ones to
// install into, and unsupported ones to name. A harness is present when one of its home folders
// or files exists under home or the repository, or its command is on the PATH. When AA_HOME
// relocates the home (decision record 0005) the PATH is not consulted, so a test or an isolated
// install is not influenced by what the machine happens to have.
func Detect(home, repo string) (supported, unsupported []Spec) {
	all, err := All()
	if err != nil {
		return nil, nil
	}
	isolated := os.Getenv("AA_HOME") != ""
	for _, t := range all {
		present := false
		for _, rel := range t.Detect.Home {
			if exists(filepath.Join(home, filepath.FromSlash(rel))) || (repo != "" && exists(filepath.Join(repo, filepath.FromSlash(rel)))) {
				present = true
				break
			}
		}
		if !present && !isolated && t.Detect.Command != "" {
			present = onPath(t.Detect.Command)
		}
		if !present {
			continue
		}
		if t.Supported() {
			supported = append(supported, t)
		} else {
			unsupported = append(unsupported, t)
		}
	}
	return supported, unsupported
}

// Scope is where an install goes: the user's home or a repository.
type Scope struct {
	Name    string // "user" or "project"
	Dir     string // the home or the repository root
	project bool
}

// UserScope installs under the user's home.
func UserScope(home string) Scope { return Scope{Name: "user", Dir: home} }

// ProjectScope installs under a repository.
func ProjectScope(repo string) Scope { return Scope{Name: "project", Dir: repo, project: true} }

// SkillDirs returns the skill folders a harness reads at this scope, relative to the scope's
// folder, in the harness's order of preference.
func (s Scope) SkillDirs(t Spec) []string {
	if s.project {
		return t.Skills.Project
	}
	return t.Skills.User
}

// CommandDir returns the folder a harness reads command files from at this scope, or "".
func (s Scope) CommandDir(t Spec) string {
	if t.Commands == nil {
		return ""
	}
	if s.project {
		return t.Commands.Project
	}
	return t.Commands.User
}

// AgentDirs returns the folders a harness reads subagents from at this scope, in its order of
// preference, or none where the CLI does not install its agents.
func (s Scope) AgentDirs(t Spec) []string {
	if t.Agents == nil {
		return nil
	}
	if s.project {
		return t.Agents.Project
	}
	return t.Agents.User
}

// Ref is how a skill or command refers to a path under the scope: repository-relative at project
// scope, home-relative with ~ at user scope, so the path resolves wherever the agent runs.
func (s Scope) Ref(rel string) string {
	if s.project {
		return rel
	}
	return "~/" + rel
}

// EntryName returns the skill folder or command file an installed path belongs to.
func (s Scope) EntryName(p string) string { return entryName(p, knownRoots(s)) }

// Plan is the set of folders an install writes for a set of harnesses.
type Plan struct {
	SkillDirs []string            // skill folders to write, relative to the scope's folder
	Reads     map[string][]string // harness id -> the planned skill folders it reads
	Commands  []CommandSet        // command files to write
	Agents    []AgentSet          // subagent folders to write
}

// AgentSet is one folder of subagent definitions in one format.
type AgentSet struct {
	Format   string
	Suffix   string
	Dir      string   // relative to the scope's folder
	SkillDir string   // the planned skill folder whose guidance sets the agents point at
	Targets  []string // harness ids served by this folder
}

// CommandSet is one folder of command files in one format.
type CommandSet struct {
	Format   string
	Dir      string   // relative to the scope's folder
	SkillDir string   // the planned skill folder the commands point at
	Targets  []string // harness ids served by this folder
}

// PlanInstall chooses the fewest skill folders that reach every harness: harnesses that read the
// fewest folders are placed first, a harness already reached by a chosen folder adds nothing, and
// otherwise the shared .agents/skills is preferred over a harness's own folder, so the skills are
// written once per folder, not once per harness (decision record 0014).
func PlanInstall(scope Scope, harnesses []Spec) Plan {
	plan := Plan{Reads: map[string][]string{}}
	ordered := append([]Spec(nil), harnesses...)
	sort.SliceStable(ordered, func(i, j int) bool { return len(scope.SkillDirs(ordered[i])) < len(scope.SkillDirs(ordered[j])) })
	chosen := map[string]bool{}
	for _, t := range ordered {
		dirs := scope.SkillDirs(t)
		if len(dirs) == 0 || anyIn(dirs, chosen) {
			continue
		}
		pick := dirs[0]
		if contains(dirs, sharedSkillDir) {
			pick = sharedSkillDir
		}
		chosen[pick] = true
		plan.SkillDirs = append(plan.SkillDirs, pick)
	}
	for _, t := range harnesses {
		for _, d := range scope.SkillDirs(t) {
			if chosen[d] {
				plan.Reads[t.ID] = append(plan.Reads[t.ID], d)
			}
		}
	}
	byDir := map[string]int{}
	for _, t := range harnesses {
		dir := scope.CommandDir(t)
		if dir == "" || len(plan.Reads[t.ID]) == 0 {
			continue
		}
		key := t.Commands.Format + "|" + dir
		if i, ok := byDir[key]; ok {
			plan.Commands[i].Targets = append(plan.Commands[i].Targets, t.ID)
			continue
		}
		byDir[key] = len(plan.Commands)
		plan.Commands = append(plan.Commands, CommandSet{Format: t.Commands.Format, Dir: dir, SkillDir: plan.Reads[t.ID][0], Targets: []string{t.ID}})
	}
	// Agents, like skills, are written once per folder: a harness already reached by a planned
	// folder in its own format adds nothing.
	for _, t := range ordered {
		dirs := scope.AgentDirs(t)
		if len(dirs) == 0 || len(plan.Reads[t.ID]) == 0 {
			continue
		}
		served := false
		for i, set := range plan.Agents {
			if set.Format == t.Agents.Format && set.Suffix == t.Agents.Suffix && contains(dirs, set.Dir) {
				plan.Agents[i].Targets = append(plan.Agents[i].Targets, t.ID)
				served = true
				break
			}
		}
		if !served {
			plan.Agents = append(plan.Agents, AgentSet{Format: t.Agents.Format, Suffix: t.Agents.Suffix, Dir: dirs[0], SkillDir: plan.Reads[t.ID][0], Targets: []string{t.ID}})
		}
	}
	return plan
}

const sharedSkillDir = ".agents/skills"

// InstallResult says what an install wrote.
type InstallResult struct {
	Skills   int      // skills written per folder
	Commands int      // command files written across folders
	Agents   int      // discipline subagents written per folder
	Plan     Plan     // the folders chosen
	Written  []string // every path written, relative to the scope's folder, for stale-file removal
}

// Install writes the package's skills and the shared guidance sets into every planned skill
// folder, and the command files each harness needs. Installed skills and commands belong to the
// package and are overwritten; nothing else in those folders is touched.
func Install(scope Scope, harnesses []Spec) (InstallResult, error) {
	res := InstallResult{Plan: PlanInstall(scope, harnesses)}
	skills, err := coreSkills()
	if err != nil {
		return res, err
	}
	shared, err := content.SharedGuidance()
	if err != nil {
		return res, err
	}
	for _, dir := range res.Plan.SkillDirs {
		// The guidance sets sit beside the skills in each folder, and every skill's reference to
		// the source path becomes that folder's path (decision record 0012).
		guidancePath := []byte(scope.Ref(dir) + "/" + content.SharedGuidanceDir)
		written, err := writeFiles(scope.Dir, filepath.Join(dir, content.SharedGuidanceDir), shared)
		if err != nil {
			return res, err
		}
		res.Written = append(res.Written, written...)
		for _, sk := range skills {
			files := map[string][]byte{}
			for rel, b := range sk.files {
				files[rel] = bytes.ReplaceAll(b, []byte(content.SourceGuidancePath), guidancePath)
			}
			written, err := writeFiles(scope.Dir, filepath.Join(dir, sk.name), files)
			if err != nil {
				return res, err
			}
			res.Written = append(res.Written, written...)
		}
	}
	res.Skills = len(skills)
	for _, set := range res.Plan.Commands {
		for _, sk := range skills {
			p, err := writeCommand(scope, set, sk.name, sk.description)
			if err != nil {
				return res, err
			}
			res.Written = append(res.Written, p)
			res.Commands++
		}
	}
	agents, err := content.Agents()
	if err != nil {
		return res, err
	}
	res.Agents = len(agents)
	for _, set := range res.Plan.Agents {
		guidance := []byte(scope.Ref(set.SkillDir) + "/" + content.SharedGuidanceDir)
		for name, b := range agents {
			body := bytes.ReplaceAll(b, []byte(content.SourceGuidancePath), guidance)
			if set.Format == AgentMarkdownOpenCode {
				body = bytes.Replace(body, []byte("\n---\n"), []byte("\nmode: subagent\n---\n"), 1)
			}
			rel := set.Dir + "/" + name + set.Suffix
			p := filepath.Join(scope.Dir, filepath.FromSlash(rel))
			if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
				return res, err
			}
			if err := os.WriteFile(p, body, 0o644); err != nil {
				return res, err
			}
			res.Written = append(res.Written, rel)
		}
	}
	return res, nil
}

// InstallPlugin writes a plugin's skills, named aa-<plugin>-<skill>, into every planned skill
// folder, and its commands where a harness needs them.
func InstallPlugin(scope Scope, harnesses []Spec, p content.Plugin) (InstallResult, error) {
	res := InstallResult{Plan: PlanInstall(scope, harnesses)}
	for _, dir := range res.Plan.SkillDirs {
		for _, sk := range p.Skills {
			written, err := writeFiles(scope.Dir, filepath.Join(dir, pluginSkillName(p.Name, sk.Name)), sk.Files)
			if err != nil {
				return res, err
			}
			res.Written = append(res.Written, written...)
		}
	}
	res.Skills = len(p.Skills)
	for _, set := range res.Plan.Commands {
		for _, sk := range p.Skills {
			path, err := writeCommand(scope, set, pluginSkillName(p.Name, sk.Name), sk.Description)
			if err != nil {
				return res, err
			}
			res.Written = append(res.Written, path)
			res.Commands++
		}
	}
	return res, nil
}

func pluginSkillName(plugin, skill string) string { return fmt.Sprintf("aa-%s-%s", plugin, skill) }

// RemovePlugin deletes a plugin's skills and commands from every folder any harness reads at
// this scope and returns what it removed. Core skills are named aa-<discipline code>-<step> and
// are never touched, because a plugin's prefix is its own name.
func RemovePlugin(scope Scope, plugin string) ([]string, error) {
	prefix := "aa-" + plugin + "-"
	var removed []string
	for _, root := range knownRoots(scope) {
		entries, _ := os.ReadDir(filepath.Join(scope.Dir, filepath.FromSlash(root)))
		for _, e := range entries {
			if !strings.HasPrefix(e.Name(), prefix) {
				continue
			}
			if err := os.RemoveAll(filepath.Join(scope.Dir, filepath.FromSlash(root), e.Name())); err != nil {
				return removed, err
			}
			removed = append(removed, root+"/"+e.Name())
		}
	}
	sort.Strings(removed)
	return removed, nil
}

// RemoveExcept deletes every aa-* skill, guidance folder, and command from the folders at this
// scope that the plan does not use, and returns what it removed. It removes the framework from
// harnesses no longer chosen without touching the folders the remaining ones still read, or
// anything in any folder that is not the framework's.
func RemoveExcept(scope Scope, plan Plan) []string {
	keep := map[string]bool{}
	for _, d := range plan.SkillDirs {
		keep[d] = true
	}
	for _, set := range plan.Commands {
		keep[set.Dir] = true
	}
	for _, set := range plan.Agents {
		keep[set.Dir] = true
	}
	var removed []string
	for _, r := range knownRoots(scope) {
		if keep[r] {
			continue
		}
		base := filepath.Join(scope.Dir, filepath.FromSlash(r))
		entries, _ := os.ReadDir(base)
		for _, e := range entries {
			if !strings.HasPrefix(e.Name(), "aa-") {
				continue
			}
			if err := os.RemoveAll(filepath.Join(base, e.Name())); err == nil {
				removed = append(removed, r+"/"+e.Name())
			}
		}
		// drop the folder if the framework was all it held
		_ = os.Remove(base)
	}
	sort.Strings(removed)
	return removed
}

// Snapshot hashes every installed aa-* file in every folder any harness reads at this scope,
// keyed by path relative to the scope's folder, so an update can say what it added, changed,
// and removed.
func Snapshot(scope Scope) map[string]string {
	snap := map[string]string{}
	for _, root := range knownRoots(scope) {
		base := filepath.Join(scope.Dir, filepath.FromSlash(root))
		entries, _ := os.ReadDir(base)
		for _, e := range entries {
			if !strings.HasPrefix(e.Name(), "aa-") {
				continue
			}
			_ = filepath.WalkDir(filepath.Join(base, e.Name()), func(p string, d os.DirEntry, err error) error {
				if err != nil || d.IsDir() {
					return nil
				}
				b, err := os.ReadFile(p)
				if err != nil {
					return nil
				}
				rel, _ := filepath.Rel(scope.Dir, p)
				sum := sha256.Sum256(b)
				snap[filepath.ToSlash(rel)] = hex.EncodeToString(sum[:])
				return nil
			})
		}
	}
	return snap
}

// RemoveStale deletes installed core files that were present before an install and were not
// written by it: a step or a file that left the package, or a harness no longer chosen. Plugin
// files (aa-<plugin>-*) are left alone: they are not the core install's to remove.
func RemoveStale(scope Scope, before map[string]string, written []string) []string {
	keep := map[string]bool{}
	for _, w := range written {
		keep[filepath.ToSlash(w)] = true
	}
	corePrefixes := corePrefixes()
	roots := knownRoots(scope)
	var removed []string
	for p := range before {
		if keep[p] {
			continue
		}
		if !hasAnyPrefix(entryName(p, roots), corePrefixes) {
			continue
		}
		full := filepath.Join(scope.Dir, filepath.FromSlash(p))
		if err := os.Remove(full); err == nil {
			removed = append(removed, p)
			// drop the skill folder if it is now empty
			_ = os.Remove(filepath.Dir(full))
		}
	}
	sort.Strings(removed)
	return removed
}

// entryName returns the skill folder or command file name a path belongs to, under whichever
// known root contains it.
func entryName(p string, roots []string) string {
	for _, r := range roots {
		if strings.HasPrefix(p, r+"/") {
			return strings.SplitN(strings.TrimPrefix(p, r+"/"), "/", 2)[0]
		}
	}
	return ""
}

// knownRoots lists every skill and command folder any supported harness reads at this scope,
// longest first so a nested folder is matched before its parent.
func knownRoots(scope Scope) []string {
	all, _ := All()
	seen := map[string]bool{}
	var roots []string
	for _, t := range all {
		if !t.Supported() {
			continue
		}
		dirs := append([]string(nil), scope.SkillDirs(t)...)
		if d := scope.CommandDir(t); d != "" {
			dirs = append(dirs, d)
		}
		dirs = append(dirs, scope.AgentDirs(t)...)
		for _, d := range dirs {
			if !seen[d] {
				seen[d] = true
				roots = append(roots, d)
			}
		}
	}
	sort.Slice(roots, func(i, j int) bool { return len(roots[i]) > len(roots[j]) })
	return roots
}

func corePrefixes() []string {
	ds, err := content.Disciplines()
	if err != nil {
		return nil
	}
	out := []string{content.SharedGuidanceDir}
	for _, d := range ds {
		// skills and commands are aa-<code>-<step>; a discipline agent is aa-<code>.<suffix>
		out = append(out, "aa-"+d.Code+"-", "aa-"+d.Code+".")
	}
	return out
}

type coreSkill struct {
	name        string
	description string
	files       map[string][]byte
}

// coreSkills names every skill in the package aa-<discipline code>-<step>.
func coreSkills() ([]coreSkill, error) {
	steps, err := content.Steps()
	if err != nil {
		return nil, err
	}
	disciplines, err := content.Disciplines()
	if err != nil {
		return nil, err
	}
	stepByID := map[string]content.Step{}
	for _, s := range steps {
		stepByID[s.ID] = s
	}
	skills, err := content.Skills()
	if err != nil {
		return nil, err
	}
	var out []coreSkill
	for _, sk := range skills {
		step, ok := stepByID[sk.StepID]
		if !ok {
			return nil, fmt.Errorf("skill %s has no workflow step", sk.StepID)
		}
		d, ok := disciplines[step.Discipline]
		if !ok {
			return nil, fmt.Errorf("step %s names unknown discipline %s", step.ID, step.Discipline)
		}
		out = append(out, coreSkill{name: fmt.Sprintf("aa-%s-%s", d.Code, step.ID), description: oneLine(step.Summary), files: sk.Files})
	}
	return out, nil
}

// writeFiles writes files under scopeDir/folder and returns the paths written, relative to
// scopeDir.
func writeFiles(scopeDir, folder string, files map[string][]byte) ([]string, error) {
	var written []string
	for rel, b := range files {
		p := filepath.Join(scopeDir, folder, filepath.FromSlash(rel))
		if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
			return written, err
		}
		if err := os.WriteFile(p, b, 0o644); err != nil {
			return written, err
		}
		r, _ := filepath.Rel(scopeDir, p)
		written = append(written, filepath.ToSlash(r))
	}
	return written, nil
}

// writeCommand writes one command file in the set's format, pointing at the skill in the set's
// skill folder, and returns its path relative to the scope's folder.
func writeCommand(scope Scope, set CommandSet, name, description string) (string, error) {
	ref := scope.Ref(set.SkillDir) + "/" + name + "/SKILL.md"
	var file, body string
	switch set.Format {
	case FormatMarkdownArguments:
		file = name + ".md"
		body = fmt.Sprintf("---\ndescription: %s\n---\nRead %s and follow it exactly, with these arguments: $ARGUMENTS\n", yamlQuote(description), ref)
	case FormatMarkdownBraces:
		file = name + ".md"
		body = fmt.Sprintf("---\ndescription: %s\n---\nRead %s and follow it exactly, with these arguments: {{args}}\n", yamlQuote(description), ref)
	case FormatGeminiTOML:
		file = name + ".toml"
		body = fmt.Sprintf("description = %s\nprompt = %s\n", tomlQuote(description), tomlQuote("Read "+ref+" and follow it exactly, with these arguments: {{args}}"))
	default:
		return "", fmt.Errorf("unknown command format %q", set.Format)
	}
	p := filepath.Join(scope.Dir, filepath.FromSlash(set.Dir), file)
	if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
		return "", err
	}
	if err := os.WriteFile(p, []byte(body), 0o644); err != nil {
		return "", err
	}
	return set.Dir + "/" + file, nil
}

func yamlQuote(s string) string {
	return `"` + strings.ReplaceAll(strings.ReplaceAll(s, `\`, `\\`), `"`, `\"`) + `"`
}

func tomlQuote(s string) string {
	return `"` + strings.ReplaceAll(strings.ReplaceAll(s, `\`, `\\`), `"`, `\"`) + `"`
}

func oneLine(s string) string {
	return strings.Join(strings.Fields(s), " ")
}

func anyIn(list []string, set map[string]bool) bool {
	for _, x := range list {
		if set[x] {
			return true
		}
	}
	return false
}

func contains(list []string, x string) bool {
	for _, y := range list {
		if y == x {
			return true
		}
	}
	return false
}

func hasAnyPrefix(s string, prefixes []string) bool {
	for _, p := range prefixes {
		if strings.HasPrefix(s, p) {
			return true
		}
	}
	return false
}

func exists(p string) bool {
	_, err := os.Stat(p)
	return err == nil
}

func onPath(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

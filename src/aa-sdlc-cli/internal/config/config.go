// Package config reads, merges, and writes aa.config.yaml at its four scopes: enterprise, team,
// user, project, merged in that order with the later scope winning (docs/formats.md section 2).
package config

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

// Config is one aa.config.yaml file, or the merge of several.
type Config struct {
	Version        int               `yaml:"version"`
	Scope          string            `yaml:"scope"`
	Targets        []string          `yaml:"targets,omitempty"`
	Plugins        []PluginRef       `yaml:"plugins,omitempty"`
	PluginsExclude []string          `yaml:"plugins_exclude,omitempty"`
	Conventions    Conventions       `yaml:"conventions,omitempty"`
	Folders        map[string]string `yaml:"folders,omitempty"`
	Stack          *Stack            `yaml:"stack,omitempty"`
	Tools          []Tool            `yaml:"tools,omitempty"`
	Organisation   *Organisation     `yaml:"organisation,omitempty"`
	Install        *Install          `yaml:"install,omitempty"`
}

// Conventions are the project's naming and linking conventions.
type Conventions struct {
	Ticket    Ticket    `yaml:"ticket,omitempty"`
	Knowledge Knowledge `yaml:"knowledge,omitempty"`
	Branch    Branch    `yaml:"branch,omitempty"`
	Commit    Commit    `yaml:"commit,omitempty"`
}

// Ticket names the one ticket project the repository maps to (O-09) and how ids look (R-08).
type Ticket struct {
	Project string `yaml:"project,omitempty"`
	URL     string `yaml:"url,omitempty"`
	Pattern string `yaml:"pattern,omitempty"`
	Tag     string `yaml:"tag,omitempty"`
	// Filter selects this project's tickets where the ticket project is shared with others
	// (T-14): a query in the ticket system's own language, such as a component or label.
	Filter string `yaml:"filter,omitempty"`
	// Kinds and States map the framework's ticket kinds and life cycle to the ticket system's
	// own names (O-26, R-41).
	Kinds  map[string]string `yaml:"kinds,omitempty"`
	States map[string]string `yaml:"states,omitempty"`
}

// Knowledge names the knowledge repository (O-04).
type Knowledge struct {
	Space string `yaml:"space,omitempty"`
	URL   string `yaml:"url,omitempty"`
	// Root is the project's own page in the space, under which its six sections live; in a
	// space shared with other projects it is not the space itself (T-14, R-42). Where the
	// documents folder is the knowledge base, it is the knowledge folder.
	Root string `yaml:"root,omitempty"`
	// Sections maps the six top-level sections to the space's own page names (O-27, R-42).
	Sections map[string]string `yaml:"sections,omitempty"`
}

// Branch is the branch naming pattern.
type Branch struct {
	Pattern string `yaml:"pattern,omitempty"`
}

// Commit is the commit message convention (O-14).
type Commit struct {
	Pattern string   `yaml:"pattern,omitempty"`
	Types   []string `yaml:"types,omitempty"`
	Scopes  []string `yaml:"scopes,omitempty"`
}

// Stack is what /aa-fw-init inferred about the project, or what the user answered in its survey
// when the repository could not say (R-44).
type Stack struct {
	Description string   `yaml:"description,omitempty"`
	Languages   []string `yaml:"languages,omitempty"`
	Frameworks  []string `yaml:"frameworks,omitempty"`
	Platforms   []string `yaml:"platforms,omitempty"`
	Deploy      string   `yaml:"deploy,omitempty"`
	Pipeline    string   `yaml:"pipeline,omitempty"`
	Containers  bool     `yaml:"containers,omitempty"`
}

// Tool is one tool the project uses (R-44): the category the framework or the stack prescribes
// it for, the language it serves where it serves one, the minimum version, the command that
// prints its version, and the command that installs it per platform (windows, macos, linux).
// A tool with no check, such as a connector the agent loads, is probed in the agent.
type Tool struct {
	Name     string            `yaml:"name"`
	Category string            `yaml:"category"`
	Language string            `yaml:"language,omitempty"`
	Version  string            `yaml:"version,omitempty"`
	Check    string            `yaml:"check,omitempty"`
	Install  map[string]string `yaml:"install,omitempty"`
	Docs     string            `yaml:"docs,omitempty"`
}

// Organisation points at the enterprise and team scopes.
type Organisation struct {
	Repository string `yaml:"repository,omitempty"`
	Team       string `yaml:"team,omitempty"`
}

// PluginRef is one entry of plugins: the plugin's name and, once aa plugin install has run at
// that scope, the version installed and the source it came from ("package", "organisation",
// or a folder path, relative to the config file where it can be). An entry with only a name
// reads and writes as a plain string, as enterprise and team configs write it
// (decision record 0013).
type PluginRef struct {
	Name    string `yaml:"name"`
	Version string `yaml:"version,omitempty"`
	Source  string `yaml:"source,omitempty"`
}

type plainPluginRef PluginRef

// UnmarshalYAML accepts a plain name or a mapping.
func (p *PluginRef) UnmarshalYAML(n *yaml.Node) error {
	if n.Kind == yaml.ScalarNode {
		*p = PluginRef{Name: n.Value}
		return nil
	}
	var v plainPluginRef
	if err := n.Decode(&v); err != nil {
		return err
	}
	*p = PluginRef(v)
	return nil
}

// MarshalYAML writes a plain name when nothing else is recorded.
func (p PluginRef) MarshalYAML() (interface{}, error) {
	if p.Version == "" && p.Source == "" {
		return p.Name, nil
	}
	return plainPluginRef(p), nil
}

// PluginNames returns the names of the plugins, in order.
func PluginNames(refs []PluginRef) []string {
	names := make([]string, 0, len(refs))
	for _, r := range refs {
		names = append(names, r.Name)
	}
	return names
}

// Install records what setup installed, at user scope.
type Install struct {
	Version string `yaml:"version,omitempty"`
	Updated string `yaml:"updated,omitempty"`
}

// FileName is the name of the config file at every scope.
const FileName = "aa.config.yaml"

// DefaultCommitTypes is the Conventional Commits type list aa init writes (O-14).
var DefaultCommitTypes = []string{"feat", "fix", "docs", "style", "refactor", "perf", "test", "build", "ci", "chore"}

// Defaults returns the conventions and folders aa init writes when no scope supplies them.
func Defaults() Config {
	return Config{
		Version: 1,
		Conventions: Conventions{
			Ticket: Ticket{Pattern: `[A-Z]+-\d+`, Tag: "@{id}",
				Kinds:  map[string]string{"epic": "Epic", "story": "Story", "task": "Task", "bug": "Bug", "spike": "Spike"},
				States: map[string]string{"new": "New", "refined": "Refined", "planned": "Planned", "in-progress": "In progress", "in-review": "In review", "accepted": "Accepted", "done": "Done"},
			},
			Knowledge: Knowledge{
				Sections: map[string]string{"overview": "Overview", "requirements": "Requirements", "architecture": "Architecture", "operations": "Operations", "releases": "Releases", "guides": "Guides"},
			},
			Branch: Branch{Pattern: "{type}/{id}-{slug}"},
			Commit: Commit{Pattern: "{type}({scope}): {subject}\n\n{id}", Types: append([]string(nil), DefaultCommitTypes...)},
		},
		Folders: map[string]string{
			"documents": "docs",
			"features":  "features",
			"scripts":   "scripts",
			"source":    "src",
			"tests":     "tests",
			"decisions": "docs/decisions",
			"knowledge": "docs/knowledge",
		},
	}
}

// Load reads one config file. A missing file is not an error; it returns nil, nil.
func Load(path string) (*Config, error) {
	b, err := os.ReadFile(path)
	if errors.Is(err, os.ErrNotExist) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	var c Config
	if err := yaml.Unmarshal(b, &c); err != nil {
		return nil, fmt.Errorf("%s: %w", path, err)
	}
	if c.Version == 0 {
		return nil, fmt.Errorf("%s: missing version", path)
	}
	return &c, nil
}

// Write writes a config file with a leading comment, two-space indented as in docs/formats.md.
func Write(path string, c *Config, header string) error {
	var body bytes.Buffer
	enc := yaml.NewEncoder(&body)
	enc.SetIndent(2)
	if err := enc.Encode(c); err != nil {
		return err
	}
	if err := enc.Close(); err != nil {
		return err
	}
	b := body.Bytes()
	var sb strings.Builder
	for _, line := range strings.Split(strings.TrimRight(header, "\n"), "\n") {
		if line == "" {
			sb.WriteString("#\n")
		} else {
			sb.WriteString("# " + line + "\n")
		}
	}
	sb.Write(b)
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return err
	}
	return os.WriteFile(path, []byte(sb.String()), 0o644)
}

// Merge layers configs in scope order (enterprise, team, user, project). Scalars: the later
// non-empty value wins. Lists targets and plugins: union in scope order. Folders and
// conventions: per key, the later non-empty value wins. Version must agree.
func Merge(cfgs ...*Config) (*Config, error) {
	out := &Config{Folders: map[string]string{}}
	for _, c := range cfgs {
		if c == nil {
			continue
		}
		if out.Version != 0 && c.Version != out.Version {
			return nil, fmt.Errorf("config versions differ: %d and %d", out.Version, c.Version)
		}
		out.Version = c.Version
		out.Scope = c.Scope
		out.Targets = union(out.Targets, c.Targets)
		out.Plugins = mergePlugins(out.Plugins, c.Plugins)
		out.PluginsExclude = union(out.PluginsExclude, c.PluginsExclude)
		for k, v := range c.Folders {
			if v != "" {
				out.Folders[k] = v
			}
		}
		out.Conventions = mergeConventions(out.Conventions, c.Conventions)
		out.Tools = mergeTools(out.Tools, c.Tools)
		if c.Stack != nil {
			out.Stack = c.Stack
		}
		if c.Organisation != nil {
			if out.Organisation == nil {
				out.Organisation = &Organisation{}
			}
			out.Organisation.Repository = pick(out.Organisation.Repository, c.Organisation.Repository)
			out.Organisation.Team = pick(out.Organisation.Team, c.Organisation.Team)
		}
		if c.Install != nil {
			out.Install = &Install{Version: c.Install.Version, Updated: c.Install.Updated}
		}
	}
	if len(out.PluginsExclude) > 0 {
		var kept []PluginRef
		for _, p := range out.Plugins {
			if !contains(out.PluginsExclude, p.Name) {
				kept = append(kept, p)
			}
		}
		out.Plugins = kept
	}
	if len(out.Folders) == 0 {
		out.Folders = nil
	}
	return out, nil
}

// mergeTools keeps one entry per tool name; a later scope's entry replaces an earlier one.
func mergeTools(a, b []Tool) []Tool {
	out := append([]Tool(nil), a...)
	for _, t := range b {
		replaced := false
		for i := range out {
			if out[i].Name == t.Name {
				out[i], replaced = t, true
			}
		}
		if !replaced {
			out = append(out, t)
		}
	}
	return out
}

func mergeConventions(a, b Conventions) Conventions {
	a.Ticket.Project = pick(a.Ticket.Project, b.Ticket.Project)
	a.Ticket.URL = pick(a.Ticket.URL, b.Ticket.URL)
	a.Ticket.Pattern = pick(a.Ticket.Pattern, b.Ticket.Pattern)
	a.Ticket.Tag = pick(a.Ticket.Tag, b.Ticket.Tag)
	a.Ticket.Filter = pick(a.Ticket.Filter, b.Ticket.Filter)
	a.Knowledge.Root = pick(a.Knowledge.Root, b.Knowledge.Root)
	a.Knowledge.Space = pick(a.Knowledge.Space, b.Knowledge.Space)
	a.Knowledge.URL = pick(a.Knowledge.URL, b.Knowledge.URL)
	a.Ticket.Kinds = mergeMap(a.Ticket.Kinds, b.Ticket.Kinds)
	a.Ticket.States = mergeMap(a.Ticket.States, b.Ticket.States)
	a.Knowledge.Sections = mergeMap(a.Knowledge.Sections, b.Knowledge.Sections)
	a.Branch.Pattern = pick(a.Branch.Pattern, b.Branch.Pattern)
	a.Commit.Pattern = pick(a.Commit.Pattern, b.Commit.Pattern)
	if len(b.Commit.Types) > 0 {
		a.Commit.Types = append([]string(nil), b.Commit.Types...)
	}
	if len(b.Commit.Scopes) > 0 {
		a.Commit.Scopes = append([]string(nil), b.Commit.Scopes...)
	}
	return a
}

// UserDir is the user's home config folder for aa.
func UserDir() (string, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(home, ".aa"), nil
}

// UserPath is the user-scope config file.
func UserPath() (string, error) {
	dir, err := UserDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(dir, FileName), nil
}

// LoadScopes reads the user config at userPath and, if it names a local organisation
// repository, the enterprise config at its root and the team config in its team subfolder.
// It returns the configs in merge order: enterprise, team, user. Missing files are skipped.
func LoadScopes(userPath string) ([]*Config, error) {
	user, err := Load(userPath)
	if err != nil {
		return nil, err
	}
	var scopes []*Config
	if user != nil && user.Organisation != nil && user.Organisation.Repository != "" {
		repo := user.Organisation.Repository
		if info, statErr := os.Stat(repo); statErr == nil && info.IsDir() {
			ent, err := Load(filepath.Join(repo, FileName))
			if err != nil {
				return nil, err
			}
			scopes = append(scopes, ent)
			if user.Organisation.Team != "" {
				team, err := Load(filepath.Join(repo, user.Organisation.Team, FileName))
				if err != nil {
					return nil, err
				}
				scopes = append(scopes, team)
			}
		}
	}
	scopes = append(scopes, user)
	return scopes, nil
}

func pick(current, next string) string {
	if next != "" {
		return next
	}
	return current
}

func union(a, b []string) []string {
	out := append([]string(nil), a...)
	for _, x := range b {
		if x != "" && !contains(out, x) {
			out = append(out, x)
		}
	}
	return out
}

// mergeMap merges per key: a later scope's non-empty name replaces an earlier one.
func mergeMap(a, b map[string]string) map[string]string {
	if len(b) == 0 {
		return a
	}
	out := map[string]string{}
	for k, v := range a {
		out[k] = v
	}
	for k, v := range b {
		if v != "" {
			out[k] = v
		}
	}
	return out
}

// mergePlugins is a union by name in scope order; a later scope's entry replaces an earlier one
// of the same name, so the version and source recorded closest to the user win.
func mergePlugins(a, b []PluginRef) []PluginRef {
	out := append([]PluginRef(nil), a...)
	for _, p := range b {
		if p.Name == "" {
			continue
		}
		replaced := false
		for i := range out {
			if out[i].Name == p.Name {
				out[i] = p
				replaced = true
				break
			}
		}
		if !replaced {
			out = append(out, p)
		}
	}
	return out
}

func contains(list []string, x string) bool {
	for _, y := range list {
		if y == x {
			return true
		}
	}
	return false
}

// SortedKeys is a helper for deterministic output.
func SortedKeys(m map[string]string) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

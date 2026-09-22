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
	Plugins        []string          `yaml:"plugins,omitempty"`
	PluginsExclude []string          `yaml:"plugins_exclude,omitempty"`
	Conventions    Conventions       `yaml:"conventions,omitempty"`
	Folders        map[string]string `yaml:"folders,omitempty"`
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
}

// Knowledge names the knowledge repository (O-04).
type Knowledge struct {
	Space string `yaml:"space,omitempty"`
	URL   string `yaml:"url,omitempty"`
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

// Organisation points at the enterprise and team scopes.
type Organisation struct {
	Repository string `yaml:"repository,omitempty"`
	Team       string `yaml:"team,omitempty"`
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
			Ticket: Ticket{Pattern: `[A-Z]+-\d+`, Tag: "@{id}"},
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
		out.Plugins = union(out.Plugins, c.Plugins)
		out.PluginsExclude = union(out.PluginsExclude, c.PluginsExclude)
		for k, v := range c.Folders {
			if v != "" {
				out.Folders[k] = v
			}
		}
		out.Conventions = mergeConventions(out.Conventions, c.Conventions)
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
		var kept []string
		for _, p := range out.Plugins {
			if !contains(out.PluginsExclude, p) {
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

func mergeConventions(a, b Conventions) Conventions {
	a.Ticket.Project = pick(a.Ticket.Project, b.Ticket.Project)
	a.Ticket.URL = pick(a.Ticket.URL, b.Ticket.URL)
	a.Ticket.Pattern = pick(a.Ticket.Pattern, b.Ticket.Pattern)
	a.Ticket.Tag = pick(a.Ticket.Tag, b.Ticket.Tag)
	a.Knowledge.Space = pick(a.Knowledge.Space, b.Knowledge.Space)
	a.Knowledge.URL = pick(a.Knowledge.URL, b.Knowledge.URL)
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

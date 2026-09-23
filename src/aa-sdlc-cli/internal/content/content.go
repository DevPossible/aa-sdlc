// Package content exposes the content package compiled into the binary: skills, workflow data,
// schemas, target adapters, plugins, and the requirement definitions. The data folder is
// populated by scripts/Sync-EmbeddedContent.ps1 at build time and is not committed, so the
// binary and the content it installs cannot drift (decision record 0004).
package content

import (
	"embed"
	"fmt"
	"io/fs"
	"os"
	"path"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

// osDirFS wraps a directory on disk as an fs.FS, so plugins load the same way from the package
// and from an organisation repository or a local path.
func osDirFS(dir string) fs.FS { return os.DirFS(dir) }

//go:embed all:data
var data embed.FS

// FS returns the embedded content rooted at the package root (skills/, workflow/, ...).
func FS() fs.FS {
	sub, err := fs.Sub(data, "data")
	if err != nil {
		panic(fmt.Sprintf("embedded content is missing: %v", err))
	}
	return sub
}

// Step is the subset of a workflow step the CLI needs to render commands and install skills.
type Step struct {
	ID         string `yaml:"id"`
	Name       string `yaml:"name"`
	Discipline string `yaml:"discipline"`
	Command    string `yaml:"command"`
	Summary    string `yaml:"summary"`
	Anchor     string `yaml:"anchor"`
}

// Discipline is the subset of a discipline the CLI needs.
type Discipline struct {
	ID   string `yaml:"id"`
	Code string `yaml:"code"`
	Name string `yaml:"name"`
}

// Steps returns every workflow step, sorted by id.
func Steps() ([]Step, error) {
	var steps []Step
	err := eachYAML("workflow/steps", func(b []byte) error {
		var s Step
		if err := yaml.Unmarshal(b, &s); err != nil {
			return err
		}
		steps = append(steps, s)
		return nil
	})
	sort.Slice(steps, func(i, j int) bool { return steps[i].ID < steps[j].ID })
	return steps, err
}

// Disciplines returns every discipline keyed by id.
func Disciplines() (map[string]Discipline, error) {
	out := map[string]Discipline{}
	err := eachYAML("workflow/disciplines", func(b []byte) error {
		var d Discipline
		if err := yaml.Unmarshal(b, &d); err != nil {
			return err
		}
		out[d.ID] = d
		return nil
	})
	return out, err
}

// Skill is an installable skill: its step id, discipline, and the files under its folder.
type Skill struct {
	StepID     string
	Discipline string
	Files      map[string][]byte // path relative to the skill folder -> content
}

// Skills returns every skill in the package (skills/<discipline>/<step>/SKILL.md and siblings).
func Skills() ([]Skill, error) {
	root := FS()
	var skills []Skill
	disciplines, err := fs.ReadDir(root, "skills")
	if err != nil {
		return nil, fmt.Errorf("reading skills: %w", err)
	}
	for _, d := range disciplines {
		if !d.IsDir() {
			continue
		}
		steps, err := fs.ReadDir(root, path.Join("skills", d.Name()))
		if err != nil {
			return nil, err
		}
		for _, s := range steps {
			if !s.IsDir() {
				continue
			}
			dir := path.Join("skills", d.Name(), s.Name())
			if _, err := fs.Stat(root, path.Join(dir, "SKILL.md")); err != nil {
				continue
			}
			files := map[string][]byte{}
			err := fs.WalkDir(root, dir, func(p string, e fs.DirEntry, err error) error {
				if err != nil || e.IsDir() {
					return err
				}
				b, err := fs.ReadFile(root, p)
				if err != nil {
					return err
				}
				files[strings.TrimPrefix(p, dir+"/")] = b
				return nil
			})
			if err != nil {
				return nil, err
			}
			skills = append(skills, Skill{StepID: s.Name(), Discipline: d.Name(), Files: files})
		}
	}
	sort.Slice(skills, func(i, j int) bool { return skills[i].StepID < skills[j].StepID })
	return skills, nil
}

// SharedGuidanceDir is the top-level skill folder that holds the guidance sets every step
// reads (skills/aa-guidance/sets/<set>.md). It is installed beside the step skills, with no
// command, and each installed skill's reference to it is rewritten to the scope's path
// (decision record 0012).
const SharedGuidanceDir = "aa-guidance"

// SourceGuidancePath is how the source skills refer to the shared sets; it resolves from the
// framework repository's root and is rewritten on install.
const SourceGuidancePath = "src/aa-sdlc/skills/" + SharedGuidanceDir

// SharedGuidance returns the files of the shared guidance folder, keyed by path relative to it.
func SharedGuidance() (map[string][]byte, error) {
	root := FS()
	dir := path.Join("skills", SharedGuidanceDir)
	files := map[string][]byte{}
	err := fs.WalkDir(root, dir, func(p string, e fs.DirEntry, err error) error {
		if err != nil || e.IsDir() {
			return err
		}
		b, err := fs.ReadFile(root, p)
		if err != nil {
			return err
		}
		files[strings.TrimPrefix(p, dir+"/")] = b
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("reading %s: %w", dir, err)
	}
	return files, nil
}

// ReadFile reads one file from the embedded content.
func ReadFile(name string) ([]byte, error) {
	return fs.ReadFile(FS(), name)
}

// Plugin is a tech-stack or process pack: a plugin.yaml manifest and the skills under
// skills/<name>/SKILL.md (docs/formats.md section 3).
type Plugin struct {
	Name     string   `yaml:"name"`
	Version  string   `yaml:"version"`
	Kind     string   `yaml:"kind"`
	Requires []string `yaml:"requires"`
	Adds     struct {
		Skills []string `yaml:"skills"`
	} `yaml:"adds"`
	Skills []PluginSkill `yaml:"-"`
	Source string        `yaml:"-"` // "package", or the directory it was loaded from
}

// PluginSkill is one installable skill of a plugin.
type PluginSkill struct {
	Name        string
	Description string
	Files       map[string][]byte
}

// Plugins returns the plugins shipped inside the package (plugins/<name>/plugin.yaml).
func Plugins() ([]Plugin, error) {
	root := FS()
	entries, err := fs.ReadDir(root, "plugins")
	if err != nil {
		return nil, nil // no plugins folder means no plugins
	}
	var out []Plugin
	for _, e := range entries {
		if !e.IsDir() {
			continue
		}
		sub, err := fs.Sub(root, path.Join("plugins", e.Name()))
		if err != nil {
			return nil, err
		}
		p, err := loadPlugin(sub, "package")
		if err != nil {
			return nil, fmt.Errorf("plugin %s: %w", e.Name(), err)
		}
		if p != nil {
			out = append(out, *p)
		}
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Name < out[j].Name })
	return out, nil
}

// LoadPluginDir reads a plugin from a directory on disk.
func LoadPluginDir(dir string) (*Plugin, error) {
	return loadPlugin(osDirFS(dir), dir)
}

func loadPlugin(root fs.FS, source string) (*Plugin, error) {
	b, err := fs.ReadFile(root, "plugin.yaml")
	if err != nil {
		return nil, nil // not a plugin folder
	}
	var p Plugin
	if err := yaml.Unmarshal(b, &p); err != nil {
		return nil, err
	}
	if p.Name == "" {
		return nil, fmt.Errorf("plugin.yaml has no name")
	}
	p.Source = source
	skillDirs, _ := fs.ReadDir(root, "skills")
	for _, d := range skillDirs {
		if !d.IsDir() {
			continue
		}
		dir := path.Join("skills", d.Name())
		if _, err := fs.Stat(root, path.Join(dir, "SKILL.md")); err != nil {
			continue
		}
		files := map[string][]byte{}
		err := fs.WalkDir(root, dir, func(pth string, e fs.DirEntry, err error) error {
			if err != nil || e.IsDir() {
				return err
			}
			fb, err := fs.ReadFile(root, pth)
			if err != nil {
				return err
			}
			files[strings.TrimPrefix(pth, dir+"/")] = fb
			return nil
		})
		if err != nil {
			return nil, err
		}
		p.Skills = append(p.Skills, PluginSkill{Name: d.Name(), Description: frontmatterDescription(files["SKILL.md"]), Files: files})
	}
	sort.Slice(p.Skills, func(i, j int) bool { return p.Skills[i].Name < p.Skills[j].Name })
	return &p, nil
}

func frontmatterDescription(skill []byte) string {
	s := string(skill)
	if !strings.HasPrefix(s, "---") {
		return ""
	}
	end := strings.Index(s[3:], "\n---")
	if end < 0 {
		return ""
	}
	var front struct {
		Description string `yaml:"description"`
	}
	_ = yaml.Unmarshal([]byte(s[3:3+end]), &front)
	return strings.Join(strings.Fields(front.Description), " ")
}

func eachYAML(dir string, fn func([]byte) error) error {
	root := FS()
	entries, err := fs.ReadDir(root, dir)
	if err != nil {
		return fmt.Errorf("reading %s: %w", dir, err)
	}
	for _, e := range entries {
		if e.IsDir() || !strings.HasSuffix(e.Name(), ".yaml") {
			continue
		}
		b, err := fs.ReadFile(root, path.Join(dir, e.Name()))
		if err != nil {
			return err
		}
		if err := fn(b); err != nil {
			return fmt.Errorf("%s/%s: %w", dir, e.Name(), err)
		}
	}
	return nil
}

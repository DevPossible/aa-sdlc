// Package content exposes the content package compiled into the binary: skills, workflow data,
// schemas, target adapters, plugins, and the requirement definitions. The data folder is
// populated by scripts/Sync-EmbeddedContent.ps1 at build time and is not committed, so the
// binary and the content it installs cannot drift (decision record 0004).
package content

import (
	"embed"
	"fmt"
	"io/fs"
	"path"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

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

// ReadFile reads one file from the embedded content.
func ReadFile(name string) ([]byte, error) {
	return fs.ReadFile(FS(), name)
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

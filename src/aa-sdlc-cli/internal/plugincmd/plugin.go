// Package plugincmd implements aa plugin add|remove|list: manage tech-stack and process packs
// at user or project scope without changing core (design section 8, features/cli/plugin.feature).
package plugincmd

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/content"
	"aasdlc.com/aa/internal/targets"
)

// Options are the flags aa plugin accepts.
type Options struct {
	Scope          string // "project" or "user"; default project inside an initialised repository, else user
	Path           string // repository for project scope; default the current directory
	Home           string // override for tests
	UserConfigPath string // override for tests
}

// Add installs a plugin by name (from the package or the organisation repository) or by path.
func Add(nameOrPath string, opts Options, out io.Writer) error {
	ctx, err := resolve(opts)
	if err != nil {
		return err
	}
	p, err := find(nameOrPath, ctx)
	if err != nil {
		return err
	}
	if err := refuseIfChangesCore(p); err != nil {
		return err
	}
	dir, prefix := ctx.scopeDir, ctx.skillRef
	res, err := targets.InstallPluginClaudeCode(dir, *p, prefix)
	if err != nil {
		return err
	}
	if !contains(ctx.cfg.Plugins, p.Name) {
		ctx.cfg.Plugins = append(ctx.cfg.Plugins, p.Name)
	}
	if err := config.Write(ctx.cfgPath, ctx.cfg, ctx.header); err != nil {
		return err
	}
	fmt.Fprintf(out, "aa plugin add %s: %d skills and %d commands installed at %s scope (%s); %s records the plugin\n", p.Name, res.Skills, res.Commands, ctx.scope, filepath.Join(dir, ".claude"), ctx.cfgPath)
	if len(p.Requires) > 0 {
		fmt.Fprintf(out, "  the plugin declares requirements %s; /aa-fw-health will probe them\n", strings.Join(p.Requires, ", "))
	}
	return nil
}

// Remove uninstalls a plugin's skills and commands at a scope and drops it from the config.
func Remove(name string, opts Options, out io.Writer) error {
	ctx, err := resolve(opts)
	if err != nil {
		return err
	}
	removed, err := targets.RemovePluginClaudeCode(ctx.scopeDir, name)
	if err != nil {
		return err
	}
	var kept []string
	for _, x := range ctx.cfg.Plugins {
		if x != name {
			kept = append(kept, x)
		}
	}
	ctx.cfg.Plugins = kept
	if err := config.Write(ctx.cfgPath, ctx.cfg, ctx.header); err != nil {
		return err
	}
	fmt.Fprintf(out, "aa plugin remove %s: %d files removed at %s scope; core skills untouched\n", name, len(removed), ctx.scope)
	for _, r := range removed {
		fmt.Fprintf(out, "    - %s\n", r)
	}
	return nil
}

// List prints installed plugins by scope and the plugins available from the package and the
// organisation repository, if one is set.
func List(opts Options, out io.Writer) error {
	home, userPath, err := homeAndUser(opts)
	if err != nil {
		return err
	}
	user, err := config.Load(userPath)
	if err != nil {
		return err
	}
	fmt.Fprintln(out, "Installed")
	if user != nil && len(user.Plugins) > 0 {
		fmt.Fprintf(out, "  user scope: %s\n", strings.Join(user.Plugins, ", "))
	} else {
		fmt.Fprintln(out, "  user scope: none")
	}
	projDir, _ := filepath.Abs(defaultString(opts.Path, "."))
	if project, err := config.Load(filepath.Join(projDir, config.FileName)); err == nil && project != nil {
		if len(project.Plugins) > 0 {
			fmt.Fprintf(out, "  project scope (%s): %s\n", projDir, strings.Join(project.Plugins, ", "))
		} else {
			fmt.Fprintf(out, "  project scope (%s): none\n", projDir)
		}
	}
	fmt.Fprintln(out, "Available")
	packaged, err := content.Plugins()
	if err != nil {
		return err
	}
	for _, p := range packaged {
		fmt.Fprintf(out, "  %s %s (%s, in the package)\n", p.Name, p.Version, p.Kind)
	}
	if user != nil && user.Organisation != nil && user.Organisation.Repository != "" {
		org := user.Organisation.Repository
		entries, _ := os.ReadDir(filepath.Join(org, "plugins"))
		for _, e := range entries {
			if !e.IsDir() {
				continue
			}
			if p, err := content.LoadPluginDir(filepath.Join(org, "plugins", e.Name())); err == nil && p != nil {
				fmt.Fprintf(out, "  %s %s (%s, from the organisation repository)\n", p.Name, p.Version, p.Kind)
			}
		}
	} else {
		fmt.Fprintln(out, "  (no organisation config repository set; run aa setup -org <repository> to see its plugins)")
	}
	if len(packaged) == 0 {
		fmt.Fprintln(out, "  the package ships no plugins in this version")
	}
	_ = home
	return nil
}

type scopeContext struct {
	scope    string
	scopeDir string
	skillRef string
	cfgPath  string
	cfg      *config.Config
	header   string
	home     string
	userPath string
}

func resolve(opts Options) (*scopeContext, error) {
	home, userPath, err := homeAndUser(opts)
	if err != nil {
		return nil, err
	}
	projDir, err := filepath.Abs(defaultString(opts.Path, "."))
	if err != nil {
		return nil, err
	}
	project, err := config.Load(filepath.Join(projDir, config.FileName))
	if err != nil {
		return nil, err
	}
	scope := opts.Scope
	if scope == "" {
		if project != nil {
			scope = "project"
		} else {
			scope = "user"
		}
	}
	switch scope {
	case "project":
		if project == nil {
			return nil, fmt.Errorf("%s is not initialised; run aa init first or use -scope user", projDir)
		}
		return &scopeContext{scope: scope, scopeDir: projDir, skillRef: ".claude/skills", cfgPath: filepath.Join(projDir, config.FileName), cfg: project,
			header: "aa.config.yaml (project scope), written by aa init. See https://aasdlc.com and docs/formats.md.\nconventions.ticket.project is the ONE ticket project this repository maps to (O-09).\nEdit freely; aa init never overwrites this file.", home: home, userPath: userPath}, nil
	case "user":
		user, err := config.Load(userPath)
		if err != nil {
			return nil, err
		}
		if user == nil {
			return nil, errors.New("no user config; run aa setup first")
		}
		return &scopeContext{scope: scope, scopeDir: home, skillRef: "~/.claude/skills", cfgPath: userPath, cfg: user,
			header: "aa.config.yaml (user scope), written by aa setup.\nTargets and the package version installed; an organisation repository layers enterprise and team scopes over core.", home: home, userPath: userPath}, nil
	default:
		return nil, fmt.Errorf("unknown scope %q; use project or user", scope)
	}
}

func find(nameOrPath string, ctx *scopeContext) (*content.Plugin, error) {
	if info, err := os.Stat(nameOrPath); err == nil && info.IsDir() {
		p, err := content.LoadPluginDir(nameOrPath)
		if err != nil {
			return nil, err
		}
		if p == nil {
			return nil, fmt.Errorf("%s has no plugin.yaml", nameOrPath)
		}
		return p, nil
	}
	packaged, err := content.Plugins()
	if err != nil {
		return nil, err
	}
	for i := range packaged {
		if packaged[i].Name == nameOrPath {
			return &packaged[i], nil
		}
	}
	if user, _ := config.Load(ctx.userPath); user != nil && user.Organisation != nil && user.Organisation.Repository != "" {
		dir := filepath.Join(user.Organisation.Repository, "plugins", nameOrPath)
		if p, err := content.LoadPluginDir(dir); err == nil && p != nil {
			return p, nil
		}
	}
	return nil, fmt.Errorf("plugin %q not found in the package, the organisation repository, or as a path", nameOrPath)
}

// refuseIfChangesCore rejects a plugin that names a core step as one of its skills: a plugin
// adds, it never redefines core (design section 8, T-02).
func refuseIfChangesCore(p *content.Plugin) error {
	steps, err := content.Steps()
	if err != nil {
		return err
	}
	core := map[string]bool{}
	for _, s := range steps {
		core[s.ID] = true
	}
	names := append([]string(nil), p.Adds.Skills...)
	for _, sk := range p.Skills {
		names = append(names, sk.Name)
	}
	for _, n := range names {
		if core[n] {
			return fmt.Errorf("plugin %s is refused: it redefines the core skill %q; a plugin adds skills under its own name and never changes core", p.Name, n)
		}
	}
	return nil
}

func homeAndUser(opts Options) (string, string, error) {
	home := opts.Home
	if home == "" {
		h, err := os.UserHomeDir()
		if err != nil {
			return "", "", err
		}
		home = h
	}
	userPath := opts.UserConfigPath
	if userPath == "" {
		userPath = filepath.Join(home, ".aa", config.FileName)
	}
	return home, userPath, nil
}

func defaultString(s, d string) string {
	if s == "" {
		return d
	}
	return s
}

func contains(list []string, x string) bool {
	for _, y := range list {
		if y == x {
			return true
		}
	}
	return false
}

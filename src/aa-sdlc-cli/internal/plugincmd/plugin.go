// Package plugincmd implements aa plugin install|update|list|remove: manage tech-stack, tool, and
// process packs at user or project scope without changing core (design section 8, decision
// record 0013, features/cli/plugin.feature).
package plugincmd

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/content"
	"aasdlc.com/aa/internal/targets"
)

// Kinds are the plugin kinds a manifest may declare (decision record 0013).
var Kinds = []string{"tech-stack", "tool", "process"}

// Sources a config records for a plugin that did not come from a folder path.
const (
	sourcePackage      = "package"
	sourceOrganisation = "organisation"
)

// Options are the flags aa plugin accepts.
type Options struct {
	Scope          string // "project" or "user"; default project inside an initialised repository, else user
	Path           string // repository for project scope; default the current directory
	Home           string // override for tests
	UserConfigPath string // override for tests
}

// Install installs a plugin by name (from the package or the organisation repository) or by
// path, replacing any earlier install of it at the scope, and records its version and source.
func Install(nameOrPath string, opts Options, out io.Writer) error {
	ctx, err := resolve(opts)
	if err != nil {
		return err
	}
	p, source, err := find(nameOrPath, ctx)
	if err != nil {
		return err
	}
	if err := validate(p); err != nil {
		return err
	}
	if _, err := targets.RemovePluginClaudeCode(ctx.scopeDir, p.Name); err != nil {
		return err
	}
	res, err := targets.InstallPluginClaudeCode(ctx.scopeDir, *p, ctx.skillRef)
	if err != nil {
		return err
	}
	ctx.record(config.PluginRef{Name: p.Name, Version: p.Version, Source: ctx.sourceFor(source)})
	if err := config.Write(ctx.cfgPath, ctx.cfg, ctx.header); err != nil {
		return err
	}
	fmt.Fprintf(out, "aa plugin install %s %s: %d skills and %d commands installed at %s scope (%s); %s records the plugin\n", p.Name, p.Version, res.Skills, res.Commands, ctx.scope, filepath.Join(ctx.scopeDir, ".claude"), ctx.cfgPath)
	if len(p.Requires) > 0 {
		fmt.Fprintf(out, "  the plugin declares requirements %s; /aa-fw-health will probe them\n", strings.Join(p.Requires, ", "))
	}
	return nil
}

// Update reinstalls the named plugin, or every plugin recorded at the scope, from the source
// the config records for it, and reports the version change and the files added, changed, and
// removed.
func Update(name string, opts Options, out io.Writer) error {
	ctx, err := resolve(opts)
	if err != nil {
		return err
	}
	refs := ctx.cfg.Plugins
	if name != "" {
		refs = nil
		for _, r := range ctx.cfg.Plugins {
			if r.Name == name {
				refs = append(refs, r)
			}
		}
		if len(refs) == 0 {
			return fmt.Errorf("plugin %q is not installed at %s scope; install it with aa plugin install", name, ctx.scope)
		}
	}
	if len(refs) == 0 {
		fmt.Fprintf(out, "aa plugin update: no plugins installed at %s scope\n", ctx.scope)
		return nil
	}
	for _, ref := range refs {
		if err := ctx.update(ref, out); err != nil {
			return fmt.Errorf("%s: %w", ref.Name, err)
		}
	}
	return config.Write(ctx.cfgPath, ctx.cfg, ctx.header)
}

func (ctx *scopeContext) update(ref config.PluginRef, out io.Writer) error {
	p, source, err := ctx.locate(ref)
	if err != nil {
		return err
	}
	if err := validate(p); err != nil {
		return err
	}
	before := pluginFiles(ctx.scopeDir, p.Name)
	if _, err := targets.RemovePluginClaudeCode(ctx.scopeDir, p.Name); err != nil {
		return err
	}
	if _, err := targets.InstallPluginClaudeCode(ctx.scopeDir, *p, ctx.skillRef); err != nil {
		return err
	}
	added, changed, removed := diff(before, pluginFiles(ctx.scopeDir, p.Name))
	ctx.record(config.PluginRef{Name: p.Name, Version: p.Version, Source: ctx.sourceFor(source)})
	switch {
	case ref.Version != p.Version:
		fmt.Fprintf(out, "aa plugin update %s: %s -> %s at %s scope: %d added, %d changed, %d removed\n", p.Name, orUnknown(ref.Version), p.Version, ctx.scope, len(added), len(changed), len(removed))
	case len(added)+len(changed)+len(removed) > 0:
		fmt.Fprintf(out, "aa plugin update %s: %s, files differ from the source at %s scope: %d added, %d changed, %d removed\n", p.Name, p.Version, ctx.scope, len(added), len(changed), len(removed))
	default:
		fmt.Fprintf(out, "aa plugin update %s: %s is current at %s scope\n", p.Name, p.Version, ctx.scope)
	}
	for _, f := range added {
		fmt.Fprintf(out, "    + %s\n", f)
	}
	for _, f := range changed {
		fmt.Fprintf(out, "    ~ %s\n", f)
	}
	for _, f := range removed {
		fmt.Fprintf(out, "    - %s\n", f)
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
	var kept []config.PluginRef
	for _, x := range ctx.cfg.Plugins {
		if x.Name != name {
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

// List prints installed plugins by scope, with each one's version and source, and the plugins
// available from the package and the organisation repository, if one is set.
func List(opts Options, out io.Writer) error {
	_, userPath, err := homeAndUser(opts)
	if err != nil {
		return err
	}
	user, err := config.Load(userPath)
	if err != nil {
		return err
	}
	fmt.Fprintln(out, "Installed")
	var userPlugins []config.PluginRef
	if user != nil {
		userPlugins = user.Plugins
	}
	listScope(out, "user scope", userPlugins)
	projDir, _ := filepath.Abs(defaultString(opts.Path, "."))
	if project, err := config.Load(filepath.Join(projDir, config.FileName)); err == nil && project != nil {
		listScope(out, fmt.Sprintf("project scope (%s)", projDir), project.Plugins)
	}
	fmt.Fprintln(out, "Available")
	packaged, err := content.Plugins()
	if err != nil {
		return err
	}
	for _, p := range packaged {
		fmt.Fprintf(out, "  %s %s (%s, in the package)\n", p.Name, p.Version, p.Kind)
	}
	if org := orgRepository(user); org != "" {
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
		fmt.Fprintln(out, "  the package ships no plugins; the project's optional plugins live in the aa-sdlc-plugins repository")
	}
	return nil
}

func listScope(out io.Writer, label string, refs []config.PluginRef) {
	if len(refs) == 0 {
		fmt.Fprintf(out, "  %s: none\n", label)
		return
	}
	fmt.Fprintf(out, "  %s:\n", label)
	for _, r := range refs {
		fmt.Fprintf(out, "    %s %s (from %s)\n", r.Name, orUnknown(r.Version), orUnknown(r.Source))
	}
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

// record adds or replaces the plugin's entry in the scope's config.
func (ctx *scopeContext) record(ref config.PluginRef) {
	for i := range ctx.cfg.Plugins {
		if ctx.cfg.Plugins[i].Name == ref.Name {
			ctx.cfg.Plugins[i] = ref
			return
		}
	}
	ctx.cfg.Plugins = append(ctx.cfg.Plugins, ref)
}

// sourceFor turns where a plugin was found into what the config records: package and
// organisation as words, a folder as a path relative to the config file when it can be, so a
// committed project config does not carry one machine's absolute path.
func (ctx *scopeContext) sourceFor(source string) string {
	if source == sourcePackage || source == sourceOrganisation {
		return source
	}
	abs, err := filepath.Abs(source)
	if err != nil {
		return filepath.ToSlash(source)
	}
	if rel, err := filepath.Rel(filepath.Dir(ctx.cfgPath), abs); err == nil && filepath.VolumeName(rel) == "" {
		return filepath.ToSlash(rel)
	}
	return filepath.ToSlash(abs)
}

// locate finds a plugin from the source its config entry records; an entry with no source (as
// enterprise and team configs write) is found by name.
func (ctx *scopeContext) locate(ref config.PluginRef) (*content.Plugin, string, error) {
	switch ref.Source {
	case "":
		return find(ref.Name, ctx)
	case sourcePackage:
		if p, err := packaged(ref.Name); err != nil || p != nil {
			return p, sourcePackage, err
		}
		return nil, "", fmt.Errorf("the package no longer ships the plugin %q", ref.Name)
	case sourceOrganisation:
		if p := ctx.fromOrganisation(ref.Name); p != nil {
			return p, sourceOrganisation, nil
		}
		return nil, "", fmt.Errorf("the organisation repository no longer has the plugin %q", ref.Name)
	default:
		dir := filepath.FromSlash(ref.Source)
		if !filepath.IsAbs(dir) {
			dir = filepath.Join(filepath.Dir(ctx.cfgPath), dir)
		}
		p, err := content.LoadPluginDir(dir)
		if err != nil {
			return nil, "", err
		}
		if p == nil {
			return nil, "", fmt.Errorf("its source %s has no plugin.yaml", dir)
		}
		return p, dir, nil
	}
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

// find resolves a plugin by path, then by name in the package, then in the organisation
// repository, and says which source it came from.
func find(nameOrPath string, ctx *scopeContext) (*content.Plugin, string, error) {
	if info, err := os.Stat(nameOrPath); err == nil && info.IsDir() {
		p, err := content.LoadPluginDir(nameOrPath)
		if err != nil {
			return nil, "", err
		}
		if p == nil {
			return nil, "", fmt.Errorf("%s has no plugin.yaml", nameOrPath)
		}
		return p, nameOrPath, nil
	}
	p, err := packaged(nameOrPath)
	if err != nil {
		return nil, "", err
	}
	if p != nil {
		return p, sourcePackage, nil
	}
	if p := ctx.fromOrganisation(nameOrPath); p != nil {
		return p, sourceOrganisation, nil
	}
	return nil, "", fmt.Errorf("plugin %q not found in the package, the organisation repository, or as a path", nameOrPath)
}

func packaged(name string) (*content.Plugin, error) {
	all, err := content.Plugins()
	if err != nil {
		return nil, err
	}
	for i := range all {
		if all[i].Name == name {
			return &all[i], nil
		}
	}
	return nil, nil
}

func (ctx *scopeContext) fromOrganisation(name string) *content.Plugin {
	user, _ := config.Load(ctx.userPath)
	org := orgRepository(user)
	if org == "" {
		return nil
	}
	p, err := content.LoadPluginDir(filepath.Join(org, "plugins", name))
	if err != nil {
		return nil
	}
	return p
}

func orgRepository(user *config.Config) string {
	if user == nil || user.Organisation == nil {
		return ""
	}
	return user.Organisation.Repository
}

// validate applies the rules a plugin must meet before it is installed (decision record 0013):
// it declares one of the kinds, its name cannot shadow a core prefix, it never redefines a core
// skill, and every skill attaches to a core step, process, or requirement that exists.
func validate(p *content.Plugin) error {
	if !contains(Kinds, p.Kind) {
		return fmt.Errorf("plugin %s is refused: its kind is %q; a plugin is one of %s", p.Name, p.Kind, strings.Join(Kinds, ", "))
	}
	ds, err := content.Disciplines()
	if err != nil {
		return err
	}
	for _, d := range ds {
		if p.Name == d.Code {
			return fmt.Errorf("plugin %s is refused: its name is the core discipline code %q, so its skills would be named like core skills", p.Name, d.Code)
		}
	}
	if "aa-"+p.Name == content.SharedGuidanceDir || strings.HasPrefix(content.SharedGuidanceDir, "aa-"+p.Name+"-") {
		return fmt.Errorf("plugin %s is refused: its name collides with the core %s folder", p.Name, content.SharedGuidanceDir)
	}
	steps, err := content.Steps()
	if err != nil {
		return err
	}
	processes, err := content.Processes()
	if err != nil {
		return err
	}
	requirements, err := content.RequirementIDs()
	if err != nil {
		return err
	}
	core := map[string]bool{}
	attachable := map[string]bool{}
	for _, s := range steps {
		core[s.ID] = true
		attachable[s.ID] = true
	}
	for _, id := range processes {
		attachable[id] = true
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
	for _, sk := range p.Skills {
		if len(sk.AttachesTo) == 0 && len(sk.Satisfies) == 0 {
			return fmt.Errorf("plugin %s is refused: its skill %q names no core step, process, or requirement (aa.attaches_to or aa.satisfies); a skill that attaches to nothing is an ordinary agent skill, so install it as one instead", p.Name, sk.Name)
		}
		for _, id := range sk.AttachesTo {
			if !attachable[id] {
				return fmt.Errorf("plugin %s is refused: its skill %q attaches to %q, which is not a core step or process", p.Name, sk.Name, id)
			}
		}
		for _, id := range sk.Satisfies {
			if !contains(requirements, id) {
				return fmt.Errorf("plugin %s is refused: its skill %q satisfies %q, which is not a core requirement", p.Name, sk.Name, id)
			}
		}
	}
	return nil
}

// pluginFiles hashes the installed files of one plugin at a scope.
func pluginFiles(dir, plugin string) map[string]string {
	prefix := "aa-" + plugin + "-"
	out := map[string]string{}
	for p, h := range targets.SnapshotClaudeCode(dir) {
		if strings.HasPrefix(strings.Split(p, "/")[2], prefix) {
			out[p] = h
		}
	}
	return out
}

func diff(before, after map[string]string) (added, changed, removed []string) {
	for p, h := range after {
		old, ok := before[p]
		switch {
		case !ok:
			added = append(added, p)
		case old != h:
			changed = append(changed, p)
		}
	}
	for p := range before {
		if _, ok := after[p]; !ok {
			removed = append(removed, p)
		}
	}
	sort.Strings(added)
	sort.Strings(changed)
	sort.Strings(removed)
	return added, changed, removed
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

func orUnknown(s string) string {
	if s == "" {
		return "unknown"
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

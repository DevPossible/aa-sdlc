// Package updatecmd implements aa update: bring everything setup and init installed up to this
// package version, at user scope and, inside a repository, at project scope, and say what
// changed (features/cli/update.feature).
package updatecmd

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"time"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/plugincmd"
	"aasdlc.com/aa/internal/targets"
	"aasdlc.com/aa/internal/version"
)

// Options are the flags aa update accepts.
type Options struct {
	Path           string // repository to update at project scope; default the current directory
	Home           string // override for tests; default the user's home
	UserConfigPath string // override for tests
	Now            func() time.Time
}

// Run performs aa update and writes a report to out.
func Run(opts Options, out io.Writer) error {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	home := opts.Home
	if home == "" {
		h, err := os.UserHomeDir()
		if err != nil {
			return err
		}
		home = h
	}
	userPath := opts.UserConfigPath
	if userPath == "" {
		userPath = filepath.Join(home, ".aa", config.FileName)
	}
	report := func(format string, a ...any) { fmt.Fprintf(out, format+"\n", a...) }
	report("aa update to package %s", version.Version)

	// User scope: whatever setup installed for the targets the user config names.
	user, err := config.Load(userPath)
	if err != nil {
		return err
	}
	if user == nil {
		report("  no user config at %s; run aa setup first", userPath)
	} else {
		chosen, unknown, err := targets.ByID(user.Targets)
		if err != nil {
			return err
		}
		for _, id := range unknown {
			report("  user config names target %q, which this package does not support; skipped", id)
		}
		if len(chosen) > 0 {
			if err := refresh(targets.UserScope(home), chosen, out); err != nil {
				return err
			}
		}
		user.Install = &config.Install{Version: version.Version, Updated: opts.Now().UTC().Format(time.RFC3339)}
		if err := config.Write(userPath, user, "aa.config.yaml (user scope), written by aa setup and aa update."); err != nil {
			return err
		}
		report("  user config records version %s", version.Version)
		if len(user.Plugins) > 0 {
			if err := plugincmd.Update("", plugincmd.Options{Scope: "user", Path: opts.Path, Home: home, UserConfigPath: userPath}, out); err != nil {
				return err
			}
		}
	}

	// Project scope: only inside an initialised repository with a project-scope install.
	dir := opts.Path
	if dir == "" {
		dir = "."
	}
	dir, err = filepath.Abs(dir)
	if err != nil {
		return err
	}
	project, err := config.Load(filepath.Join(dir, config.FileName))
	if err != nil {
		return err
	}
	if project == nil {
		report("  no project config in %s; project scope skipped", dir)
		return nil
	}
	scope := targets.ProjectScope(dir)
	if len(targets.Snapshot(scope)) == 0 {
		report("  %s has no project-scope install; nothing to update there", dir)
		return nil
	}
	// The repository's harnesses are the ones its config records, or else the ones it already has
	// folders for; never the ones found on this machine.
	chosen, _, err := targets.ByID(project.Targets)
	if err != nil {
		return err
	}
	if len(chosen) == 0 {
		chosen = targets.InRepo(dir)
	}
	if err := refresh(scope, chosen, out); err != nil {
		return err
	}
	report("  config, documents, and feature files untouched")
	if len(project.Plugins) > 0 {
		return plugincmd.Update("", plugincmd.Options{Scope: "project", Path: dir, Home: home, UserConfigPath: userPath}, out)
	}
	return nil
}

// refresh reinstalls the package for the harnesses at a scope, removes core files the package or
// the chosen harnesses no longer need, and reports what changed.
func refresh(scope targets.Scope, chosen []targets.Spec, out io.Writer) error {
	before := targets.Snapshot(scope)
	res, err := targets.Install(scope, chosen)
	if err != nil {
		return err
	}
	removed := targets.RemoveStale(scope, before, res.Written)
	added, changed := diff(before, targets.Snapshot(scope))
	targets.ReportInstall(out, scope, chosen, res)
	fmt.Fprintf(out, "  %s scope: %d added, %d changed, %d removed\n", scope.Name, len(added), len(changed), len(removed))
	listFiles(out, added, changed, removed)
	return nil
}

func diff(before, after map[string]string) (added, changed []string) {
	for p, h := range after {
		old, ok := before[p]
		switch {
		case !ok:
			added = append(added, p)
		case old != h:
			changed = append(changed, p)
		}
	}
	sort.Strings(added)
	sort.Strings(changed)
	return added, changed
}

func listFiles(out io.Writer, added, changed, removed []string) {
	for _, p := range added {
		fmt.Fprintf(out, "    + %s\n", p)
	}
	for _, p := range changed {
		fmt.Fprintf(out, "    ~ %s\n", p)
	}
	for _, p := range removed {
		fmt.Fprintf(out, "    - %s\n", p)
	}
}

func isDir(p string) bool {
	info, err := os.Stat(p)
	return err == nil && info.IsDir()
}

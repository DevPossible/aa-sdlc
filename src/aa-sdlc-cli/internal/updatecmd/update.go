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
		for _, t := range user.Targets {
			if t != targets.ClaudeCode.ID {
				continue
			}
			before := targets.SnapshotClaudeCode(home)
			res, err := targets.InstallClaudeCode(home, "~/.claude/skills")
			if err != nil {
				return err
			}
			removed := targets.RemoveStaleClaudeCode(home, before, res.Written)
			added, changed := diff(before, targets.SnapshotClaudeCode(home))
			report("  user scope (%s): %d added, %d changed, %d removed", targets.ClaudeCode.Name, len(added), len(changed), len(removed))
			listFiles(out, added, changed, removed)
		}
		user.Install = &config.Install{Version: version.Version, Updated: opts.Now().UTC().Format(time.RFC3339)}
		if err := config.Write(userPath, user, "aa.config.yaml (user scope), written by aa setup and aa update."); err != nil {
			return err
		}
		report("  user config records version %s", version.Version)
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
	if !isDir(filepath.Join(dir, ".claude")) {
		report("  %s has no project-scope install; nothing to update there", dir)
		return nil
	}
	before := targets.SnapshotClaudeCode(dir)
	res, err := targets.InstallClaudeCode(dir, ".claude/skills")
	if err != nil {
		return err
	}
	removed := targets.RemoveStaleClaudeCode(dir, before, res.Written)
	added, changed := diff(before, targets.SnapshotClaudeCode(dir))
	report("  project scope (%s): %d added, %d changed, %d removed; config, documents, and feature files untouched", targets.ClaudeCode.Name, len(added), len(changed), len(removed))
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

// Package uninstallcmd implements aa uninstall: remove the framework from the harnesses the user
// picks, at user or project scope, keeping every other harness working and every file that is not
// the framework's (features/cli/uninstall.feature, decision record 0014).
package uninstallcmd

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/plugincmd"
	"aasdlc.com/aa/internal/targets"
)

// Options are the flags aa uninstall accepts.
type Options struct {
	Scope          string   // "user" (default) or "project"
	Path           string   // repository for project scope; default the current directory
	Targets        []string // harness ids to remove the framework from
	All            bool     // remove it from every harness at the scope
	Interactive    bool     // prompts are allowed: offer the installed harnesses as a checklist
	In             io.Reader
	Home           string
	UserConfigPath string
}

// ErrNothingChosen is returned when no harness was named, -all was not given, and no checklist
// could be offered: uninstall never guesses what to remove.
var ErrNothingChosen = errors.New("nothing removed: name the harnesses with -targets or use -all")

// Run performs aa uninstall and writes a report to out.
func Run(opts Options, out io.Writer) error {
	if opts.In == nil {
		opts.In = os.Stdin
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
	user, err := config.Load(userPath)
	if err != nil {
		return err
	}

	scope := targets.UserScope(home)
	cfg, cfgPath, header := user, userPath, "aa.config.yaml (user scope), written by aa setup.\nTargets and the package version installed; an organisation repository layers enterprise and team scopes over core."
	if opts.Scope == "project" {
		dir, err := filepath.Abs(defaultString(opts.Path, "."))
		if err != nil {
			return err
		}
		scope = targets.ProjectScope(dir)
		cfgPath = filepath.Join(dir, config.FileName)
		if cfg, err = config.Load(cfgPath); err != nil {
			return err
		}
		header = "aa.config.yaml (project scope), written by aa init. See https://aasdlc.com and docs/formats.md.\nconventions.ticket.project is the ONE ticket project this repository maps to (O-09).\nEdit freely; aa init never overwrites this file."
	} else if opts.Scope != "" && opts.Scope != "user" {
		return fmt.Errorf("unknown scope %q; use user or project", opts.Scope)
	}
	if cfg == nil {
		return fmt.Errorf("no %s config at %s; there is nothing of the framework's to remove", scope.Name, cfgPath)
	}

	ids := cfg.Targets
	if len(ids) == 0 && user != nil {
		ids = user.Targets
	}
	installed, _, err := targets.ByID(ids)
	if err != nil {
		return err
	}
	remove, err := choose(opts, installed, out)
	if err != nil {
		return err
	}
	removing := map[string]bool{}
	for _, t := range remove {
		removing[t.ID] = true
	}
	var remaining []targets.Spec
	for _, t := range installed {
		if !removing[t.ID] {
			remaining = append(remaining, t)
		}
	}

	// The harnesses that remain may now need a folder the removed ones used to cover, so they are
	// reinstalled first; then the framework is removed from every folder they do not use.
	cfg.Targets = nil
	for _, t := range remaining {
		cfg.Targets = append(cfg.Targets, t.ID)
	}
	if err := config.Write(cfgPath, cfg, header); err != nil {
		return err
	}
	plan := targets.Plan{}
	if len(remaining) > 0 {
		res, err := targets.Install(scope, remaining)
		if err != nil {
			return err
		}
		plan = res.Plan
		if len(cfg.Plugins) > 0 {
			if err := plugincmd.Update("", plugincmd.Options{Scope: scope.Name, Path: opts.Path, Home: home, UserConfigPath: userPath}, io.Discard); err != nil {
				return err
			}
		}
	}
	removed := targets.RemoveExcept(scope, plan)

	for _, t := range remove {
		fmt.Fprintf(out, "aa uninstall: %s removed at %s scope\n", t.Name, scope.Name)
	}
	fmt.Fprintf(out, "  %d framework files and folders removed; nothing else was touched\n", len(removed))
	for _, r := range removed {
		fmt.Fprintf(out, "    - %s\n", r)
	}
	if opts.Scope == "project" {
		keep := map[string]bool{}
		for _, f := range targets.InstructionFiles(remaining) {
			keep[f] = true
		}
		for _, f := range targets.InstructionFiles(remove) {
			if keep[f] {
				continue
			}
			changed, err := targets.RemoveInstructionBlock(scope.Dir, f)
			if err != nil {
				return err
			}
			if changed {
				fmt.Fprintf(out, "  %s: AA-SDLC block removed; the rest of the file is left as it was\n", f)
			}
		}
	}
	if len(remaining) > 0 {
		fmt.Fprintf(out, "  still installed: %s\n", names(remaining))
	}
	return nil
}

// choose settles the harnesses to remove: -all, -targets, or a checklist of the installed ones
// with none ticked. Without any of them it removes nothing.
func choose(opts Options, installed []targets.Spec, out io.Writer) ([]targets.Spec, error) {
	switch {
	case opts.All:
		return installed, nil
	case len(opts.Targets) > 0:
		found, unknown, err := targets.ByID(opts.Targets)
		if err != nil {
			return nil, err
		}
		if len(unknown) > 0 {
			return nil, fmt.Errorf("no supported target named %v", unknown)
		}
		return found, nil
	case opts.Interactive && len(installed) > 0:
		ticked := map[string]bool{}
		targets.Checklist("Remove the framework from which harnesses? Enter numbers to tick or untick, then Enter to continue.", installed, ticked, nil, opts.In, out)
		var chosen []targets.Spec
		for _, t := range installed {
			if ticked[t.ID] {
				chosen = append(chosen, t)
			}
		}
		if len(chosen) == 0 {
			return nil, ErrNothingChosen
		}
		return chosen, nil
	default:
		return nil, ErrNothingChosen
	}
}

func names(ts []targets.Spec) string {
	s := ""
	for i, t := range ts {
		if i > 0 {
			s += ", "
		}
		s += t.Name
	}
	return s
}

func defaultString(s, d string) string {
	if s == "" {
		return d
	}
	return s
}

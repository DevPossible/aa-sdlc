// Package setupcmd implements aa setup: bootstrap the machine by installing the skills and
// commands for every detected agent target at user scope and writing the user config
// (features/cli/setup.feature, design 7.1).
package setupcmd

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/targets"
	"aasdlc.com/aa/internal/version"
)

// Options are the flags aa setup accepts.
type Options struct {
	Home           string // override for tests; default the user's home
	UserConfigPath string // override for tests; default <home>/.aa/aa.config.yaml
	OrgRepository  string // organisation config repository to layer over core (path or URL)
	Team           string // team subfolder in the organisation repository
	Now            func() time.Time
}

// Run performs aa setup and writes a report to out.
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
	report("aa setup (package %s)", version.Version)

	found := targets.Detect(home, "")
	if len(found) == 0 {
		names := make([]string, len(targets.Supported))
		for i, t := range targets.Supported {
			names[i] = t.Name
		}
		report("  no supported agent target found on this machine; supported: %s", strings.Join(names, ", "))
	}
	var installed []string
	for _, t := range found {
		switch t.ID {
		case targets.ClaudeCode.ID:
			res, err := targets.InstallClaudeCode(home, "~/.claude/skills")
			if err != nil {
				return err
			}
			report("  %s: %d skills and %d commands installed at user scope (%s)", t.Name, res.Skills, res.Commands, filepath.Join(home, ".claude"))
			installed = append(installed, t.ID)
		}
	}

	existing, err := config.Load(userPath)
	if err != nil {
		return err
	}
	user := &config.Config{Version: 1, Scope: "user"}
	if existing != nil {
		user = existing
	}
	for _, id := range installed {
		if !contains(user.Targets, id) {
			user.Targets = append(user.Targets, id)
		}
	}
	if opts.OrgRepository != "" || opts.Team != "" {
		if user.Organisation == nil {
			user.Organisation = &config.Organisation{}
		}
		if opts.OrgRepository != "" {
			user.Organisation.Repository = opts.OrgRepository
		}
		if opts.Team != "" {
			user.Organisation.Team = opts.Team
		}
	}
	user.Install = &config.Install{Version: version.Version, Updated: opts.Now().UTC().Format(time.RFC3339)}
	header := "aa.config.yaml (user scope), written by aa setup.\nTargets and the package version installed; an organisation repository layers enterprise and team scopes over core."
	if err := config.Write(userPath, user, header); err != nil {
		return err
	}
	report("  wrote %s", userPath)
	if user.Organisation != nil && user.Organisation.Repository != "" {
		report("  organisation repository: %s (enterprise and team scopes are read from it when it is a local path)", user.Organisation.Repository)
	}
	report("")
	report("Next: cd into a repository and run aa init.")
	return nil
}

func contains(list []string, x string) bool {
	for _, y := range list {
		if y == x {
			return true
		}
	}
	return false
}

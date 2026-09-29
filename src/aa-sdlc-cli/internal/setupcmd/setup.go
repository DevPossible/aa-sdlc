// Package setupcmd implements aa setup: bootstrap the machine by installing the skills and
// commands for every chosen agent harness at user scope and writing the user config
// (features/cli/setup.feature, design 7.1, decision record 0014).
package setupcmd

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"time"

	"aasdlc.com/aa/internal/config"
	"aasdlc.com/aa/internal/targets"
	"aasdlc.com/aa/internal/tools"
	"aasdlc.com/aa/internal/version"
)

// Options are the flags aa setup accepts.
type Options struct {
	Home           string // override for tests; default the user's home
	UserConfigPath string // override for tests; default <home>/.aa/aa.config.yaml
	OrgRepository  string // organisation config repository to layer over core (path or URL)
	Team           string // team subfolder in the organisation repository
	Targets        []string
	Interactive    bool         // prompts are allowed: offer the harnesses as a checklist
	In             io.Reader    // where checklist answers come from; default os.Stdin
	Run            tools.Runner // runs prerequisite checks and installs; default tools.Shell
	Now            func() time.Time
}

// Run performs aa setup and writes a report to out.
func Run(opts Options, out io.Writer) error {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	if opts.In == nil {
		opts.In = os.Stdin
	}
	// one buffered reader for every answer, so the checklist and the install prompts share it
	reader := bufio.NewReader(opts.In)
	opts.In = reader
	if opts.Run == nil {
		opts.Run = tools.Shell
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

	// The framework's own prerequisites on this machine, installed only with consent.
	report("  prerequisites:")
	tools.Ensure(tools.Prerequisites("pwsh"), opts.Run, func(question string) bool {
		if !opts.Interactive {
			return false
		}
		fmt.Fprint(out, question+" [y/N]: ")
		line, _ := reader.ReadString('\n')
		answer := strings.TrimSpace(line)
		return strings.EqualFold(answer, "y") || strings.EqualFold(answer, "yes")
	}, "", out)

	existing, err := config.Load(userPath)
	if err != nil {
		return err
	}
	user := &config.Config{Version: 1, Scope: "user"}
	if existing != nil {
		user = existing
	}

	detected, unsupported := targets.Detect(home, "")
	chosen, err := choose(opts, detected, user.Targets, out)
	if err != nil {
		return err
	}
	if len(chosen) == 0 {
		report("  no supported agent target found on this machine; supported: %s", strings.Join(targets.SupportedNames(), ", "))
	} else {
		scope := targets.UserScope(home)
		res, err := targets.Install(scope, chosen)
		if err != nil {
			return err
		}
		targets.ReportInstall(out, scope, chosen, res)
		// A harness no longer chosen loses the framework, as aa uninstall would remove it.
		if removed := targets.RemoveExcept(scope, res.Plan); len(removed) > 0 {
			report("  removed the framework from folders no chosen harness reads: %d entries", len(removed))
		}
	}
	for _, t := range unsupported {
		report("  %s: not installed: %s", t.Name, t.Reason)
	}

	user.Targets = nil
	for _, t := range chosen {
		user.Targets = append(user.Targets, t.ID)
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
	if len(user.Plugins) > 0 {
		report("  user-scope plugins: run aa update to reinstall them for the chosen harnesses")
	}
	if user.Organisation != nil && user.Organisation.Repository != "" {
		report("  organisation repository: %s (enterprise and team scopes are read from it when it is a local path)", user.Organisation.Repository)
	}
	report("")
	report("Next: cd into a repository and run aa init.")
	return nil
}

// choose settles the harnesses to install into. Named targets win; otherwise every harness
// detected or already recorded is chosen, and an interactive run offers them as a checklist.
func choose(opts Options, detected []targets.Spec, recorded []string, out io.Writer) ([]targets.Spec, error) {
	if len(opts.Targets) > 0 {
		found, unknown, err := targets.ByID(opts.Targets)
		if err != nil {
			return nil, err
		}
		if len(unknown) > 0 {
			return nil, fmt.Errorf("no supported target named %s; run aa setup -targets with ids from: %s", strings.Join(unknown, ", "), supportedIDs())
		}
		return found, nil
	}
	ticked := map[string]bool{}
	for _, t := range detected {
		ticked[t.ID] = true
	}
	previous, _, err := targets.ByID(recorded)
	if err != nil {
		return nil, err
	}
	for _, t := range previous {
		ticked[t.ID] = true
	}
	all, err := targets.All()
	if err != nil {
		return nil, err
	}
	var supported []targets.Spec
	for _, t := range all {
		if t.Supported() {
			supported = append(supported, t)
		}
	}
	if opts.Interactive {
		found := map[string]bool{}
		for _, t := range detected {
			found[t.ID] = true
		}
		targets.Checklist("Install into these agent harnesses? Enter numbers to tick or untick, then Enter to continue.", supported, ticked, found, opts.In, out)
	}
	var chosen []targets.Spec
	for _, t := range supported {
		if ticked[t.ID] {
			chosen = append(chosen, t)
		}
	}
	return chosen, nil
}

func supportedIDs() string {
	all, _ := targets.All()
	var ids []string
	for _, t := range all {
		if t.Supported() {
			ids = append(ids, t.ID)
		}
	}
	return strings.Join(ids, ", ")
}

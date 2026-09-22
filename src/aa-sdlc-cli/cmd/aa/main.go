// Command aa is the AA-SDLC CLI: setup for the machine, init for a repository, update, and
// plugin (design 7.1). Health is an agent command, not a CLI verb (decision 18).
package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"aasdlc.com/aa/internal/initcmd"
	"aasdlc.com/aa/internal/plugincmd"
	"aasdlc.com/aa/internal/setupcmd"
	"aasdlc.com/aa/internal/updatecmd"
	"aasdlc.com/aa/internal/version"
)

// stdinIsTerminal reports whether stdin is an interactive terminal, so init knows whether it
// may prompt. Standard library only: a character device is a terminal, a pipe or file is not.
func stdinIsTerminal() bool {
	info, err := os.Stdin.Stat()
	if err != nil {
		return false
	}
	return info.Mode()&os.ModeCharDevice != 0
}

const usage = `aa: the AA-SDLC command line

Usage:
  aa setup   [-org <repository>] [-team <name>]     bootstrap this machine: install skills and commands for every detected agent at user scope
  aa init    [-path <dir>] [-ticket-project <key>] [-ticket-url <url>] [-knowledge-space <key>] [-knowledge-url <url>] [-shell pwsh|sh] [-yes]
                                                    bootstrap a repository, then hand off to /aa-fw-health and /aa-fw-init in your agent
  aa update  [-path <dir>]                          bring everything setup and init installed up to this package version, at user scope and in this repository
  aa plugin  add <name|path> | remove <name> | list [-scope project|user] [-path <dir>]
                                                    manage tech-stack and process packs at a scope; a plugin adds skills and never changes core
  aa version                                        print the package version, commit, and build date

Health is not a CLI verb: run /aa-fw-health inside your agent, because the probes that matter
(can the agent reach the ticket system, the knowledge base, source control) can only be made there.
`

func main() {
	os.Exit(run(os.Args[1:]))
}

func run(args []string) int {
	if len(args) == 0 {
		fmt.Fprint(os.Stderr, usage)
		return 2
	}
	// AA_HOME relocates the user home for target detection and the user config. It exists for
	// tests and isolated installs; unset, the real home is used (decision record 0005).
	home := os.Getenv("AA_HOME")
	userConfig := ""
	if home != "" {
		userConfig = filepath.Join(home, ".aa", "aa.config.yaml")
	}

	switch args[0] {
	case "setup":
		fs := flag.NewFlagSet("setup", flag.ContinueOnError)
		org := fs.String("org", "", "organisation config repository to layer over core")
		team := fs.String("team", "", "team subfolder in the organisation repository")
		if err := fs.Parse(args[1:]); err != nil {
			return 2
		}
		if err := setupcmd.Run(setupcmd.Options{OrgRepository: *org, Team: *team, Home: home, UserConfigPath: userConfig}, os.Stdout); err != nil {
			fmt.Fprintln(os.Stderr, "aa setup:", err)
			return 1
		}
		return 0
	case "init":
		fs := flag.NewFlagSet("init", flag.ContinueOnError)
		var o initcmd.Options
		fs.StringVar(&o.Path, "path", "", "repository to initialise (default: the current directory)")
		fs.StringVar(&o.TicketProject, "ticket-project", "", "key of the one ticket project this repository maps to (O-09)")
		fs.StringVar(&o.TicketURL, "ticket-url", "", "URL of the ticket project")
		fs.StringVar(&o.KnowledgeSpace, "knowledge-space", "", "key of the knowledge base space (O-04)")
		fs.StringVar(&o.KnowledgeURL, "knowledge-url", "", "URL of the knowledge base space")
		fs.StringVar(&o.Shell, "shell", "pwsh", "shell for the root script stubs: pwsh or sh")
		fs.BoolVar(&o.Yes, "yes", false, "consent to every proposal without asking")
		interactive := fs.Bool("interactive", false, "allow prompts even when stdin is not a terminal (used by tests)")
		if err := fs.Parse(args[1:]); err != nil {
			return 2
		}
		o.Interactive = stdinIsTerminal() || *interactive
		o.Home = home
		o.UserConfigPath = userConfig
		if err := initcmd.Run(o, os.Stdin, os.Stdout); err != nil {
			fmt.Fprintln(os.Stderr, "aa init:", err)
			return 1
		}
		return 0
	case "update":
		fs := flag.NewFlagSet("update", flag.ContinueOnError)
		path := fs.String("path", "", "repository to update at project scope (default: the current directory)")
		if err := fs.Parse(args[1:]); err != nil {
			return 2
		}
		if err := updatecmd.Run(updatecmd.Options{Path: *path, Home: home, UserConfigPath: userConfig}, os.Stdout); err != nil {
			fmt.Fprintln(os.Stderr, "aa update:", err)
			return 1
		}
		return 0
	case "plugin":
		if len(args) < 2 {
			fmt.Fprintln(os.Stderr, "aa plugin: expected add <name|path>, remove <name>, or list")
			return 2
		}
		fs := flag.NewFlagSet("plugin", flag.ContinueOnError)
		scope := fs.String("scope", "", "project or user (default: project inside an initialised repository, else user)")
		path := fs.String("path", "", "repository for project scope (default: the current directory)")
		sub := args[1]
		rest := args[2:]
		var name string
		if (sub == "add" || sub == "remove") && len(rest) > 0 && !strings.HasPrefix(rest[0], "-") {
			name, rest = rest[0], rest[1:]
		}
		if err := fs.Parse(rest); err != nil {
			return 2
		}
		opts := plugincmd.Options{Scope: *scope, Path: *path, Home: home, UserConfigPath: userConfig}
		var err error
		switch sub {
		case "add":
			if name == "" {
				fmt.Fprintln(os.Stderr, "aa plugin add: a plugin name or path is required")
				return 2
			}
			err = plugincmd.Add(name, opts, os.Stdout)
		case "remove":
			if name == "" {
				fmt.Fprintln(os.Stderr, "aa plugin remove: a plugin name is required")
				return 2
			}
			err = plugincmd.Remove(name, opts, os.Stdout)
		case "list":
			err = plugincmd.List(opts, os.Stdout)
		default:
			fmt.Fprintf(os.Stderr, "aa plugin: unknown subcommand %q; expected add, remove, or list\n", sub)
			return 2
		}
		if err != nil {
			fmt.Fprintln(os.Stderr, "aa plugin "+sub+":", err)
			return 1
		}
		return 0
	case "health":
		fmt.Fprintln(os.Stderr, "Health is an agent command, not a CLI verb. In your agent, run /aa-fw-health.")
		fmt.Fprintln(os.Stderr, "The probes that matter (ticket system, knowledge base, source control, skills in scope) can only be made from inside the agent.")
		return 2
	case "version", "-v", "--version":
		fmt.Printf("aa %s (%s, built %s)\n", version.Version, version.Commit, version.BuildDate)
		return 0
	case "help", "-h", "--help":
		fmt.Print(usage)
		return 0
	default:
		fmt.Fprintf(os.Stderr, "aa: unknown verb %q\n\n%s", args[0], usage)
		return 2
	}
}

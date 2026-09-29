// Package tools checks that the tools a machine or a project needs are installed at their
// minimum versions, and installs a missing one with consent (R-44, R-45; features/cli/setup.feature,
// features/cli/init.feature).
package tools

import (
	"context"
	"fmt"
	"io"
	"os/exec"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"time"

	"aasdlc.com/aa/internal/config"
)

// Runner runs a command line through the platform's shell and returns what it printed.
type Runner func(command string) (string, error)

// Shell is the Runner for real use: cmd on Windows, sh elsewhere, with a time limit so a check
// that hangs is reported rather than waited on.
func Shell(command string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
	defer cancel()
	var cmd *exec.Cmd
	if runtime.GOOS == "windows" {
		cmd = exec.CommandContext(ctx, "cmd", "/c", command)
	} else {
		cmd = exec.CommandContext(ctx, "sh", "-c", command)
	}
	out, err := cmd.CombinedOutput()
	return string(out), err
}

// Platform names this machine's platform as the install map keys it: windows, macos, or linux.
func Platform() string {
	switch runtime.GOOS {
	case "windows":
		return "windows"
	case "darwin":
		return "macos"
	default:
		return "linux"
	}
}

// Prerequisites are the tools the framework itself needs on a machine: a source control client,
// and PowerShell 7 or newer when the root scripts are PowerShell (the default for aa init).
func Prerequisites(shell string) []config.Tool {
	out := []config.Tool{{
		Name:     "Git",
		Category: "source-control",
		Check:    "git --version",
		Install: map[string]string{
			"windows": "winget install --id Git.Git --exact --source winget --accept-package-agreements --accept-source-agreements",
			"macos":   "brew install git",
		},
		Docs: "https://git-scm.com/downloads",
	}}
	if shell == "" || shell == "pwsh" {
		out = append(out, config.Tool{
			Name:     "PowerShell",
			Category: "shell",
			Version:  "7.0",
			Check:    "pwsh --version",
			Install: map[string]string{
				"windows": "winget install --id Microsoft.PowerShell --exact --source winget --accept-package-agreements --accept-source-agreements",
				"macos":   "brew install --cask powershell",
			},
			Docs: "https://aka.ms/powershell",
		})
	}
	return out
}

// Result is one tool's state on this machine.
type Result struct {
	Tool  config.Tool
	Found string // the version the check printed, or "" when none could be read
	OK    bool   // installed at or above the minimum version
	Err   string // why the check failed, when it did
}

var versionPattern = regexp.MustCompile(`\d+(\.\d+)+|\d+`)

// Check runs a tool's check command and compares the version it prints with the minimum.
func Check(t config.Tool, run Runner) Result {
	out, err := run(t.Check)
	if err != nil {
		return Result{Tool: t, Err: "not found"}
	}
	found := versionPattern.FindString(out)
	return Result{Tool: t, Found: found, OK: t.Version == "" || AtLeast(found, t.Version)}
}

// AtLeast reports whether version a is at or above version b, comparing dotted numbers.
func AtLeast(a, b string) bool {
	as, bs := strings.Split(a, "."), strings.Split(b, ".")
	for i := 0; i < len(bs); i++ {
		var x, y int
		if i < len(as) {
			x, _ = strconv.Atoi(as[i])
		}
		y, _ = strconv.Atoi(bs[i])
		if x != y {
			return x > y
		}
	}
	return true
}

// Describe is one report line for a result.
func Describe(r Result) string {
	need := ""
	if r.Tool.Version != "" {
		need = " (needs " + r.Tool.Version + " or newer)"
	}
	switch {
	case r.OK:
		return fmt.Sprintf("%s %s: found", r.Tool.Name, r.Found)
	case r.Err != "":
		return fmt.Sprintf("%s: missing%s", r.Tool.Name, need)
	default:
		return fmt.Sprintf("%s %s: too old%s", r.Tool.Name, r.Found, need)
	}
}

// Ensure checks each tool, reports it, and offers to install each one that is missing or too old
// with the install command for this platform, running it only when consent agrees, then checks
// it again. A tool with no install command for this platform is reported with where to get it,
// or with fallback. Tools with no check command are skipped: the agent probes them. It returns
// the results after any installs.
func Ensure(ts []config.Tool, run Runner, consent func(question string) bool, fallback string, out io.Writer) []Result {
	var results []Result
	for _, t := range ts {
		if t.Check == "" {
			continue
		}
		r := Check(t, run)
		fmt.Fprintf(out, "    %s\n", Describe(r))
		if !r.OK {
			r = offer(r, run, consent, fallback, out)
		}
		results = append(results, r)
	}
	return results
}

func offer(r Result, run Runner, consent func(string) bool, fallback string, out io.Writer) Result {
	command := r.Tool.Install[Platform()]
	if command == "" {
		where := fallback
		if r.Tool.Docs != "" {
			where = "get it from " + r.Tool.Docs
		}
		if where != "" {
			fmt.Fprintf(out, "      no install command for %s; %s\n", Platform(), where)
		}
		return r
	}
	if !consent(fmt.Sprintf("      Install %s with: %s ?", r.Tool.Name, command)) {
		fmt.Fprintf(out, "      not installed\n")
		return r
	}
	if text, err := run(command); err != nil {
		fmt.Fprintf(out, "      install failed: %v\n%s\n", err, indent(text))
		return r
	}
	again := Check(r.Tool, run)
	if !again.OK {
		// a fresh install is often only on the PATH of a new shell
		fmt.Fprintf(out, "      installed; %s (open a new shell if it is not on this one's PATH yet)\n", Describe(again))
		return again
	}
	fmt.Fprintf(out, "      installed: %s\n", Describe(again))
	return again
}

func indent(s string) string {
	lines := strings.Split(strings.TrimRight(s, "\n"), "\n")
	for i, l := range lines {
		lines[i] = "        " + l
	}
	return strings.Join(lines, "\n")
}

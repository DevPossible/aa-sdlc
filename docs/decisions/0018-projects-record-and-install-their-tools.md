# 0018: Projects record their stack and tools, and setup, init, and health install and check them

**Date:** 2026-09-28 | **Status:** accepted | **Ticket:** none

## Context

The framework required a formatter, an analyser, a package manager, and a feature runner
(R-09, R-12, R-36, R-17), but nothing said which tools a project had chosen, nothing checked
they were installed on the machine at a usable version, and nothing installed them. A new
developer, or a blank repository with no code to infer a stack from, found each gap only when a
step failed. The root scripts default to PowerShell, and nothing checked PowerShell 7 was there.

## Options

- **A. The project config records `stack` and `tools`; the CLI checks and offers installs;
  `/aa-fw-init` surveys, chooses with the user, and records; health checks both.** Chosen.
- **B. Leave installs to each project's `initialize` script.** A blank repository has no script
  yet, and nothing would say what the script should install or check that it did.
- **C. The framework ships a catalogue of tools per stack.** It would name tools in core (T-01)
  and go stale; tech-stack plugins already carry that knowledge.

## Decision

A. The project names its tools once, each with a category, a minimum version, a check command,
and an install command per platform, so the CLI, the `initialize` script, and health read one
list. The framework names only the categories; the user chooses the tools (T-01).

## Consequences

- R-44 (a tool recorded for every category the framework and the stack prescribe) and R-45
  (every recorded tool installed at its minimum version) are required; `/aa-fw-health` probes
  both. `/aa-fw-init` infers the stack or surveys the user, records it, proposes tools per
  category, writes them into `initialize`, installs with consent, and installs or connects the
  ticket and knowledge connectors.
- `aa setup` checks Git and PowerShell 7 or newer and installs them with consent through the
  platform's package manager. `aa init` checks the same, then every tool the project lists.
- A project's install commands come from a file anyone can commit to, so `aa init` runs one only
  when the user agrees to that command; `-yes` does not cover them.

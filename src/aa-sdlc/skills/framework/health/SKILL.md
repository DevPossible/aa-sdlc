---
name: health
description: Aggregate every requirement the installed skills declare, probe each one by doing, and report what is met, unmet, or not applicable, what depends on each, and the state of the install. Never blocks, never changes anything.
aa:
  discipline: framework
  step: health
  guidance_sets: [every-step]
  guidance: [G-04]
  requires: [R-07, R-14, R-15]
---

# /aa-fw-health

The one place the framework's expectations are enumerated and checked (T-10, T-11). It works
anywhere: inside a project, or on a machine with nothing but the install. It reports and never
blocks, and it changes nothing: no file, no ticket, no page, no install. If a probe would need
to create or install something to succeed, the requirement is unmet and `/aa-fw-init` is the
remedy.

## Procedure

1. **Find the install.** Locate the installed content package: in Claude Code, `.claude/skills/`
   at project scope and `~/.claude/skills/` at user scope; in the aa-sdlc repository itself,
   `src/aa-sdlc/`. Under it, find `skills/`, `workflow/guidance-sets/`, `requirements/`, and
   `build-info.json` if present. Record the target, the scope or scopes found, the package
   version and commit, and whether a newer package version is known. If nothing is installed,
   say so and stop after reporting the environment.
2. **Aggregate the declared requirements.** For every `SKILL.md` under the install, read the
   frontmatter: `aa.requires` directly, plus the `requires` of every set named in
   `aa.guidance_sets`, resolved from `workflow/guidance-sets/<set>.yaml`. Then do the same for
   every step in `workflow/steps/` and every process in `workflow/processes/`, because a step
   whose skill is not yet installed still declares what that skill will need, and a project is
   held to the whole workflow, not to the skills that happen to be present. Do the same for any
   installed plugin's skills and manifest. Build one list of requirement ids, and for each id
   the skills, steps, and plugins that depend on it, marking which of those have a skill
   installed. Do not read the registry table for this; the installed package is the truth for
   what is declared.
3. **Resolve each id to its definition.** In `requirements/*.feature`, find the scenarios
   tagged with the id. The feature file names the kind (environment, project, tooling,
   coverage); the scenario tag names the level (`@required`, `@recommended`,
   `@informational`); the met scenario's `Given` steps are the probe; the unmet scenarios'
   remedy lines are the remedy. An id with no scenario is reported as **undefined** and is
   never guessed at.
4. **Read the project context, if a project is in scope.** Find `aa.config.yaml` at the
   repository root and merge it with any user, team, or enterprise scope it names. Read the
   development environment configuration in the documents folder if it exists: it records the
   requirements the project has declared not applicable and why, and the connectors it expects.
   If there is no repository, every project and tooling requirement is **not applicable:
   no project in scope**.
5. **Probe each requirement by doing.** Perform the met scenario's `Given` steps with the tools
   you actually have. To check the ticket system, read a ticket by id through whatever CLI, MCP
   server, or connector is in scope; to check source control, read the remote; to check the
   build, run the root build script; to check a linter, run the lint switch. A file that exists
   proves nothing on its own. Time-box any probe that could hang; a probe that cannot complete
   is unmet with the reason, never silently skipped. Where a probe would change anything, do
   not perform it: report unmet and name the remedy.
6. **Classify.** Each id is exactly one of **met**, **unmet**, **not applicable** (with the
   reason: no project in scope, the target lacks the capability, or the development environment
   configuration records the exception), or **undefined**. Informational requirements are
   reported as present or absent, never as failures.
7. **Report** in the shape below. Return it to the user. Write it to the documents folder only
   if the user asked for a file.

## Guidance

*From the `every-step` set:* What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- Probe by doing, not by looking. To check the ticket system, read a ticket; to check source control, read the remote; to check the build, run the build script. A configuration file that exists proves nothing.
- Report not-applicable as its own status. A requirement that cannot apply here (hooks on a target with no hooks) is not a failure and must not look like one.
- Change nothing. If a probe would need to create, write, or install anything to succeed, report it as unmet and name /aa-fw-init as the remedy.
- Group the report by kind (environment, project, tooling, coverage) and lead with required-and-unmet.

## Report shape

```
# /aa-fw-health

## Install
Target: <target> | Scope(s): <user, project> | Package: <version> (<commit>) | Newer available: <yes/no/unknown>
Skills: <n> (<list or "all 52 steps">) | Commands: <n> | Plugins: <list or none>

## Required and unmet                      <- lead with this; omit the section if empty
| Id | Requirement | Depends on it | Remedy |

## Environment: what the agent can reach
| Id | Level | Status | How probed | Note |
## Project: what the repository contains
| Id | Level | Status | How probed | Note |
## Tooling: what the project supplies
| Id | Level | Status | How probed | Note |
## Coverage: what skills are in scope
| Id | Level | Status | How probed | Note |

## Guided only on this target
<guidance that would be enforced by a hook where the target supports hooks (R-15); here it is guided>

## Coverage by discipline and technology
<per discipline: steps with a skill installed / steps defined>
<per detected technology: skill or plugin in scope, or none>

## Undefined
<ids declared by an installed skill with no scenario in requirements/>
```

Every row's **How probed** says what was actually done: the command run, the ticket read, the
file opened. **Note** carries the not-applicable reason or the unmet detail. Counts are
computed, not estimated (G-02). Coverage is reported per discipline and technology, never as
headcount (T-13).

## What health never does

- Block, gate, or refuse anything, whatever it finds (T-10).
- Create, modify, or delete a file, ticket, page, or install to make a probe pass.
- Name a tool the project has not chosen. A gap is reported as a category ("no formatter for
  this language") with what is available in scope or as a plugin; the choice is the user's
  (T-01).
- Treat "not applicable" as a failure, or hide it. It is its own status with its reason.

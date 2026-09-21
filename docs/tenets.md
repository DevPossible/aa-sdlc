# AASDLC Core Tenets

**Status:** working draft, under active brainstorming. Last updated 2026-09-21.

Tenets are the best practices the SDK guides the agent and the user toward at every step. Skills
cite tenets by ID rather than restating them, so a tenet is written once and applied everywhere.

## What a tenet is, and is not

- A tenet names a **practice**, not a **product**. "Format code before committing" is a tenet.
  "Use Prettier" is not. The project supplies the tool; the tenet says the tool must exist and be
  used.
- A tenet may **imply a tool category** (a formatter, a test runner, a ticket system). It never
  names a brand or a language.
- A tenet may **imply enforcement**. Where a target supports hooks, a tenet can be enforced; where
  it does not, the skill guides. The tenet is the same either way.
- A tenet states **who it applies to**: the agent, the user, or both.
- Each tenet has a stable ID so skills, plugins, and the health command can reference it.

Shape of every tenet:

> **T-nn Short statement**
> *Why:* the failure this prevents.
> *Implies:* a tool category, a hook, or a skill, if any.
> *Applies to:* agent, user, or both.

## A. Compensate for what the agent is bad at

**T-01 Compute, never estimate.**
*Why:* language models are unreliable at arithmetic, date math, counting, and unit conversion,
and are confident when wrong.
*Implies:* any calculation is done by executing code or a tool, and the executed result is what
gets reported.
*Applies to:* agent.

**T-02 Read before you change.**
*Why:* editing from memory of a file, or from an assumption about its contents, produces
plausible-looking breakage.
*Implies:* the agent reads the current state of a file, ticket, or document before modifying it.
*Applies to:* agent.

**T-03 Verify against reality, not against the plan.**
*Why:* a model will report what it intended to do as if it happened. Done means observed, not
claimed.
*Implies:* build output, test output, and tool results are the evidence; a skill's "done" step
requires them.
*Applies to:* both.

**T-04 Say what you do not know.**
*Why:* a fabricated answer costs more than a stated gap. Uncertainty is information.
*Implies:* skills instruct the agent to flag assumptions and unverified claims explicitly, and to
put unresolved questions on the ticket.
*Applies to:* agent.

**T-05 Reproduce before you fix.**
*Why:* fixing a bug that has not been reproduced fixes a guess.
*Implies:* a failing test, a captured log, or an observed failure precedes any fix. See the
`systematic-debugging` discipline skill.
*Applies to:* both.

## B. Keep the work verifiable

**T-06 Format before you commit.**
*Why:* formatting noise hides real changes in review and causes merge conflicts.
*Implies:* the project has a formatter; a pre-commit hook runs it where the target supports
hooks.
*Applies to:* both.

**T-07 Build and test before you claim done.**
*Why:* "it should work" is the most expensive sentence in software.
*Implies:* the project has a build and a test runner; the `verify-before-done` discipline skill
runs them and reports the actual output.
*Applies to:* both.

**T-08 Tests are the specification.**
*Why:* a test is the one description of behaviour that cannot drift from the code.
*Implies:* behaviour is captured as executable tests, written before or alongside the change.
Business-facing behaviour is written in a form the stakeholder can read (for example Gherkin).
See the `test-driven-development` discipline skill.
*Applies to:* both.

**T-09 Fix it or surface it, never hide it.**
*Why:* a skipped test, a suppressed warning, an empty catch block, or a raised timeout is a bug
with a disguise.
*Implies:* skills forbid suppression without a root-cause fix, and require anything left
unresolved to be recorded on the ticket.
*Applies to:* both.

**T-10 Prefer the small change that works.**
*Why:* large changes cannot be reviewed, bisected, or reverted. Small ones can.
*Implies:* one concern per commit, one ticket per branch, and a plan before any multi-step
change. See the `plan-then-execute` discipline skill.
*Applies to:* both.

## C. Keep the work traceable

**T-11 Every piece of work anchors on a ticket.**
*Why:* the ticket is the state store. Work without a ticket has no history, no owner, and no
place to record outcomes.
*Implies:* a ticket system is in scope; every command takes a ticket ID; branches and commits
reference it.
*Applies to:* both.

**T-12 Record decisions where the next person will look.**
*Why:* a decision made in a chat session is lost the moment the session ends.
*Implies:* a knowledge base is in scope; architectural and product decisions are written there
(or as ADRs in the repo) and linked from the ticket.
*Applies to:* both.

**T-13 Source control is the only output that counts.**
*Why:* work that is not committed did not happen.
*Implies:* source control is in scope; artifacts that belong with the code live in the repo;
nothing is left only on a local disk or in a conversation.
*Applies to:* both.

**T-14 Leave the ticket better than you found it.**
*Why:* the next step, and the next person, start from the ticket. Stale tickets make every
downstream step slower.
*Implies:* every skill ends by updating the ticket with what was done, what was produced, and
what remains.
*Applies to:* agent.

## D. Keep the human in charge

**T-15 The agent proposes; the human decides what is irreversible.**
*Why:* deploys, deletions, external messages, and merges to protected branches cannot be undone
by retrying.
*Implies:* skills stop and ask before any irreversible action unless the user has explicitly
granted that action in advance.
*Applies to:* both.

**T-16 Never bypass a gate.**
*Why:* a gate that can be skipped is not a gate. Skipping hooks, forcing pushes, or disabling
checks removes the protection everyone else relies on.
*Implies:* skills never use bypass flags; if a gate blocks, the blocker is fixed or the user is
told.
*Applies to:* both.

**T-17 Report faithfully.**
*Why:* a summary that rounds "mostly passed" up to "passed" destroys the trust the whole process
depends on.
*Implies:* skills report outcomes exactly: failures with their output, skipped steps as skipped,
partial work as partial.
*Applies to:* agent.

## E. Stay consistent, stay portable

**T-18 Same artifact, same place, same name, every time.**
*Why:* consistency is the product. Two teams using the SDK should produce work that is
recognisably the same shape.
*Implies:* the workflow defines each artifact's name and location; skills use them without
variation.
*Applies to:* both.

**T-19 Describe the practice, let the project supply the tool.**
*Why:* naming a brand makes the SDK wrong for every project that uses a different one.
*Implies:* tenets and skills name tool categories only; tech-stack plugins, or the project's own
configuration, name the actual tool.
*Applies to:* SDK authors.

**T-20 Guide first, enforce where you can.**
*Why:* not every target supports hooks, and not every team wants enforcement on day one. The
practice must still be taught.
*Implies:* every tenet is expressed in a skill; hooks are an optional layer per target.
*Applies to:* SDK authors.

**T-21 The core roughs in the framework; other skills supply the specifics.**
*Why:* the SDK cannot know every stack, tool, or organisational process, and should not try.
Its value is the shape of the work, not the details. If the core has to change for a new stack
or a new team, the core is wrong.
*Implies:* every core skill has defined extension points where a plugin, a project's own skills,
or the user's existing tooling can add the specifics. Core skills say what must happen and what
must be produced; they leave how to whatever is in scope. Extensibility is a design requirement
of every core skill, not a feature added later.
*Applies to:* SDK authors.

## How tenets are used

- **Skills** cite tenets by ID in their instructions ("Before marking done, apply T-07 and
  T-17").
- **Discipline skills** are the expanded form of a cluster of tenets (for example
  `verify-before-done` is T-03, T-07, T-17).
- **Hooks** in `targets/<target>/` enforce the tenets that can be enforced mechanically (T-06,
  T-16).
- **Plugins** may add tenets in their own numbered range but never override a core one.
- **`aasdlc-health`** reports which tenets have their implied tool category in scope (a
  formatter, a test runner, a ticket system) and which are guidance-only in the current
  environment.

## Candidates not yet promoted

- "Prefer the boring solution." Strong in spirit, hard to make actionable in a skill.
- "One source of truth per fact." Overlaps with T-12 and T-18; may fold in.
- "Time-box exploration." Useful, but the box size is project-specific.
- "Stop after three failed attempts and reassess." Possibly part of `systematic-debugging`
  rather than a tenet.

# Guidance Backlog

**Status:** working draft. Last updated 2026-09-21.

Guidance is a detail on a step or process that indicates how best to perform it (see the
[vocabulary](vocabulary.md)). Guidance is specific and actionable, written against tool
categories rather than tools (tenet T-01), and exists to compensate for what agents and humans
each reliably get wrong (T-06).

This file is the backlog of guidance not yet attached to a step or process. As skills are
written, guidance moves out of here and into the skill (for a step) or the process definition
(for a process). Each item keeps its ID so it can be traced.

| ID | Guidance | Attaches to | Implies |
|----|----------|-------------|---------|
| G-01 | Always format the code for the changed files before committing, but do not format files that were not changed. | Development: finish-branch | a formatter; a pre-commit hook where supported |
| G-02 | Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate. | all steps | a code execution tool |
| G-03 | Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read. | all steps | none |
| G-04 | Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence. | Development, Testing | a build and a test runner |
| G-05 | Reproduce a bug with a failing test or a captured observation before changing any code to fix it. | Development: implement | a test runner |
| G-06 | Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket. | all steps | none |
| G-07 | Write behaviour as executable tests before or alongside the change. Write business-facing behaviour in a form the stakeholder can read. | Testing: generate-tests; Development: implement | a test runner |
| G-08 | One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed. | Implementation Planning; Development | source control |
| G-09 | Reference the anchor ticket in the branch name and every commit message. | Development: finish-branch | source control, a ticket system |
| G-10 | Record architectural and product decisions in the knowledge base (or as decision records in the repo) and link them from the anchor ticket. | Technical Analysis: architect; Documentation | a knowledge base |
| G-11 | Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation. | all steps | source control |
| G-12 | End every step by updating the anchor ticket with what was done, what was produced, and what remains. | all steps | a ticket system |
| G-13 | Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance. | Operations: release; Development: finish-branch | none |
| G-14 | Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user. | Development: finish-branch | none |
| G-15 | Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial. | all steps | none |
| G-16 | State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket. | Business Analysis; Technical Analysis | a ticket system |
| G-17 | After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation. | Development: implement | none |

## Conventions for writing guidance

- One sentence where possible, two at most. The example G-01 is the model.
- Say what to do and, where it matters, what not to do.
- Name a tool category only if the guidance cannot be followed without one.
- If the guidance only makes sense for one stack or one team, it belongs in a plugin, not here.

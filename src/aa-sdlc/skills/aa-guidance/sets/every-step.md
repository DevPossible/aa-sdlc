# Guidance set `every-step`

What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.

Generated from `src/aa-sdlc/workflow/guidance-sets/every-step.yaml` and `docs/guidance.md` by `scripts/Sync-SkillGuidance.ps1`; do not edit by hand.

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-55** In a ticket system or knowledge base shared with others (T-14), read, count, create, and change only what the project config selects as this project's: its tickets through the configured ticket filter, and its pages under the configured knowledge root. Never change a shared workflow, board, space structure, or another project's ticket or page without its owner's consent; name the change for the owner instead.

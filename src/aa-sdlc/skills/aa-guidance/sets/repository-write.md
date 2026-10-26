# Guidance set `repository-write`

What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

Generated from `src/aa-sdlc/workflow/guidance-sets/repository-write.yaml` and `docs/guidance.md` by `scripts/Sync-SkillGuidance.ps1`; do not edit by hand.

- **G-11** Every artifact that belongs with the code goes into the same task-owned change set as the code, staged or committed under G-40. Nothing that matters is left only in a conversation or unrecorded on a local disk.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Commit only with explicit user authorization, including standing permission for local commits within a named task until revoked or its scope ends. Without it, stage only task-owned changes and present the diff and message; do not stop for authorization already granted. Implementation alone does not authorize commits, and local commit permission grants no delegation, remote-write, protected-merge or release authority; use the user's identity without agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.

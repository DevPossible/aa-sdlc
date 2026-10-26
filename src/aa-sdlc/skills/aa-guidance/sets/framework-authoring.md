# Guidance set `framework-authoring`

What the framework authoring commands do in the aa-sdlc repository: prove with the unit tier, produce each artifact where the workflow names it, and honor explicit task commit authorization.

Generated from `src/aa-sdlc/workflow/guidance-sets/framework-authoring.yaml` and `docs/guidance.md` by `scripts/Sync-SkillGuidance.ps1`; do not edit by hand.

- **G-04** During development run focused checks; before review run the affected build, lint and relevant test tiers, retaining actual output and declaring the scope. At actual branch finish run full build, lint, provenance and every test tier; at release satisfy the release checks. Instruction-only changes use the framework's applicable structural validation rather than claiming product behavior.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-40** Commit only with explicit user authorization, including standing permission for local commits within a named task until revoked or its scope ends. Without it, stage only task-owned changes and present the diff and message; do not stop for authorization already granted. Implementation alone does not authorize commits, and local commit permission grants no delegation, remote-write, protected-merge or release authority; use the user's identity without agent attribution.

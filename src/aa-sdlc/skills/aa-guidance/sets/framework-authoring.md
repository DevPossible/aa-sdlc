# Guidance set `framework-authoring`

What the framework authoring commands do in the aa-sdlc repository: prove with the unit tier, produce each artifact where the workflow names it, and stage rather than commit.

Generated from `src/aa-sdlc/workflow/guidance-sets/framework-authoring.yaml` and `docs/guidance.md` by `scripts/Sync-SkillGuidance.ps1`; do not edit by hand.

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.

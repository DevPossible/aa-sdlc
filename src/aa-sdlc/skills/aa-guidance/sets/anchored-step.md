# Guidance set `anchored-step`

What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

Generated from `src/aa-sdlc/workflow/guidance-sets/anchored-step.yaml` and `docs/guidance.md` by `scripts/Sync-SkillGuidance.ps1`; do not edit by hand.

- **G-12** Update the anchor ticket at work start, meaningful behavior or blocker checkpoints, and review/integration completion with what was done, produced and remains. Reference existing evidence rather than posting an unchanged update merely because another step ran.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- **G-27** Create and anchor tickets only in the repository's one configured ticket project. If the work touches a ticket in another project, create or use a ticket in this project and link the two; never anchor a step on a ticket outside the configured project.
- **G-54** At the start of anchored work, pull Approved scenarios from their feature pages with provenance and record page versions. Later steps may reuse that snapshot after checking its provenance and relevant page versions are current; refresh when requirements changed or currency is unknown, and never claim an unchecked snapshot is current.

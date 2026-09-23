---
name: aa-guidance
description: "The guidance sets every AA-SDLC step reads: one file per set under sets/. Not a command; the step skills name the sets they need and point here."
aa:
  shared: true
---

# aa-guidance

This folder holds the guidance sets the AA-SDLC steps share, one file per set under `sets/`.
A step skill's Guidance section names the sets it reads and gives this folder's path; read
those files before starting the step. Each file states the set's purpose and every rule in it,
verbatim from the framework's guidance registry, with its id.

| Set | For |
|-----|-----|
| `every-step` | Every step, whatever the discipline |
| `anchored-step` | Every step that anchors on a ticket |
| `repository-write` | Every step that writes to the repository |
| `code-change` | Every step that changes code, configuration, or infrastructure |
| `test-writing` | Every step that writes or generates tests |
| `framework-authoring` | The framework's own authoring commands, in the aa-sdlc repository |

The files are generated from the workflow data (`src/aa-sdlc/workflow/guidance-sets/` and
`docs/guidance.md` in the framework repository) by `scripts/Sync-SkillGuidance.ps1`; do not edit
them by hand. This folder is installed beside the step skills and has no command of its own
(decision record 0012).

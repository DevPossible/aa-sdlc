# Framework skills (`fw`)

The framework's own commands. `health`, `init`, and `extend` are specified in `features/` and
not yet written as skills. The authoring commands are written and runnable:

| Skill | Command | Adds |
|-------|---------|------|
| `new-opinion` | `/aa-internal-new-opinion` | an opinion with its implied requirements, guidance, scenarios, and documents |
| `new-tenet` | `/aa-internal-new-tenet` | a tenet with scenarios, citations, and a consistency pass |
| `new-discipline` | `/aa-internal-new-discipline` | a discipline with at least one fully-plumbed step |
| `new-process` | `/aa-internal-new-process` | a process of existing or new steps with an exit condition |
| `new-step` | `/aa-internal-new-step` | a step with definition, skill, scenarios, guidance, and requirements |

The authoring commands run only in the aa-sdlc repository, so they are internal steps named
`/aa-internal-<step>` rather than `/aa-fw-<step>` (decision record 0017).

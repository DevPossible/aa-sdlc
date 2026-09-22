# Workflow

The AA-SDLC methodology as data, and the single source of truth for processes and steps. The
website's methodology page is generated from this folder.

```
processes/<process>.yaml   one per process: ordered step ids, process guidance, exit condition
steps/<step>.yaml          one per step: discipline, command, artifacts with acceptance
                           criteria, guidance ids, requirement ids
```

Format is specified in `docs/formats.md`. A step file's `id` equals its skill folder name and
the last segment of its command (`/aa-<code>-<id>`, code from the discipline), and its
`requires` must match the skill's `aa.requires`.

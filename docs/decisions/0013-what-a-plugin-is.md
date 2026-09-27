# 0013: A plugin is a pack of skills that attach to the life cycle

**Date:** 2026-09-26 | **Status:** accepted | **Ticket:** none

## Context

T-02 has the core rough in the framework and expects plugins to supply the specifics, and
several requirements name a plugin as their remedy (R-09 formatter, R-17 feature-file executor,
R-35 lint, R-36 package manager). The plugin model knew two kinds, tech-stack and process, and
had no rule for what may be a plugin at all. The skills people actually want to add are mostly
tools: a formatter with opinions per language, Playwright for a Blazor app versus a server app,
k6 for load, MSBuild lint commands, pipelines on Azure, GitHub, or GitLab. Many other skills
people load are useful but are not life-cycle work: code generation in a language, script
generation, an organisation's general practices, image generation. Without a rule, a plugin
becomes any skill, and the framework's guarantee that every plugin serves a step is lost.

The user decided that the optional plugins the project maintains live in their own repository,
`aa-sdlc-plugins`, not in the core package.

## Options

- **A. Three kinds, and every plugin skill attaches to the life cycle.** Chosen.
- **B. Widen tech-stack to cover tools.** Fewer kinds, but "Prettier is a tech stack" misleads
  the reader choosing a kind, and the stack-versus-tool distinction is how `/aa-fw-init`
  explains coverage.
- **C. No admission rule; any skill may be a plugin.** Simplest, and it makes a plugin
  indistinguishable from a skill the user loads directly, so the plugin mechanism adds nothing.

## Decision

Option A.

- Kinds are `tech-stack` (a language, framework, or platform: .NET, Blazor), `tool` (a tool the
  life cycle uses: a formatter, a test runner, a load tool, a pipeline system), and `process`
  (an extra step or gate: a change-advisory step, a compliance review).
- Every skill in a plugin names, in its frontmatter, at least one of `aa.attaches_to` (core step
  or process ids) or `aa.satisfies` (core requirement ids), and every id it names must exist in
  core. A skill that names neither is an ordinary agent skill: `aa plugin install` and
  `/aa-fw-extend` refuse it and say so. It remains loadable by the user outside the framework.
- A plugin may name tools (T-01 binds core only). A pipeline pack covers pipeline definitions
  and runs; it never covers the tickets, merge requests, or wiki of the same system (T-05).
- The CLI verb is `aa plugin install | update | list | remove`; `add` stays as another name for
  `install`. The config records each plugin's name, version, and source, so `update` can
  reinstall from where the plugin came from and `list` can show it. A plain name in a config
  (as enterprise and team configs write) is still read.
- `aa update` also updates the plugins recorded at each scope.
- The project's optional plugins live in the `aa-sdlc-plugins` repository. The core package
  ships none. Installing by name from that repository over the network is specified with the
  release and version-check design, in its own record; until then a plugin installs from the
  organisation repository or a path, including a local clone of `aa-sdlc-plugins`.
- `aa-sdlc-plugins` follows the standard repository layout (`docs/`, `scripts/`, `src/`,
  `tests/`, root `build`, `test`, and `pack` scripts). Under `src/` it holds `index.yaml`, which
  lists every plugin with its kind, version, folder, and one-line summary, and one folder per
  plugin with a `README.md`, its `plugin.yaml`, its `skills/`, and its `features/`. The index is
  what the CLI reads to resolve a plugin by name; that repository's build fails when the index
  disagrees with a folder's `plugin.yaml`.

## Consequences

- `plugin.yaml` gains `kind: tool`; plugin skills gain `aa.attaches_to` and `aa.satisfies`.
- `/aa-fw-health` can report which plugin satisfies a requirement.
- Plugin releases are independent of core releases, so a plugin must say which core versions it
  works with; that field comes with the version-check record.
- Remedies that say "the user, or a tech-stack plugin, supplies one" also admit tool packs.

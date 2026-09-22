# AA-SDLC File Formats

**Status:** decided 2026-09-21 (decisions 29 to 31); field lists are working drafts.

Three formats the rest of the framework builds on: workflow data, the `aa` config file, and how
a skill or plugin declares what it needs. All three are YAML. IDs are the same everywhere: `T-nn`
tenets, `O-nn` opinions, `G-nn` guidance, `R-nn` requirements, and for plugins `R-<plugin>-nn`.

## 1. Workflow data

Location: `src/aa-sdlc/workflow/`. This is the single source of truth for processes and steps;
the website's methodology page is generated from it.

```
workflow/
  disciplines/<discipline>.yaml   one per discipline: role, bounded responsibilities, steps
  processes/<process>.yaml        one per process (the six methodology phases, plus smaller ones)
  steps/<step>.yaml               one per step, named exactly as the step and its skill folder
```

### Discipline

```yaml
# workflow/disciplines/development.yaml
id: development                    # equals the file name and the skills subfolder
code: dev                          # 2 or 3 characters; middle segment of every command
name: Development
order: 9                           # position in SDLC order, used by the review generator
purpose: >
  Two or three sentences on what the discipline is for and where it stops.
owns:                              # bounded responsibilities
  - ...
does_not_own:                      # explicit boundaries, naming who does own it
  - ...
hands_off_to:
  - discipline: testing
    when: ...
steps: [setup-environment, implement, fix-bug, review, finish-branch, optimize]
tenets: [T-04, T-05, T-07]
opinions: [O-02, O-06, O-07, O-08]
```

`id`, `code`, `name`, `order`, `purpose`, `owns`, `does_not_own`, `steps` are required. Codes
are unique. Every step listed must exist and name this discipline. `guidance_inline` on a step
holds step-specific guidance until it is shared by a second step, at which point it is promoted
to a `G-nn` id in `docs/guidance.md`.

### Step

```yaml
# workflow/steps/implement.yaml
id: implement                      # equals the skill folder name and the command's last segment
name: Implement a ticket
discipline: development            # one of the discipline ids; its code supplies the middle segment
command: /aa-dev-implement         # /aa-<code>-<id>; derivable, stated for readability
summary: >
  Build what the anchor ticket asks for, with the tests that prove it, on a branch that
  references the ticket.
methodology:                       # where this came from; omitted for steps the SDK added
  phase: 2
  steps: ["2.2", "2.3", "2.4"]
anchor: required                   # required | optional | none
inputs:
  - The anchor ticket and its scenarios in the feature files
  - The implementation plan on the ticket, if plan-implementation ran
artifacts:
  - name: Application code
    location: source folder, on a branch named per the ticket convention
    acceptance:
      - Builds with the root build script
      - Every scenario for the ticket has a passing test at each tier the change touches
  - name: Tests that prove the requirement
    location: unit tests with the project; integration and e2e under tests/
    acceptance:
      - Happy paths, general permutations, and obvious negative cases are covered (G-20)
guidance: [G-02, G-03, G-04, G-05, G-06, G-08, G-09, G-11, G-12, G-17, G-20]
requires: [R-01, R-02, R-04, R-05, R-10, R-11, R-21]
tenets: [T-04, T-07]
```

Field rules:

- `id`, `name`, `discipline`, `command`, `summary`, `anchor`, `artifacts` are required.
- `guidance` and `requires` are lists of IDs only. The text lives once, in `docs/guidance.md`
  and `features/requirements/`. A step may add step-specific guidance inline as
  `guidance_inline: [ "..." ]` until it is promoted to an ID.
- `artifacts[].acceptance` is the acceptance criteria from the methodology, reworded to be
  checkable. Feature files hold the behaviour; this holds the deliverable.

### Process

```yaml
# workflow/processes/conception.yaml
id: conception
name: Conception and idea refinement
summary: >
  From a stakeholder conversation to a refined, prioritised, ticketed backlog with
  architecture decided.
methodology:
  phase: 1
steps:                              # ordered; each is a step id
  - discover
  - refine-requirements
  - prototype
  - architect
  - plan-work
guidance: [G-16, G-18, G-19]        # process-level guidance
exit: >
  Every requirement is a scenario in a feature file, linked to a ticket and a page; the
  architecture is recorded as decision records; the backlog is prioritised.
```

Field rules: `id`, `name`, `summary`, `steps` required. `steps` is order, not enforcement
(T-03). A plugin may add a process, or add steps to an existing one by listing
`insert: { after: <step>, step: <step> }` entries in its manifest.

## 2. The `aa` config file

Name: `aa.config.yaml`. One per scope, merged enterprise, then team, then user, then project,
with the later scope winning.

| Scope | Location |
|-------|----------|
| enterprise | root of the organisation config repository |
| team | a subfolder of the organisation config repository, or a separate repository |
| user | the user's home config folder for `aa` |
| project | the repository root |

```yaml
# aa.config.yaml (project scope)
version: 1
scope: project
targets:                            # which agents this scope installs into
  - claude-code
plugins:                            # added to the merged list, never removed by a lower scope
  - dotnet
  - gitlab-flow
conventions:
  ticket:
    project: "ABC"                  # the ONE ticket system project or group this repo maps to (O-09)
    pattern: "[A-Z]+-\\d+"          # how a ticket id looks; used in tags, branches, commits
    tag: "@{id}"                    # how a scenario is tagged with its ticket
  branch:
    pattern: "{type}/{id}-{slug}"
  commit:
    pattern: "{type}({scope}): {subject}\n\n{id}"   # Conventional Commits (O-14); type comes from the list below
    types: [feat, fix, docs, style, refactor, perf, test, build, ci, chore]
    scopes: []                      # optional allow-list; empty means any scope
folders:                            # only needed when a repo does not use the conventional names
  documents: docs
  features: features
  scripts: scripts
  source: src
  tests: tests
organisation:
  repository: https://git.example.com/platform/aa-config   # set at user or enterprise scope
```

Merge rules:

- Scalars and single values: the later scope overrides.
- `plugins` and `targets`: union, in scope order. A scope can exclude an inherited plugin only
  by listing it under `plugins_exclude`.
- Maps (`conventions`, `folders`): deep merge, later scope wins per key.
- `version` must match across scopes; the CLI refuses to merge mismatched versions.
- A project config with no `folders` block means the conventional names are in use.

The CLI validates every file against a published schema before merging and reports the file
and key that fails.

## 3. Declaring requirements in skills and plugins

### Skill frontmatter

`SKILL.md` keeps the Agent Skills standard fields at the top level and puts everything
framework-specific under one `aa` key, so targets that ignore unknown fields see one unknown
field.

```yaml
---
name: implement
description: Build what the anchor ticket asks for, with the tests that prove it.
aa:
  discipline: development
  step: implement                  # the workflow step this skill delivers
  requires: [R-01, R-02, R-04, R-05, R-10, R-11, R-21]
  guidance: [G-02, G-03, G-04, G-05, G-06, G-08, G-09, G-11, G-12, G-17, G-20]
---
```

`aa.requires` and the step's `requires` in workflow data should match; the build validator
checks that they do. The requirement definitions (kind, level, detect, remedy) live once, as
scenarios in `features/requirements/`, tagged `@R-nn`, `@required|@recommended|@informational`,
and by kind. `/aa-fw-health` reads IDs from installed skills and resolves them against those
scenarios.

### Plugin manifest

```yaml
# plugins/dotnet/plugin.yaml
name: dotnet
version: 0.1.0
kind: tech-stack                    # tech-stack | process
covers:                             # technologies this pack gives skills for (R-13)
  - language: csharp
  - framework: aspnet-core
  - build: msbuild
  - test: xunit
adds:
  skills: [dotnet-implement, dotnet-generate-tests]
  guidance:                         # plugin guidance may name tools
    - id: G-dotnet-01
      text: Run the solution formatter on changed files only before committing.
      attaches_to: finish-branch
      requires: [R-dotnet-01]
  processes: []
  steps: []
requires: [R-dotnet-01, R-dotnet-02] # defined in plugins/dotnet/features/requirements/
```

- Plugin IDs are namespaced: `R-<plugin>-nn`, `G-<plugin>-nn`.
- A plugin's requirement definitions are feature files in its own `features/requirements/`,
  same shape as core's.
- A plugin cannot list a core id under `adds`; `/aa-fw-extend` and the build validator refuse it.

## What this settles and what it does not

Settled: file formats, locations, id scheme, merge rules, where each kind of text lives once.

Not settled: the JSON schema files themselves for workflow and config (to be written with the
CLI); how `/aa-fw-health` performs a plain-language `detect` on targets with no script support;
the folder-mapping UX in `/aa-fw-init` for existing repositories.

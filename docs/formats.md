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
internal: false                    # true only for a step run in the aa-sdlc repository alone;
                                   # its command is then /aa-internal-<id> and the website skips it
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
- `guidance_sets` names the guidance sets the step belongs to (below). `guidance` and
  `requires` then list only the ids the sets do not already supply; the validator rejects an
  id that a set already provides. The text lives once, in `docs/guidance.md` and
  `features/requirements/`. A step may add step-specific guidance inline as
  `guidance_inline: [ "..." ]` until it is promoted to an ID.
- `artifacts[].acceptance` is the acceptance criteria from the methodology, reworded to be
  checkable. Feature files hold the behaviour; this holds the deliverable.
- `internal: true` marks a step that runs only in the aa-sdlc repository. Its command is
  `/aa-internal-<id>` instead of `/aa-<code>-<id>`, and the website neither lists nor counts it
  (decision record 0017). Omit it otherwise.

### Guidance set

```yaml
# workflow/guidance-sets/repository-write.yaml
id: repository-write               # equals the file name; cited from steps as guidance_sets: [...]
purpose: >
  One sentence on what kind of step this set belongs to and what it makes the step do.
guidance: [G-11, G-33, G-39, G-40, G-42]
requires: [R-01, R-05, R-28, R-31, R-33]
```

A guidance set is a named list of guidance and requirement ids that many steps share, so a
step cites the set once instead of a dozen ids. Sets are flat; one set does not include
another. The current sets are `every-step`, `anchored-step`, `repository-write`,
`code-change`, `test-writing`, and `framework-authoring`. The review generator expands each
set under the step that cites it, and a skill's frontmatter declares the same `guidance_sets`
as its step.

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
  - dotnet-sdlc
  - change-advisory
conventions:
  ticket:
    project: "ABC"                  # the ONE ticket system project or group this repo maps to (O-09)
    url: https://tickets.example.com/projects/ABC   # where it lives; the agent finds a connector for it (T-05)
    pattern: "[A-Z]+-\\d+"          # how a ticket id looks; used in tags, branches, commits
    tag: "@{id}"                    # how a scenario is tagged with its ticket
    kinds:                          # the framework's ticket kinds, as the ticket system names them (O-26)
      epic: Epic
      story: Story
      task: Task
      bug: Bug
      spike: Spike
    states:                         # the framework's life cycle, as the ticket system names it (O-26)
      new: To Do
      refined: Ready for dev
      planned: Planned
      in-progress: In Progress
      in-review: In Review
      accepted: Accepted
      done: Done
  knowledge:
    space: "ABC"                    # the knowledge repository for this project (O-04)
    url: https://wiki.example.com/spaces/ABC
    sections:                       # the six top-level sections, as the space names them (O-27)
      overview: Overview
      requirements: Requirements
      architecture: Architecture
      operations: Operations
      releases: Releases
      guides: Guides
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
  decisions: docs/decisions         # numbered, immutable decision records (O-18); a knowledge base location may be named instead
stack:                              # what /aa-fw-init inferred or the user answered in its survey (R-44)
  description: Order tracking web API for the warehouse team
  languages: [csharp 13, typescript 5.6]
  frameworks: [aspnetcore 9, react 19]
  platforms: [linux containers]
  deploy: Azure Container Apps
  pipeline: GitHub Actions
  containers: true                  # the e2e tier runs in containers locally (R-25, R-26)
tools:                              # one entry per tool the project uses (R-44); aa init and health check each (R-45)
  - name: PowerShell
    category: shell                 # shell, source-control, build, package-manager, formatter, static-analysis,
                                    # feature-runner, container-runtime, ticket-connector, knowledge-connector
    version: "7.4"                  # minimum
    check: pwsh --version           # prints the version; omitted for a connector the agent loads
    install:                        # per platform, through its package manager; the initialize script runs these
      windows: winget install --id Microsoft.PowerShell --exact --source winget
      macos: brew install --cask powershell
    docs: https://aka.ms/powershell # where to get it on a platform with no install command
  - name: .NET SDK
    category: build
    language: csharp
    version: "9.0"
    check: dotnet --version
    install:
      windows: winget install --id Microsoft.DotNet.SDK.9 --exact --source winget
organisation:
  repository: https://git.example.com/platform/aa-config   # set at user or enterprise scope
```

Merge rules:

- Scalars and single values: the later scope overrides.
- `plugins` and `targets`: union, in scope order. A scope can exclude an inherited plugin only
  by listing it under `plugins_exclude`.
- Maps (`conventions`, `folders`): deep merge, later scope wins per key.
- `tools`: one entry per name; a later scope's entry replaces an earlier one. `stack`: the later
  scope's replaces the earlier one.
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
  guidance_sets: [every-step, anchored-step, code-change, test-writing]
  requires: [R-26, R-27, R-34, R-39]            # only what the sets do not supply
  guidance: [G-05, G-17, G-20, G-30, G-32, G-43, G-48]
---
```

`aa.guidance_sets`, `aa.guidance`, and `aa.requires` must equal the step's fields in the
workflow data; the build validator checks that they do. The requirement definitions (kind, level, detect, remedy) live once, as
scenarios in `features/requirements/`, tagged `@R-nn`, `@required|@recommended|@informational`,
and by kind. `/aa-fw-health` reads IDs from installed skills and resolves them against those
scenarios.

### Plugin manifest

```yaml
# src/dotnet-sdlc/plugin.yaml, in a plugin repository
name: dotnet-sdlc
version: 0.1.0
kind: tech-stack                    # tech-stack | tool | process
covers:                             # technologies this pack gives skills for (R-13)
  - language: csharp
  - framework: aspnet-core
  - build: msbuild
  - test: xunit
adds:
  skills: [build, lint]           # installed as aa-dotnet-sdlc-build, aa-dotnet-sdlc-lint
  guidance:                         # plugin guidance may name tools
    - id: G-dotnet-sdlc-01
      text: Run the solution formatter on changed files only before committing.
      attaches_to: finish-branch
      requires: [R-dotnet-sdlc-01]
  processes: []
  steps: []
requires: [R-dotnet-sdlc-01, R-dotnet-sdlc-02] # defined in features/requirements/ beside the manifest
```

- Every plugin skill's `SKILL.md` frontmatter names what it attaches to, at least one of:

  ```yaml
  aa:
    attaches_to: [e2e-tests]        # core step or process ids
    satisfies: [R-09]               # core requirement ids
  ```

  Every id must exist in core. A skill with neither is refused as a plugin skill (decision
  record 0013).
- Plugin IDs are namespaced: `R-<plugin>-nn`, `G-<plugin>-nn`.
- A plugin repository (the project's own is `aa-sdlc-plugins`) keeps each plugin in
  `src/<name>/` with a `README.md`, and lists them all in `src/index.yaml`:

  ```yaml
  # src/index.yaml
  plugins:
    - name: k6-sdlc
      kind: tool
      version: 0.1.0
      path: k6-sdlc
      summary: Load and performance tests with k6 for the performance-test step.
  ```

  The repository's build checks every entry against the folder's `plugin.yaml`.
- A plugin's requirement definitions are feature files in its own `features/requirements/`,
  same shape as core's.
- A plugin cannot list a core id under `adds`; `/aa-fw-extend` and the build validator refuse it.

## 4. A project's feature files

The feature files in the project's features folder are the requirements (T-12, O-01). Each
feature and each scenario carries a stable id, and each scenario carries its anchor ticket, so a
requirement can be traced to its ticket, its page, and the tests that prove it (G-19, G-49).

```gherkin
# features/orders/export-order-history.feature
@F-012
Feature: Customers can export their order history
  Knowledge base page: Requirements / Orders / Export order history

  @F-012-01 @ABC-142
  Scenario: Export the last twelve months as CSV
    Given a customer with orders in the last twelve months
    When they export their order history
    Then they receive a CSV with one row per order
```

- A feature id is `@F-` and a number, unique in the repository, on the line above `Feature:`.
- A scenario id is the feature id, a hyphen, and a number unique within the feature.
- Ids are assigned once, when the feature or scenario is written, and never renumbered or
  reused. A deleted scenario's id stays retired; a moved scenario keeps its id.
- Every automated test that proves a scenario names the scenario's id, in the form the test
  framework supports: a tag, a category, a trait, or the test's name. A scenario is covered when
  at least one test names its id.
- The ticket tag follows the project config's `conventions.ticket.tag` (section 2).

## What this settles and what it does not

Settled: file formats, locations, id scheme, merge rules, where each kind of text lives once.

Not settled: the JSON schema files themselves for workflow and config (to be written with the
CLI); how `/aa-fw-health` performs a plain-language `detect` on targets with no script support;
the folder-mapping UX in `/aa-fw-init` for existing repositories.

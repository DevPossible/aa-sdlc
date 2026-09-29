# Features

The framework's own requirements, as Gherkin feature files **generated** from the feature pages
in [`docs/knowledge/Requirements/`](../docs/knowledge/Requirements/) (T-12, decision record 0019).
The pages are the source of truth; these files are what the tests read. Do not edit them: each
starts with a provenance header whose checksum the unit tier, and any review, checks.

## Layout

```
features/
  framework/      how the framework itself behaves (requirements sync, test responsibility, extensibility)
  cli/            one feature per aa CLI verb
  agent/          one feature per agent-only command
  requirements/   the requirements registry as scenarios, one file per kind
  <discipline>/   one feature per step
```

Each folder is a topic: `docs/knowledge/Requirements/<topic>/<feature>.md` generates
`features/<topic>/<feature>.feature`.

## Conventions

- One feature per page. The feature description (the free text under the page's Feature table)
  says why the feature exists.
- Every scenario is tagged with the framework IDs it realises: `@T-nn`, `@O-nn`, `@R-nn`,
  `@G-nn`. Requirement scenarios also carry their level: `@required`, `@recommended`,
  `@informational`.
- Every feature carries a stable id, `F-nnn`, and every scenario one derived from it, `F-nnn-nn`
  (G-49). Ids are assigned on the page, never renumbered or reused.
- A scenario is `Draft`, `Approved`, or `Retired` on its page; only `Approved` scenarios are
  pulled into these files.
- Scenarios describe observable behaviour in plain language. They name tool categories, never
  tools (T-01).

## Changing a requirement

Change the page first: add or edit the Feature, Scenario, and Step tables in
`docs/knowledge/Requirements/<topic>/<feature>.md`, leaving a new id cell empty. Then run
`./scripts/Add-FeatureId.ps1`, which assigns the ids and pulls the feature files, and commit the
page with the files it regenerated. The format is in `docs/formats.md`, section 4.

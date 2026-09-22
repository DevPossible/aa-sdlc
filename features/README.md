# Features

The framework's own requirements, captured as Gherkin. Per tenet T-12 and opinion O-01, these
feature files are the source of truth for what the framework must do. The tables in
`docs/requirements.md` are an index; where they disagree with a feature file, the feature file
wins.

## Layout

```
features/
  framework/      how the framework itself behaves (requirements sync, tenets in action)
  cli/            one feature per aa CLI verb
  agent/          one feature per agent-only command
  requirements/   the requirements registry as scenarios, one file per kind
```

## Conventions

- One `Feature:` per file. The feature description (the free text under the title) says why the
  feature exists and links to its knowledge base page once one exists.
- Every scenario is tagged with the framework IDs it realises: `@T-nn`, `@O-nn`, `@R-nn`,
  `@G-nn`. Requirement scenarios also carry their level: `@required`, `@recommended`,
  `@informational`.
- In a consuming project the same shape applies, with a ticket tag per scenario
  (`@TICKET-123` or the project's configured pattern) in place of framework IDs.
- Scenarios describe observable behaviour in plain language. They name tool categories, never
  tools (T-01).
- Steps are written so a person, an agent, and eventually an executor can all read them the same
  way. Executable step definitions are a later concern; the text is the contract now.

## Changing a requirement

Change the feature file first. The ticket and the knowledge base page follow from it, and the
tooling keeps them aligned (T-12). A requirement edited only in a ticket or a page is a conflict
to be surfaced, not a change.

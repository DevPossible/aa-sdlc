# 0002: This repository maps to Jira project AA and Confluence space AS

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

O-09 requires every repository to map to exactly one ticket project, recorded in the project
config (R-22), and O-04 requires a knowledge repository (R-03). Neither was recorded for this
repository. The owner was asked, per the `/aa-fw-init` flow in plan task C5, and named the
Jira project at `https://devpossible.atlassian.net/jira/software/projects/AA` and the Confluence
space at `https://devpossible.atlassian.net/wiki/spaces/AS`.

## Options

- **A. Jira project AA and Confluence space AS.** The systems the owner already uses. Chosen.
- **B. GitLab issues and wiki on the repository's remote.** In scope with no extra connector,
  but not where the owner tracks this work.
- **C. No ticket system yet.** Would leave R-22 and R-03 unmet and every anchored step producing
  local artifacts.

## Decision

Option A. `aa.config.yaml` records `conventions.ticket.project: AA` with the project URL and
`conventions.knowledge.space: AS` with the space URL. Decision records stay in
`docs/decisions/` (this folder) rather than the Confluence space, because the repository is
public and its decisions should travel with it.

## Consequences

- Per T-05, the agent uses whatever connector for these systems is already in its scope. At the
  time of this decision an Atlassian connector was present in the session but the devpossible
  site was not granted to it, so the mapping is recorded and health will report R-02 and R-03
  unmet until the connector is authorised for that site. The mapping itself is not blocked by
  that (T-10).
- Ticket ids follow the pattern `AA-<number>`; branches and commit footers reference them (R-08).
- `/aa-fw-health` probes R-22 against project AA once a connector is authorised.

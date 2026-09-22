# 0006: No formatter tool is adopted for YAML, Gherkin, or Markdown; a text-convention check stands in

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

The health baseline (development-environment.md) found R-09 unmet for the three non-PowerShell
formats in this repository: the workflow YAML, the feature files, and the documents. O-21 wants
conventions enforced by tools. The widely used formatters for these formats run on Node, which
decision 0004 keeps out of this repository, and the formats here are small and hand-shaped
(flow lists for ids, two-space YAML, 100-column prose). Plan task B5.

## Options

- **A. Adopt no formatter for the three formats and enforce the conventions that matter with a
  small check in `build.ps1 -Lint`: LF line endings, no tabs, no trailing whitespace, a final
  newline, and two-space indentation in YAML.** Mechanical, dependency-free, and covers what a
  formatter would actually change here. Chosen.
- **B. Adopt a Node-based formatter.** Contradicts decision 0004 for a marginal gain.
- **C. Adopt a Go-based YAML and Markdown formatter.** Adds a toolchain step and a dependency
  for formats whose structure the validators already check; revisit if the documents grow.

## Decision

Option A. `build.ps1 -Lint` gains a text-convention check over `*.yaml`, `*.feature`, `*.md`,
and `*.json` under the repository (excluding build outputs and generated `discipline-review.md`
only for line length): the file ends with a newline, has no CRLF, no tab characters, and no
trailing whitespace; YAML indentation is a multiple of two spaces. The structural validators
remain the linters for these formats (R-12 recorded as such). The development environment
configuration records this so health reports R-09 as met by a recorded convention rather than
unmet.

## Consequences

- R-09 is met for every format in the repository: PowerShell and Go by their formatters, the
  rest by the convention check. `.gitattributes` fixes LF at the repository level so the check
  does not fight the checkout.
- A contributor's editor does the formatting; the check only refuses what does not conform, and
  says which file and line.
- If a Go-native formatter for YAML or Markdown becomes worth its dependency, a new record
  supersedes this one.

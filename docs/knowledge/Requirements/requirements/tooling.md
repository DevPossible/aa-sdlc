# F-066 Tooling requirements

| Feature | F-066 |
| --- | --- |
| Name | Tooling requirements |
| Tags | @requirements @health @tooling @T-01 |
| File | tooling |

What the project must supply. The framework names the category and the project, or a
tech-stack plugin, supplies the tool. /aa-fw-health detects presence; it never recommends a brand.

## Background

| Step | Text |
| --- | --- |
| Given | I am in a repository initialised with "aa init" |

## F-066-01 Every language has a formatter

| Scenario | F-066-01 |
| --- | --- |
| Name | Every language has a formatter |
| Kind | Scenario |
| Tags | @R-09 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | for each language detected in the project a formatter configuration or format script exists |
| And | each one runs on a list of files |
| When | "/aa-fw-health" probes R-09 |
| Then | R-09 is reported as met |

## F-066-02 A language has no formatter

| Scenario | F-066-02 |
| --- | --- |
| Name | A language has no formatter |
| Kind | Scenario |
| Tags | @R-09 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a language detected in the project has no formatter configuration or format script |
| When | "/aa-fw-health" probes R-09 |
| Then | R-09 is reported as unmet |
| And | the report names the language |
| And | the report names guidance G-01 as depending on it |
| And | the remedy is for the user or a tech-stack plugin to supply one |

## F-066-03 A root initialize script exists

| Scenario | F-066-03 |
| --- | --- |
| Name | A root initialize script exists |
| Kind | Scenario |
| Tags | @R-19 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an "initialize" script exists at the repository root |
| And | it completes on a fresh clone |
| When | "/aa-fw-health" probes R-19 |
| Then | R-19 is reported as met |

## F-066-04 No root initialize script exists

| Scenario | F-066-04 |
| --- | --- |
| Name | No root initialize script exists |
| Kind | Scenario |
| Tags | @R-19 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no "initialize" script exists at the repository root |
| When | "/aa-fw-health" probes R-19 |
| Then | R-19 is reported as unmet |
| And | the remedy is for "aa init" to create a stub that names what it must do |

## F-066-05 A root build script exists

| Scenario | F-066-05 |
| --- | --- |
| Name | A root build script exists |
| Kind | Scenario |
| Tags | @R-10 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a "build" script exists at the repository root |
| And | it completes |
| When | "/aa-fw-health" probes R-10 |
| Then | R-10 is reported as met |

## F-066-06 No root build script exists

| Scenario | F-066-06 |
| --- | --- |
| Name | No root build script exists |
| Kind | Scenario |
| Tags | @R-10 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no "build" script exists at the repository root |
| When | "/aa-fw-health" probes R-10 |
| Then | R-10 is reported as unmet |
| And | the report names guidance G-04 as depending on it |
| And | the remedy is for "aa init" to create a stub |

## F-066-07 A root test script exists and filters by tier

| Scenario | F-066-07 |
| --- | --- |
| Name | A root test script exists and filters by tier |
| Kind | Scenario |
| Tags | @R-11 @required @O-06 @O-07 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a "test" script exists at the repository root |
| And | it runs, even if it runs zero tests |
| And | it accepts a tier parameter for unit, integration, and end-to-end |
| When | "/aa-fw-health" probes R-11 |
| Then | R-11 is reported as met |

## F-066-08 No root test script exists

| Scenario | F-066-08 |
| --- | --- |
| Name | No root test script exists |
| Kind | Scenario |
| Tags | @R-11 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no "test" script exists at the repository root |
| When | "/aa-fw-health" probes R-11 |
| Then | R-11 is reported as unmet |
| And | the report names every Testing step as depending on it |
| And | the remedy is for "aa init" to create a stub |

## F-066-09 The root test script cannot select a tier

| Scenario | F-066-09 |
| --- | --- |
| Name | The root test script cannot select a tier |
| Kind | Scenario |
| Tags | @R-11 @required @O-07 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a "test" script exists at the repository root |
| And | it has no way to run one tier alone |
| When | "/aa-fw-health" probes R-11 |
| Then | R-11 is reported as unmet |
| And | the report says the script must accept a tier parameter |

## F-066-10 A root pack script exists

| Scenario | F-066-10 |
| --- | --- |
| Name | A root pack script exists |
| Kind | Scenario |
| Tags | @R-20 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a "pack" script exists at the repository root |
| And | it completes after "build" and "test" |
| When | "/aa-fw-health" probes R-20 |
| Then | R-20 is reported as met |

## F-066-11 No root pack script exists

| Scenario | F-066-11 |
| --- | --- |
| Name | No root pack script exists |
| Kind | Scenario |
| Tags | @R-20 @required @O-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no "pack" script exists at the repository root |
| When | "/aa-fw-health" probes R-20 |
| Then | R-20 is reported as unmet |
| And | the report names the release step as depending on it |

## F-066-12 All three test tiers have a home

| Scenario | F-066-12 |
| --- | --- |
| Name | All three test tiers have a home |
| Kind | Scenario |
| Tags | @R-21 @required @O-07 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | unit tests exist with each project |
| And | the tests folder has a home for integration tests and for end-to-end tests |
| And | the "test" script can run each tier alone |
| When | "/aa-fw-health" probes R-21 |
| Then | R-21 is reported as met |

## F-066-13 A test tier is absent

| Scenario | F-066-13 |
| --- | --- |
| Name | A test tier is absent |
| Kind | Scenario |
| Tags | @R-21 @required @O-07 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a tier has no home in the repository |
| When | "/aa-fw-health" probes R-21 |
| Then | R-21 is reported as unmet |
| And | the report names the missing tier |
| And | the report says a tier may be nearly empty but may not be absent |
| And | the remedy is for "aa init" to create its home |

## F-066-14 Every pipeline step calls a script in the repository

| Scenario | F-066-14 |
| --- | --- |
| Name | Every pipeline step calls a script in the repository |
| Kind | Scenario |
| Tags | @R-24 @required @O-11 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a pipeline configuration exists in the repository |
| And | every stage in it calls a root script or a command committed to the repository |
| And | no stage contains logic of its own beyond the call |
| And | each called script runs on a clean clone |
| When | "/aa-fw-health" probes R-24 |
| Then | R-24 is reported as met |

## F-066-15 A pipeline step holds logic of its own

| Scenario | F-066-15 |
| --- | --- |
| Name | A pipeline step holds logic of its own |
| Kind | Scenario |
| Tags | @R-24 @required @O-11 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stage in the pipeline configuration contains logic that exists nowhere else in the repository |
| When | "/aa-fw-health" probes R-24 |
| Then | R-24 is reported as unmet |
| And | the report names the stage |
| And | the report says a failure in that stage can only be debugged by pushing and waiting |
| And | the remedy is for the user to move the logic into a script and call it from the stage |

## F-066-16 A pipeline step calls a script that does not run locally

| Scenario | F-066-16 |
| --- | --- |
| Name | A pipeline step calls a script that does not run locally |
| Kind | Scenario |
| Tags | @R-24 @required @O-11 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stage calls a script that depends on a tool or state present only on the pipeline runner |
| When | "/aa-fw-health" probes R-24 |
| Then | R-24 is reported as unmet |
| And | the report names the script and what it depends on |
| And | the remedy is for the user to supply a local equivalent or record the step as pipeline-only with a local stand-in |

## F-066-17 Every language has a static analyser with a committed rule set

| Scenario | F-066-17 |
| --- | --- |
| Name | Every language has a static analyser with a committed rule set |
| Kind | Scenario |
| Tags | @R-12 @required @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | for each language detected in the project a static analyser is configured and runs |
| And | its rule set is committed to the repository |
| When | "/aa-fw-health" probes R-12 |
| Then | R-12 is reported as met |

## F-066-18 A language has no static analyser

| Scenario | F-066-18 |
| --- | --- |
| Name | A language has no static analyser |
| Kind | Scenario |
| Tags | @R-12 @required @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a language detected in the project has no static analyser configured |
| When | "/aa-fw-health" probes R-12 |
| Then | R-12 is reported as unmet |
| And | the report names the language |
| And | the remedy is "/aa-dev-setup-environment", which helps choose the analyser and its rule set |

## F-066-19 An analyser runs with no committed rule set

| Scenario | F-066-19 |
| --- | --- |
| Name | An analyser runs with no committed rule set |
| Kind | Scenario |
| Tags | @R-12 @required @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a language has a static analyser that runs only with its built-in defaults |
| When | "/aa-fw-health" probes R-12 |
| Then | R-12 is reported as unmet |
| And | the report says the project's conventions are not written down as a rule set |

## F-066-20 The root build runs the formatter check and the linters

| Scenario | F-066-20 |
| --- | --- |
| Name | The root build runs the formatter check and the linters |
| Kind | Scenario |
| Tags | @R-35 @recommended @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the "build" script accepts a lint switch or a "lint" script exists at the root |
| And | it runs the formatter in check mode and each configured linter |
| And | it exits non-zero on a seeded violation |
| And | the pipeline's lint stage calls it |
| When | "/aa-fw-health" probes R-35 |
| Then | R-35 is reported as met |

## F-066-21 There is no root way to lint

| Scenario | F-066-21 |
| --- | --- |
| Name | There is no root way to lint |
| Kind | Scenario |
| Tags | @R-35 @recommended @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | neither a lint switch on "build" nor a root "lint" script exists |
| When | "/aa-fw-health" probes R-35 |
| Then | R-35 is reported as unmet |
| And | the report says conventions are not being enforced by a tool |
| And | the remedy is for "aa init" to add a lint stub to "build" |

## F-066-22 A language has no known static analyser

| Scenario | F-066-22 |
| --- | --- |
| Name | A language has no known static analyser |
| Kind | Scenario |
| Tags | @R-35 @recommended @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a language in the project has no static analyser configured |
| And | the development environment configuration records that none is known for it |
| When | "/aa-fw-health" probes R-12 and R-35 |
| Then | R-12 is reported as not applicable for that language, citing the development environment configuration |
| And | R-35 is reported as met for the languages that do have one |
| And | nothing blocks |

## F-066-23 Each ecosystem has a package manager and a consistent lock file

| Scenario | F-066-23 |
| --- | --- |
| Name | Each ecosystem has a package manager and a consistent lock file |
| Kind | Scenario |
| Tags | @R-36 @required @O-22 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | for each ecosystem detected in the project the package manager is available from the shell |
| And | the lock file is committed |
| And | the manager's consistency check passes against the manifest |
| When | "/aa-fw-health" probes R-36 |
| Then | R-36 is reported as met |

## F-066-24 The lock file disagrees with the manifest

| Scenario | F-066-24 |
| --- | --- |
| Name | The lock file disagrees with the manifest |
| Kind | Scenario |
| Tags | @R-36 @required @O-22 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a manifest names a version the committed lock file does not resolve to |
| When | "/aa-fw-health" probes R-36 |
| Then | R-36 is reported as unmet |
| And | the report names the ecosystem and says the manifest was likely edited by hand |
| And | the remedy is for the user to run the package manager to restore consistency, never to edit the lock file |

## F-066-25 The lock file is not committed

| Scenario | F-066-25 |
| --- | --- |
| Name | The lock file is not committed |
| Kind | Scenario |
| Tags | @R-36 @required @O-22 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an ecosystem's lock file is absent from the repository or ignored |
| When | "/aa-fw-health" probes R-36 |
| Then | R-36 is reported as unmet |
| And | the report says a clean install cannot reproduce the tested dependency tree |
| And | the remedy is for the user to generate the lock file with the tool and commit it |

## F-066-26 No package manager is available

| Scenario | F-066-26 |
| --- | --- |
| Name | No package manager is available |
| Kind | Scenario |
| Tags | @R-36 @required @O-22 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an ecosystem is detected and its package manager is not available from the shell |
| When | "/aa-fw-health" probes R-36 |
| Then | R-36 is reported as unmet |
| And | the report names the ecosystem |
| And | the remedy is for the user or a tech-stack plugin to supply the manager |

## F-066-27 Every tier is deterministic and any test runs alone

| Scenario | F-066-27 |
| --- | --- |
| Name | Every tier is deterministic and any test runs alone |
| Kind | Scenario |
| Tags | @R-37 @required @O-23 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | each test tier gives the same result when run twice, shuffled where the runner allows |
| And | the "test" script accepts a filter that runs a single test |
| And | no retry-on-failure setting exists in the test configuration |
| And | every quarantined test names a ticket |
| When | "/aa-fw-health" probes R-37 |
| Then | R-37 is reported as met |

## F-066-28 A test gives different results on two runs

| Scenario | F-066-28 |
| --- | --- |
| Name | A test gives different results on two runs |
| Kind | Scenario |
| Tags | @R-37 @required @O-23 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a test passes on one run of its tier and fails on the next with no change in between |
| When | "/aa-fw-health" probes R-37 |
| Then | R-37 is reported as unmet |
| And | the report names the test |
| And | the remedy is to fix the test or quarantine it with a ticket, never to add a retry |

## F-066-29 A retry-on-failure setting exists

| Scenario | F-066-29 |
| --- | --- |
| Name | A retry-on-failure setting exists |
| Kind | Scenario |
| Tags | @R-37 @required @O-23 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the test configuration retries failing tests |
| When | "/aa-fw-health" probes R-37 |
| Then | R-37 is reported as unmet |
| And | the report names the setting and says it hides defects (G-06) |

## F-066-30 A quarantined test has no ticket

| Scenario | F-066-30 |
| --- | --- |
| Name | A quarantined test has no ticket |
| Kind | Scenario |
| Tags | @R-37 @required @O-23 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a test is skipped or quarantined with no ticket reference |
| When | "/aa-fw-health" probes R-37 |
| Then | R-37 is reported as unmet |
| And | the report names the test |
| And | the remedy is to raise the ticket and reference it, or to fix and unquarantine the test |

## F-066-31 One build per commit, promoted through every environment

| Scenario | F-066-31 |
| --- | --- |
| Name | One build per commit, promoted through every environment |
| Kind | Scenario |
| Tags | @R-38 @required @O-24 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the pipeline has one build or pack stage per commit that emits an immutable identity |
| And | every deploy stage consumes that identity rather than building |
| And | recent deployment records for one release name the same identity in every environment |
| And | no artifact is referenced by a mutable label |
| When | "/aa-fw-health" probes R-38 |
| Then | R-38 is reported as met |

## F-066-32 A deploy stage rebuilds

| Scenario | F-066-32 |
| --- | --- |
| Name | A deploy stage rebuilds |
| Kind | Scenario |
| Tags | @R-38 @required @O-24 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a deploy stage for a later environment runs a build rather than consuming the identity |
| When | "/aa-fw-health" probes R-38 |
| Then | R-38 is reported as unmet |
| And | the report names the stage and says what reaches that environment was never tested |
| And | the remedy is for "/aa-ops-setup-pipeline" to restructure the pipeline to build once and promote |

## F-066-33 Environments of one release ran different identities

| Scenario | F-066-33 |
| --- | --- |
| Name | Environments of one release ran different identities |
| Kind | Scenario |
| Tags | @R-38 @required @O-24 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | deployment records for one release name different identities in two environments |
| When | "/aa-fw-health" probes R-38 |
| Then | R-38 is reported as unmet |
| And | the report lists the release and the identities |

## F-066-34 An artifact is referenced by a mutable label

| Scenario | F-066-34 |
| --- | --- |
| Name | An artifact is referenced by a mutable label |
| Kind | Scenario |
| Tags | @R-38 @required @O-24 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a deploy stage references an artifact by a label that can move, such as "latest" |
| When | "/aa-fw-health" probes R-38 |
| Then | R-38 is reported as unmet |
| And | the report names the stage and the label |
| And | the remedy is to reference the artifact by its digest or never-reused version |

## F-066-35 Feature files can be executed

| Scenario | F-066-35 |
| --- | --- |
| Name | Feature files can be executed |
| Kind | Scenario |
| Tags | @R-17 @recommended @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a tool that can execute the project's feature files exists and runs |
| When | "/aa-fw-health" probes R-17 |
| Then | R-17 is reported as met |

## F-066-36 Feature files cannot be executed

| Scenario | F-066-36 |
| --- | --- |
| Name | Feature files cannot be executed |
| Kind | Scenario |
| Tags | @R-17 @recommended @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no tool that can execute feature files exists in the project |
| When | "/aa-fw-health" probes R-17 |
| Then | R-17 is reported as unmet |
| And | the report says feature files remain the source of truth but are not yet executable tests |
| And | the remedy is for the user or a tech-stack plugin to supply one |

## F-066-37 The feature-file check runs before a commit and in the pipeline

| Scenario | F-066-37 |
| --- | --- |
| Name | The feature-file check runs before a commit and in the pipeline |
| Kind | Scenario |
| Tags | @R-47 @recommended @T-12 @O-11 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the repository's pre-commit hook runs the feature-file check |
| And | the root build script runs it with its lint switch |
| When | "/aa-fw-health" probes R-47 |
| Then | R-47 is reported as met |

## F-066-38 The feature-file check does not run

| Scenario | F-066-38 |
| --- | --- |
| Name | The feature-file check does not run |
| Kind | Scenario |
| Tags | @R-47 @recommended @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no pre-commit hook or build step runs the feature-file check |
| When | "/aa-fw-health" probes R-47 |
| Then | R-47 is reported as unmet |
| And | the remedy is "aa init", which writes the hook, and "/aa-dev-setup-environment", which adds the check to the build script |

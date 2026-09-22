@requirements @tooling @T-01
Feature: Tooling requirements
  What the project must supply. The framework names the category and the project, or a
  tech-stack plugin, supplies the tool. /aa-fw-health detects presence; it never recommends a brand.

  Background:
    Given I am in a repository initialised with "aa init"

  @R-09 @required
  Scenario: Every language has a formatter
    Given for each language detected in the project a formatter configuration or format script exists
    And each one runs on a list of files
    When "/aa-fw-health" probes R-09
    Then R-09 is reported as met

  @R-09 @required
  Scenario: A language has no formatter
    Given a language detected in the project has no formatter configuration or format script
    When "/aa-fw-health" probes R-09
    Then R-09 is reported as unmet
    And the report names the language
    And the report names guidance G-01 as depending on it
    And the remedy is for the user or a tech-stack plugin to supply one

  @R-19 @required @O-06
  Scenario: A root initialize script exists
    Given an "initialize" script exists at the repository root
    And it completes on a fresh clone
    When "/aa-fw-health" probes R-19
    Then R-19 is reported as met

  @R-19 @required @O-06
  Scenario: No root initialize script exists
    Given no "initialize" script exists at the repository root
    When "/aa-fw-health" probes R-19
    Then R-19 is reported as unmet
    And the remedy is for "aa init" to create a stub that names what it must do

  @R-10 @required @O-06
  Scenario: A root build script exists
    Given a "build" script exists at the repository root
    And it completes
    When "/aa-fw-health" probes R-10
    Then R-10 is reported as met

  @R-10 @required @O-06
  Scenario: No root build script exists
    Given no "build" script exists at the repository root
    When "/aa-fw-health" probes R-10
    Then R-10 is reported as unmet
    And the report names guidance G-04 as depending on it
    And the remedy is for "aa init" to create a stub

  @R-11 @required @O-06 @O-07
  Scenario: A root test script exists and filters by tier
    Given a "test" script exists at the repository root
    And it runs, even if it runs zero tests
    And it accepts a tier parameter for unit, integration, and end-to-end
    When "/aa-fw-health" probes R-11
    Then R-11 is reported as met

  @R-11 @required @O-06
  Scenario: No root test script exists
    Given no "test" script exists at the repository root
    When "/aa-fw-health" probes R-11
    Then R-11 is reported as unmet
    And the report names every Testing step as depending on it
    And the remedy is for "aa init" to create a stub

  @R-11 @required @O-07
  Scenario: The root test script cannot select a tier
    Given a "test" script exists at the repository root
    And it has no way to run one tier alone
    When "/aa-fw-health" probes R-11
    Then R-11 is reported as unmet
    And the report says the script must accept a tier parameter

  @R-20 @required @O-06
  Scenario: A root pack script exists
    Given a "pack" script exists at the repository root
    And it completes after "build" and "test"
    When "/aa-fw-health" probes R-20
    Then R-20 is reported as met

  @R-20 @required @O-06
  Scenario: No root pack script exists
    Given no "pack" script exists at the repository root
    When "/aa-fw-health" probes R-20
    Then R-20 is reported as unmet
    And the report names the release step as depending on it

  @R-21 @required @O-07
  Scenario: All three test tiers have a home
    Given unit tests exist with each project
    And the tests folder has a home for integration tests and for end-to-end tests
    And the "test" script can run each tier alone
    When "/aa-fw-health" probes R-21
    Then R-21 is reported as met

  @R-21 @required @O-07
  Scenario: A test tier is absent
    Given a tier has no home in the repository
    When "/aa-fw-health" probes R-21
    Then R-21 is reported as unmet
    And the report names the missing tier
    And the report says a tier may be nearly empty but may not be absent
    And the remedy is for "aa init" to create its home

  @R-24 @required @O-11
  Scenario: Every pipeline step calls a script in the repository
    Given a pipeline configuration exists in the repository
    And every stage in it calls a root script or a command committed to the repository
    And no stage contains logic of its own beyond the call
    And each called script runs on a clean clone
    When "/aa-fw-health" probes R-24
    Then R-24 is reported as met

  @R-24 @required @O-11
  Scenario: A pipeline step holds logic of its own
    Given a stage in the pipeline configuration contains logic that exists nowhere else in the repository
    When "/aa-fw-health" probes R-24
    Then R-24 is reported as unmet
    And the report names the stage
    And the report says a failure in that stage can only be debugged by pushing and waiting
    And the remedy is for the user to move the logic into a script and call it from the stage

  @R-24 @required @O-11
  Scenario: A pipeline step calls a script that does not run locally
    Given a stage calls a script that depends on a tool or state present only on the pipeline runner
    When "/aa-fw-health" probes R-24
    Then R-24 is reported as unmet
    And the report names the script and what it depends on
    And the remedy is for the user to supply a local equivalent or record the step as pipeline-only with a local stand-in

  @R-12 @recommended
  Scenario: Every language has a linter
    Given for each language detected in the project a linter configuration exists and runs
    When "/aa-fw-health" probes R-12
    Then R-12 is reported as met

  @R-12 @recommended
  Scenario: A language has no linter
    Given a language detected in the project has no linter configuration
    When "/aa-fw-health" probes R-12
    Then R-12 is reported as unmet
    And the report names the language

  @R-35 @recommended @O-21
  Scenario: The root build runs the formatter check and the linters
    Given the "build" script accepts a lint switch or a "lint" script exists at the root
    And it runs the formatter in check mode and each configured linter
    And it exits non-zero on a seeded violation
    And the pipeline's lint stage calls it
    When "/aa-fw-health" probes R-35
    Then R-35 is reported as met

  @R-35 @recommended @O-21
  Scenario: There is no root way to lint
    Given neither a lint switch on "build" nor a root "lint" script exists
    When "/aa-fw-health" probes R-35
    Then R-35 is reported as unmet
    And the report says conventions are not being enforced by a tool
    And the remedy is for "aa init" to add a lint stub to "build"

  @R-35 @recommended @O-21
  Scenario: A language has no known linter
    Given a language in the project has no linter configured
    And the development environment configuration records that none is known for it
    When "/aa-fw-health" probes R-12 and R-35
    Then R-12 is reported as unmet with a warning naming the language
    And R-35 is reported as met for the languages that do have one
    And nothing blocks

  @R-36 @required @O-22
  Scenario: Each ecosystem has a package manager and a consistent lock file
    Given for each ecosystem detected in the project the package manager is available from the shell
    And the lock file is committed
    And the manager's consistency check passes against the manifest
    When "/aa-fw-health" probes R-36
    Then R-36 is reported as met

  @R-36 @required @O-22
  Scenario: The lock file disagrees with the manifest
    Given a manifest names a version the committed lock file does not resolve to
    When "/aa-fw-health" probes R-36
    Then R-36 is reported as unmet
    And the report names the ecosystem and says the manifest was likely edited by hand
    And the remedy is for the user to run the package manager to restore consistency, never to edit the lock file

  @R-36 @required @O-22
  Scenario: The lock file is not committed
    Given an ecosystem's lock file is absent from the repository or ignored
    When "/aa-fw-health" probes R-36
    Then R-36 is reported as unmet
    And the report says a clean install cannot reproduce the tested dependency tree
    And the remedy is for the user to generate the lock file with the tool and commit it

  @R-36 @required @O-22
  Scenario: No package manager is available
    Given an ecosystem is detected and its package manager is not available from the shell
    When "/aa-fw-health" probes R-36
    Then R-36 is reported as unmet
    And the report names the ecosystem
    And the remedy is for the user or a tech-stack plugin to supply the manager

  @R-37 @required @O-23
  Scenario: Every tier is deterministic and any test runs alone
    Given each test tier gives the same result when run twice, shuffled where the runner allows
    And the "test" script accepts a filter that runs a single test
    And no retry-on-failure setting exists in the test configuration
    And every quarantined test names a ticket
    When "/aa-fw-health" probes R-37
    Then R-37 is reported as met

  @R-37 @required @O-23
  Scenario: A test gives different results on two runs
    Given a test passes on one run of its tier and fails on the next with no change in between
    When "/aa-fw-health" probes R-37
    Then R-37 is reported as unmet
    And the report names the test
    And the remedy is to fix the test or quarantine it with a ticket, never to add a retry

  @R-37 @required @O-23
  Scenario: A retry-on-failure setting exists
    Given the test configuration retries failing tests
    When "/aa-fw-health" probes R-37
    Then R-37 is reported as unmet
    And the report names the setting and says it hides defects (G-06)

  @R-37 @required @O-23
  Scenario: A quarantined test has no ticket
    Given a test is skipped or quarantined with no ticket reference
    When "/aa-fw-health" probes R-37
    Then R-37 is reported as unmet
    And the report names the test
    And the remedy is to raise the ticket and reference it, or to fix and unquarantine the test

  @R-38 @required @O-24
  Scenario: One build per commit, promoted through every environment
    Given the pipeline has one build or pack stage per commit that emits an immutable identity
    And every deploy stage consumes that identity rather than building
    And recent deployment records for one release name the same identity in every environment
    And no artifact is referenced by a mutable label
    When "/aa-fw-health" probes R-38
    Then R-38 is reported as met

  @R-38 @required @O-24
  Scenario: A deploy stage rebuilds
    Given a deploy stage for a later environment runs a build rather than consuming the identity
    When "/aa-fw-health" probes R-38
    Then R-38 is reported as unmet
    And the report names the stage and says what reaches that environment was never tested
    And the remedy is for "/aa-ops-setup-pipeline" to restructure the pipeline to build once and promote

  @R-38 @required @O-24
  Scenario: Environments of one release ran different identities
    Given deployment records for one release name different identities in two environments
    When "/aa-fw-health" probes R-38
    Then R-38 is reported as unmet
    And the report lists the release and the identities

  @R-38 @required @O-24
  Scenario: An artifact is referenced by a mutable label
    Given a deploy stage references an artifact by a label that can move, such as "latest"
    When "/aa-fw-health" probes R-38
    Then R-38 is reported as unmet
    And the report names the stage and the label
    And the remedy is to reference the artifact by its digest or never-reused version

  @R-17 @recommended @T-12
  Scenario: Feature files can be executed
    Given a tool that can execute the project's feature files exists and runs
    When "/aa-fw-health" probes R-17
    Then R-17 is reported as met

  @R-17 @recommended @T-12
  Scenario: Feature files cannot be executed
    Given no tool that can execute feature files exists in the project
    When "/aa-fw-health" probes R-17
    Then R-17 is reported as unmet
    And the report says feature files remain the source of truth but are not yet executable tests
    And the remedy is for the user or a tech-stack plugin to supply one

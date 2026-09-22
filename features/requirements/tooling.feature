@requirements @tooling @T-01
Feature: Tooling requirements
  What the project must supply. The framework names the category and the project, or a
  tech-stack plugin, supplies the tool. /aa-health detects presence; it never recommends a brand.

  Background:
    Given I am in a repository initialised with "aa init"

  @R-09 @required
  Scenario: Every language has a formatter
    Given for each language detected in the project a formatter configuration or format script exists
    And each one runs on a list of files
    When "/aa-health" probes R-09
    Then R-09 is reported as met

  @R-09 @required
  Scenario: A language has no formatter
    Given a language detected in the project has no formatter configuration or format script
    When "/aa-health" probes R-09
    Then R-09 is reported as unmet
    And the report names the language
    And the report names guidance G-01 as depending on it
    And the remedy is for the user or a tech-stack plugin to supply one

  @R-19 @required @O-06
  Scenario: A root initialize script exists
    Given an "initialize" script exists at the repository root
    And it completes on a fresh clone
    When "/aa-health" probes R-19
    Then R-19 is reported as met

  @R-19 @required @O-06
  Scenario: No root initialize script exists
    Given no "initialize" script exists at the repository root
    When "/aa-health" probes R-19
    Then R-19 is reported as unmet
    And the remedy is for "aa init" to create a stub that names what it must do

  @R-10 @required @O-06
  Scenario: A root build script exists
    Given a "build" script exists at the repository root
    And it completes
    When "/aa-health" probes R-10
    Then R-10 is reported as met

  @R-10 @required @O-06
  Scenario: No root build script exists
    Given no "build" script exists at the repository root
    When "/aa-health" probes R-10
    Then R-10 is reported as unmet
    And the report names guidance G-04 as depending on it
    And the remedy is for "aa init" to create a stub

  @R-11 @required @O-06 @O-07
  Scenario: A root test script exists and filters by tier
    Given a "test" script exists at the repository root
    And it runs, even if it runs zero tests
    And it accepts a tier parameter for unit, integration, and end-to-end
    When "/aa-health" probes R-11
    Then R-11 is reported as met

  @R-11 @required @O-06
  Scenario: No root test script exists
    Given no "test" script exists at the repository root
    When "/aa-health" probes R-11
    Then R-11 is reported as unmet
    And the report names every Testing step as depending on it
    And the remedy is for "aa init" to create a stub

  @R-11 @required @O-07
  Scenario: The root test script cannot select a tier
    Given a "test" script exists at the repository root
    And it has no way to run one tier alone
    When "/aa-health" probes R-11
    Then R-11 is reported as unmet
    And the report says the script must accept a tier parameter

  @R-20 @required @O-06
  Scenario: A root pack script exists
    Given a "pack" script exists at the repository root
    And it completes after "build" and "test"
    When "/aa-health" probes R-20
    Then R-20 is reported as met

  @R-20 @required @O-06
  Scenario: No root pack script exists
    Given no "pack" script exists at the repository root
    When "/aa-health" probes R-20
    Then R-20 is reported as unmet
    And the report names the release step as depending on it

  @R-21 @required @O-07
  Scenario: All three test tiers have a home
    Given unit tests exist with each project
    And the tests folder has a home for integration tests and for end-to-end tests
    And the "test" script can run each tier alone
    When "/aa-health" probes R-21
    Then R-21 is reported as met

  @R-21 @required @O-07
  Scenario: A test tier is absent
    Given a tier has no home in the repository
    When "/aa-health" probes R-21
    Then R-21 is reported as unmet
    And the report names the missing tier
    And the report says a tier may be nearly empty but may not be absent
    And the remedy is for "aa init" to create its home

  @R-12 @recommended
  Scenario: Every language has a linter
    Given for each language detected in the project a linter configuration exists and runs
    When "/aa-health" probes R-12
    Then R-12 is reported as met

  @R-12 @recommended
  Scenario: A language has no linter
    Given a language detected in the project has no linter configuration
    When "/aa-health" probes R-12
    Then R-12 is reported as unmet
    And the report names the language

  @R-17 @recommended @T-12
  Scenario: Feature files can be executed
    Given a tool that can execute the project's feature files exists and runs
    When "/aa-health" probes R-17
    Then R-17 is reported as met

  @R-17 @recommended @T-12
  Scenario: Feature files cannot be executed
    Given no tool that can execute feature files exists in the project
    When "/aa-health" probes R-17
    Then R-17 is reported as unmet
    And the report says feature files remain the source of truth but are not yet executable tests
    And the remedy is for the user or a tech-stack plugin to supply one

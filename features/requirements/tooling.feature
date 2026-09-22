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

  @R-10 @required
  Scenario: A single build command exists
    Given a build script or build configuration exists at the project root
    And it completes
    When "/aa-health" probes R-10
    Then R-10 is reported as met

  @R-10 @required
  Scenario: No build command exists
    Given no build script or build configuration exists at the project root
    When "/aa-health" probes R-10
    Then R-10 is reported as unmet
    And the report names guidance G-04 as depending on it

  @R-11 @required
  Scenario: A single test command exists
    Given a test script or test configuration exists
    And it runs, even if it runs zero tests
    When "/aa-health" probes R-11
    Then R-11 is reported as met

  @R-11 @required
  Scenario: No test command exists
    Given no test script or test configuration exists
    When "/aa-health" probes R-11
    Then R-11 is reported as unmet
    And the report names every Testing step as depending on it

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

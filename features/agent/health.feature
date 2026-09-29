# Generated from the knowledge base page Requirements/agent/health. Do not edit: change the page, then pull it.
# Checksum: sha256:7afdad806b1f9679adcffea5f57a38ee499aa8fa04a28acebc543fe5aeeca8f1
@agent @T-10 @T-11 @F-001
Feature: /aa-fw-health reports every declared requirement
  The single place the framework's expectations are enumerated and checked. Agent-only, because
  the probes that matter most can only be performed by the agent. It reports and never blocks.

  Background:
    Given the skills and commands are installed in the agent

  @F-001-01
  Scenario: Aggregate requirements from what is installed
    When I run "/aa-fw-health"
    Then it collects the requirements declared by every installed skill, plugin, and process
    And it does not depend on the requirements registry document

  @F-001-02
  Scenario: Probe and report each requirement
    When I run "/aa-fw-health"
    Then each requirement is reported as met, unmet, or not applicable
    And each unmet requirement lists what depends on it and its remedy

  @F-001-03
  Scenario: Report the install
    When I run "/aa-fw-health"
    Then it reports the scope, version, and target
    And it lists the skills and commands present
    And it says whether a newer package version exists

  @F-001-04
  Scenario: Report the current project when one is in scope
    Given I am in a repository initialised with "aa init"
    When I run "/aa-fw-health"
    Then it reports whether the project is under source control with a remote
    And it reports whether the project config, documents folder, and features folder exist
    And it reports which requirements the project's tooling satisfies

  @F-001-05
  Scenario: Report what only the agent can know
    When I run "/aa-fw-health"
    Then it reports whether it can reach a ticket system, a knowledge base, and source control
    And it names how it reaches each one: a CLI, an MCP server, or a connector
    And it reports which technologies in the project's stack have a skill in its scope

  @F-001-06
  Scenario: Report which practices are guidance-only here
    Given the target does not support hooks
    When I run "/aa-fw-health"
    Then it lists the guidance that would be enforced on a target with hooks
    And it says that here it is guided only

  @F-001-07
  Scenario: Never block or change anything
    Given a required requirement is unmet
    When I run "/aa-fw-health"
    Then it still completes and reports
    And it changes no file, ticket, or page

  @F-001-08
  Scenario: Run outside a project
    Given I am not in a repository
    When I run "/aa-fw-health"
    Then it reports the install and the environment
    And project requirements are reported as not applicable

  @O-01 @T-12 @F-001-09
  Scenario: Probes come from the requirement feature files
    Given the package carries the requirement feature files under requirements/
    When "/aa-fw-health" resolves a declared id
    Then the scenario tag gives the level and the feature file gives the kind
    And the Given steps of the met scenario are what it performs as the probe
    And the remedy lines of the unmet scenarios are what it reports as the remedy
    And an id with no scenario is reported as undefined, never guessed

  @F-001-10
  Scenario: A recorded exception is not applicable, not unmet
    Given the development environment configuration records that a requirement does not apply and why
    When "/aa-fw-health" probes that requirement
    Then it is reported as not applicable with that reason
    And it does not appear under required and unmet

  @F-001-11
  Scenario: Every row says how it was probed
    When "/aa-fw-health" reports
    Then each requirement row names the command run, the ticket read, or the file opened
    And a requirement whose probe could not complete is unmet with the reason, never skipped

  @O-26 @R-43 @F-001-12
  Scenario: The ticket project's configuration is probed, not only its names
    Given the project config maps the ticket kinds and states
    When "/aa-fw-health" probes the ticket system
    Then it reads the project's workflow, its moves, its parent links, and its board
    And a mapping whose names all exist but whose workflow cannot carry the life cycle is unmet

  @R-44 @R-45 @F-001-13
  Scenario: The project's tools are probed on this machine
    Given the project config lists tools with check commands
    When "/aa-fw-health" probes R-44 and R-45
    Then it reports each prescribed category with the tool chosen for it, or the gap
    And it runs each check command and reports the version found against the version required

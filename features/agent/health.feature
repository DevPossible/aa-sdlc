@agent @T-10 @T-11
Feature: /aa-health reports every declared requirement
  The single place the framework's expectations are enumerated and checked. Agent-only, because
  the probes that matter most can only be performed by the agent. It reports and never blocks.

  Background:
    Given the skills and commands are installed in the agent

  Scenario: Aggregate requirements from what is installed
    When I run "/aa-health"
    Then it collects the requirements declared by every installed skill, plugin, and process
    And it does not depend on the requirements registry document

  Scenario: Probe and report each requirement
    When I run "/aa-health"
    Then each requirement is reported as met, unmet, or not applicable
    And each unmet requirement lists what depends on it and its remedy

  Scenario: Report the install
    When I run "/aa-health"
    Then it reports the scope, version, and target
    And it lists the skills and commands present
    And it says whether a newer package version exists

  Scenario: Report the current project when one is in scope
    Given I am in a repository initialised with "aa init"
    When I run "/aa-health"
    Then it reports whether the project is under source control with a remote
    And it reports whether the project config, documents folder, and features folder exist
    And it reports which requirements the project's tooling satisfies

  Scenario: Report what only the agent can know
    When I run "/aa-health"
    Then it reports whether it can reach a ticket system, a knowledge base, and source control
    And it names how it reaches each one: a CLI, an MCP server, or a connector
    And it reports which technologies in the project's stack have a skill in its scope

  Scenario: Report which practices are guidance-only here
    Given the target does not support hooks
    When I run "/aa-health"
    Then it lists the guidance that would be enforced on a target with hooks
    And it says that here it is guided only

  Scenario: Never block or change anything
    Given a required requirement is unmet
    When I run "/aa-health"
    Then it still completes and reports
    And it changes no file, ticket, or page

  Scenario: Run outside a project
    Given I am not in a repository
    When I run "/aa-health"
    Then it reports the install and the environment
    And project requirements are reported as not applicable

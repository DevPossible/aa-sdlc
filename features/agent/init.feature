@agent @T-06 @T-11
Feature: /aa-fw-init bootstraps what needs judgement
  aa init on the CLI lays down files. /aa-fw-init in the agent works through the unmet
  requirements that need a decision, with the user's consent, and reports the rest.

  Background:
    Given the skills and commands are installed in the agent
    And I am in a repository initialised with "aa init"

  Scenario: Start from health
    When I run "/aa-fw-init"
    Then it runs "/aa-fw-health" first
    And it works only on requirements reported as unmet

  Scenario: Fix what it can, with consent
    Given an unmet requirement has a remedy the agent can perform
    When I run "/aa-fw-init"
    Then it proposes the remedy
    And it performs it only after the user agrees

  Scenario: A language with no formatter
    Given the project has a language with no formatter
    When I run "/aa-fw-init"
    Then it names the language
    And it offers the options available in the project's scope, without naming a tool itself
    And it lets the user choose

  Scenario: A technology with no skill in scope
    Given the project's stack has a technology with no skill in scope
    When I run "/aa-fw-init"
    Then it names the technology
    And it lists the tech-stack plugins that would cover it
    And it lets the user choose

  Scenario: Report what it cannot fix
    Given an unmet requirement that needs the user to act outside the agent
    When I run "/aa-fw-init"
    Then it lists the requirement and the remedy
    And it does not attempt the remedy itself

  Scenario: Finish with health
    When "/aa-fw-init" completes
    Then it runs "/aa-fw-health" again
    And it reports what changed and what remains

  @O-09 @O-04 @R-22 @R-03 @T-05
  Scenario: Ask for the ticket project and knowledge base
    Given the project config names no ticket project
    When I run "/aa-fw-init"
    Then it asks which ticket project this repository belongs to and where its knowledge base is
    And it accepts a name, a key, or a URL

  @T-05
  Scenario: A connector for the named system is in scope
    Given the user answers with a system and a project URL
    And the agent has a skill, MCP server, or CLI for that system that is authorised
    When "/aa-fw-init" continues
    Then it confirms through the connector that the project exists
    And it records the project key and URL in the project config
    And it does not name any system the user did not name

  @T-05 @T-10
  Scenario: A connector is present but not authorised for the site
    Given the user answers with a system and a project URL
    And the agent has a connector for that system that is not authorised for that site
    When "/aa-fw-init" continues
    Then it says the connector was found and is not authorised for the site
    And it records the mapping in the project config anyway
    And it says health will report R-02 or R-03 unmet until the connector is authorised

  @T-05 @T-10
  Scenario: No connector for the named system is in scope
    Given the user answers with a system and a project URL
    And the agent has nothing in scope for that system
    When "/aa-fw-init" continues
    Then it says nothing in scope reaches that system
    And it records the mapping in the project config anyway
    And the remedy is for the user to install or authorise a connector

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

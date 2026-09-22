@framework @agent @T-12 @O-01
Feature: Gherkin is the source of truth for requirements
  Every project using the framework, and the framework itself, keeps its requirements as feature
  files in the repository. Each feature is linked to its ticket and its knowledge base page, and
  the tooling keeps the three aligned. The ticket system stays the truth for work state and the
  knowledge base for decisions; the feature files are the truth for what the software must do.

  Background:
    Given a project bootstrapped with "aa init"
    And the project has a features folder

  @R-16
  Scenario: A new requirement starts as a scenario
    When a requirement is captured during discover or refine-requirements
    Then it is written as a scenario in a feature file in the features folder
    And it is not considered captured until the feature file contains it

  @R-02
  Scenario: Every scenario is linked to a ticket
    Given a scenario exists in a feature file
    When the tooling next runs a step that touches requirements
    Then the scenario carries a tag naming its anchor ticket
    And the ticket links back to the feature file and scenario

  @R-03
  Scenario: Every feature is linked to a knowledge base page
    Given a feature file exists
    When the tooling next runs a step that touches requirements
    Then the feature description names its knowledge base page
    And the page carries the feature's narrative and links back to the feature file

  Scenario: Changing a scenario propagates outward
    Given a scenario, its ticket, and its knowledge base page are aligned
    When the scenario is changed in the feature file
    Then the tooling updates the ticket's acceptance criteria to match
    And the tooling updates the knowledge base page to match
    And the anchor ticket records that the requirement changed

  Scenario: A requirement changed outside the feature file is a conflict, not a change
    Given a scenario, its ticket, and its knowledge base page are aligned
    When the acceptance criteria are edited in the ticket alone
    Then the tooling reports a conflict between the ticket and the feature file
    And it does not silently rewrite either side
    And the user decides which is correct

  @R-11 @R-17
  Scenario: Feature files are the business-facing tests
    Given a project with a tool that can execute feature files
    When generate-tests runs for a ticket
    Then the scenarios for that ticket are the business-facing test cases
    And no separate acceptance criteria document is produced

  Scenario: The framework dogfoods its own rule
    Given the aa-sdlc repository
    Then its own requirements are feature files under features/
    And the requirements registry document is an index derived from them

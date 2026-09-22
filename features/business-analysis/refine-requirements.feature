@agent @business-analysis @O-01 @O-15
Feature: /aa-ba-refine-requirements turns draft scenarios into testable ones
  Close the gaps in the draft scenarios: apply stakeholder answers to the feature file first,
  split scenarios that describe two outcomes, make every step observable, tag every scenario
  with its ticket, and record the technical constraints the scenarios must live within.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with draft scenarios, a question log, and answers from stakeholders

  Scenario: An answer changes the feature file first
    Given a question in the log has been answered
    When "/aa-ba-refine-requirements" applies the answer
    Then the scenario in the feature file is changed first
    And the ticket's acceptance criteria and the page follow from the feature file
    And the ticket is not edited before the feature file

  Scenario: Two outcomes become two scenarios
    Given a scenario's Then describes two outcomes that could fail independently
    When "/aa-ba-refine-requirements" refines it
    Then it is split into two scenarios, one behaviour each

  Scenario: Every step is observable
    Given a scenario says the feature "should work correctly"
    When "/aa-ba-refine-requirements" refines it
    Then the step is replaced with concrete Given, When, Then steps a test could observe
    And a step that cannot be made observable is recorded as a question on the ticket

  Scenario: Every scenario is linked
    When "/aa-ba-refine-requirements" finishes a feature file
    Then every scenario is tagged with its ticket
    And the feature description names its knowledge base page

  Scenario: An unanswered question stays open with an owner
    Given a question in the log has no answer
    When "/aa-ba-refine-requirements" finishes
    Then the question remains on the ticket as an open question with an owner
    And no scenario is invented to close it

  Scenario: A mock-up offered as an answer is evidence
    Given a stakeholder answered a question with a mock-up
    When "/aa-ba-refine-requirements" applies it
    Then it writes the scenario the mock-up implies
    And what the mock-up does not show is logged as a question

  Scenario: The technical constraints are recorded with their sources
    Given Technical Analysis and Security have stated constraints
    When "/aa-ba-refine-requirements" records them
    Then a technical constraints document in the knowledge base lists each constraint with its source
    And the document is linked from the epic
    And a constraint that contradicts a scenario is a question on the ticket

  Scenario: The feature files are staged and presented, never committed
    When "/aa-ba-refine-requirements" finishes
    Then the changed feature files are staged with a Conventional Commit message
    And no commit is made unless the user asked for that commit

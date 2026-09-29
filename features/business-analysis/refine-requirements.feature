# Generated from the knowledge base page Requirements/business-analysis/refine-requirements. Do not edit: change the page, then pull it.
# Checksum: sha256:e5221f95d51127906aa3c0d31367cda7c5abe3717d53e4e2dc8cad046fbeae73
@agent @business-analysis @O-01 @O-15 @F-004
Feature: /aa-ba-refine-requirements turns draft scenarios into testable ones
  Close the gaps in the Draft scenarios: apply stakeholder answers to the feature page first,
  split scenarios that describe two outcomes, make every step observable, approve what the
  stakeholder confirms and tag it with its ticket, pull the Approved scenarios into the
  repository, and record the technical constraints the scenarios must live within.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with draft scenarios, a question log, and answers from stakeholders

  @F-004-01
  Scenario: An answer changes the feature page first
    Given a question in the log has been answered
    When "/aa-ba-refine-requirements" applies the answer
    Then the scenario on its feature page is changed first
    And the ticket's acceptance criteria follow from the page
    And the ticket is not edited before the page
    And no feature file is edited

  @F-004-02
  Scenario: Two outcomes become two scenarios
    Given a scenario's Then describes two outcomes that could fail independently
    When "/aa-ba-refine-requirements" refines it
    Then it is split into two scenarios, one behaviour each

  @F-004-03
  Scenario: Every step is observable
    Given a scenario says the feature "should work correctly"
    When "/aa-ba-refine-requirements" refines it
    Then the step is replaced with concrete Given, When, Then steps a test could observe
    And a step that cannot be made observable is recorded as a question on the ticket

  @F-004-04
  Scenario: Every scenario is linked
    When "/aa-ba-refine-requirements" finishes a feature page
    Then every Approved scenario is tagged with its ticket
    And the ticket links to the feature page and the ids of its scenarios

  @F-004-05
  Scenario: An unanswered question stays open with an owner
    Given a question in the log has no answer
    When "/aa-ba-refine-requirements" finishes
    Then the question remains on the ticket as an open question with an owner
    And no scenario is invented to close it

  @F-004-06
  Scenario: A mock-up offered as an answer is evidence
    Given a stakeholder answered a question with a mock-up
    When "/aa-ba-refine-requirements" applies it
    Then it writes the scenario the mock-up implies
    And what the mock-up does not show is logged as a question

  @F-004-07
  Scenario: The technical constraints are recorded with their sources
    Given Technical Analysis and Security have stated constraints
    When "/aa-ba-refine-requirements" records them
    Then a technical constraints document in the knowledge base lists each constraint with its source
    And the document is linked from the epic
    And a constraint that contradicts a scenario is a question on the ticket

  @F-004-08
  Scenario: The changes are staged and presented, never committed
    When "/aa-ba-refine-requirements" finishes
    Then the pulled feature files, and the changed pages where they are in the documents folder, are staged with a Conventional Commit message
    And no commit is made unless the user asked for that commit

  @G-19 @G-54 @F-004-09
  Scenario: Only what the stakeholder confirmed is Approved and pulled
    Given a feature page with one scenario the stakeholder confirmed and one still in question
    When "/aa-ba-refine-requirements" finishes the page
    Then the confirmed scenario is Approved and tagged with its ticket
    And the scenario still in question stays Draft
    And the page is pulled, so only the Approved scenario reaches the features folder

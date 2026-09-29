# Generated from the knowledge base page Requirements/refinement/refine-ticket. Do not edit: change the page, then pull it.
# Checksum: sha256:7ee28fdfa5ddc737ac8a5df96e6bdb9a87e381456ddee79146639d739e7c3b22
@agent @refinement @O-10 @O-13 @T-12 @F-059
Feature: /aa-rf-refine-ticket brings one ticket to the definition of ready
  Scenarios linked and complete, acceptance criteria checkable, size grounded in implementation
  thinking, dependencies clear, questions answered or owned, and the repository revision
  recorded so the step that picks the ticket up can see what moved.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with draft scenarios and open questions

  @F-059-01
  Scenario: Scenarios are read before the description
    When "/aa-rf-refine-ticket" starts
    Then it reads the linked scenarios first
    And the acceptance criteria it records are the scenarios, not a restatement

  @F-059-02
  Scenario: A gap becomes a question, not a guess
    Given a scenario the ticket needs does not exist
    When "/aa-rf-refine-ticket" notices
    Then a question is added to the ticket for Business Analysis
    And no scenario is invented

  @F-059-03
  Scenario: A scope-changing question blocks readiness
    Given an open question would change the scope of the ticket
    When "/aa-rf-refine-ticket" assesses readiness
    Then the ticket is reported as not ready however small it looks

  @F-059-04
  Scenario: The size is grounded in thinking
    When "/aa-rf-refine-ticket" sizes the ticket
    Then the ticket first records what changes, what is unknown, and what could go wrong
    And the size cites that reasoning
    And a number requested before the thinking exists is given as a labelled range and not recorded

  @F-059-05
  Scenario: The revision is recorded
    When "/aa-rf-refine-ticket" marks the ticket ready
    Then the ticket records the repository revision its scenarios were checked against

  @F-059-06
  Scenario: Not ready is said plainly
    Given one item of the definition of ready is not met
    When "/aa-rf-refine-ticket" finishes
    Then the ticket says which item is unmet and whether it proceeds anyway

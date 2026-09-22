@agent @refinement @O-10 @O-13 @T-12
Feature: /aa-rf-refine-ticket brings one ticket to the definition of ready
  Scenarios linked and complete, acceptance criteria checkable, size grounded in implementation
  thinking, dependencies clear, questions answered or owned, and the repository revision
  recorded so the step that picks the ticket up can see what moved.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with draft scenarios and open questions

  Scenario: Scenarios are read before the description
    When "/aa-rf-refine-ticket" starts
    Then it reads the linked scenarios first
    And the acceptance criteria it records are the scenarios, not a restatement

  Scenario: A gap becomes a question, not a guess
    Given a scenario the ticket needs does not exist
    When "/aa-rf-refine-ticket" notices
    Then a question is added to the ticket for Business Analysis
    And no scenario is invented

  Scenario: A scope-changing question blocks readiness
    Given an open question would change the scope of the ticket
    When "/aa-rf-refine-ticket" assesses readiness
    Then the ticket is reported as not ready however small it looks

  Scenario: The size is grounded in thinking
    When "/aa-rf-refine-ticket" sizes the ticket
    Then the ticket first records what changes, what is unknown, and what could go wrong
    And the size cites that reasoning
    And a number requested before the thinking exists is given as a labelled range and not recorded

  Scenario: The revision is recorded
    When "/aa-rf-refine-ticket" marks the ticket ready
    Then the ticket records the repository revision its scenarios were checked against

  Scenario: Not ready is said plainly
    Given one item of the definition of ready is not met
    When "/aa-rf-refine-ticket" finishes
    Then the ticket says which item is unmet and whether it proceeds anyway

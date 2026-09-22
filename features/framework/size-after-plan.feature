@framework @O-10 @T-07
Feature: Size and estimate only after the implementation is planned
  No unit of work carries a size or an effort estimate until its implementation plan exists.
  Sizing is the last act of making a ticket ready, done from the plan and recorded with the
  plan as its basis. A number given before the plan is a guess, labelled as one and never
  recorded as the size.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose scenarios are linked and whose questions are answered
    And the ticket has no size

  @G-28
  Scenario: A ticket is sized from its plan
    When "/aa-rf-refine-ticket" runs for the ticket
    Then "/aa-ip-plan-implementation" runs before any size is recorded
    And the size is recorded on the ticket after the plan is confirmed
    And the size names the plan as its basis

  @G-28
  Scenario: A number asked for before the plan is a labelled guess
    Given the ticket has no implementation plan
    When a size or estimate is requested for it
    Then the answer is a range labelled as a guess
    And no size is recorded on the ticket
    And the ticket is not reported as ready

  @G-28
  Scenario: An iteration is not committed on a guess
    Given a ticket carries a size but no implementation plan
    When "/aa-pm-plan-iteration" considers it
    Then the ticket is reported as not ready
    And it is not committed to the iteration
    And the reason names the missing plan

  Scenario: A plan that outgrows the ticket is split, not sized larger
    Given "/aa-ip-plan-implementation" produces a plan longer than the change it describes
    When the plan is confirmed
    Then the ticket is handed back to Refinement to split
    And no size is recorded on the oversized ticket
    And each resulting ticket is planned and then sized on its own

  @R-23
  Scenario: Health reports tickets sized without a plan
    Given sized tickets in the configured project have no implementation plan
    When "/aa-fw-health" runs
    Then R-23 is reported as unmet with those tickets listed

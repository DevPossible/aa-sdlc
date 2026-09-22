@agent @project-management @O-10 @T-06 @T-13
Feature: /aa-pm-plan-iteration commits ready tickets to an iteration against computed capacity
  Commit a set of ready tickets to an iteration against known capacity, in priority order, and
  record the commitment and the risks in the ticket system. Capacity is computed from what was
  actually completed, and the commitment is a proposal until the people doing the work agree.

  Background:
    Given a project bootstrapped with "aa init"
    And an ordered backlog in the ticket system with some tickets marked ready

  Scenario: Capacity is computed from recent completions
    When "/aa-pm-plan-iteration" determines capacity
    Then the completed size of recent iterations is read from the ticket system
    And the capacity is calculated with a tool and quoted with the iterations it came from
    And a capacity figure the user supplies is recorded beside the computed one as an assumption

  Scenario: The iteration is filled in priority order and stops at capacity
    When "/aa-pm-plan-iteration" selects tickets
    Then tickets are added from the top of the ordered backlog with a running total computed with a tool
    And selection stops when the next ticket would exceed capacity
    And a lower ticket is not pulled over a higher one because it is smaller unless the higher one is blocked

  Scenario: A ticket without grounded sizing is not committed
    Given a ready ticket whose size does not cite implementation thinking
    When "/aa-pm-plan-iteration" considers it
    Then the ticket is not committed
    And the ticket records that it needs refinement before it can be committed

  Scenario: A dependency on an uncommitted ticket is resolved, not ignored
    Given a candidate ticket depends on a ticket that is not in the iteration
    When "/aa-pm-plan-iteration" selects tickets
    Then both tickets are committed or neither is
    And the iteration records which was chosen and why

  Scenario: Risks and assumptions are recorded on the iteration
    When "/aa-pm-plan-iteration" writes the plan
    Then the iteration records the capacity figures and their source
    And the iteration records carry-over with its reasons, blocked items, and any agreed overage

  Scenario: The commitment is proposed, not imposed
    When "/aa-pm-plan-iteration" has a candidate plan
    Then the committed list, the total against capacity, and the risks are presented
    And no tickets are moved into the iteration until the people doing the work agree

  Scenario: Without a ticket system the plan is produced locally
    Given no ticket system is in scope
    When "/aa-pm-plan-iteration" runs
    Then the plan is written locally and the report says so
    And the local plan is staged and presented, not committed

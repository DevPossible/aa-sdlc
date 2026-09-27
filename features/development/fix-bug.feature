@agent @development @O-23 @T-12 @F-011
Feature: /aa-dev-fix-bug reproduces a defect before fixing its cause
  Reproduce a reported defect with a failing test, find the cause, fix the cause, and prove it
  with the test now passing, on a branch that references the ticket.

  Background:
    Given a project bootstrapped with "aa init"
    And a defect ticket with symptoms, environment, and steps to reproduce

  @F-011-01
  Scenario: No reproduction, no fix
    Given the defect cannot be reproduced from the ticket
    When "/aa-dev-fix-bug" runs
    Then the ticket records what was tried
    And it goes back for more information
    And no code is changed

  @F-011-02
  Scenario: The cause is found before code is touched
    When "/aa-dev-fix-bug" investigates
    Then each hypothesis and its test are recorded on the ticket
    And after three hypotheses without evidence it stops and reassesses

  @F-011-03
  Scenario: The fix is proven by the test that reproduced it
    Given a failing test reproduces the defect
    When the fix is made
    Then the reproducing test passes
    And the full tier it lives in passes
    And no existing test was weakened, skipped, or retried

  @F-011-04
  Scenario: A defect no scenario covers gets a scenario
    Given the defect violates behaviour no scenario states
    When "/aa-dev-fix-bug" fixes it
    Then a scenario is added to the feature file with the fix

  @F-011-05
  Scenario: An intermittent test is controlled, not retried
    Given the defect is a test that fails one run in five
    When "/aa-dev-fix-bug" fixes it
    Then the source of variance among time, randomness, state, and dependencies is named and controlled
    And no retry is added

  @F-011-06
  Scenario: The fix is staged, not committed
    When the fix passes its proof
    Then it is staged with a fix-typed Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

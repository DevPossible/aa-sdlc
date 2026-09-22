@agent @testing @O-07 @O-12 @O-23
Feature: /aa-qa-e2e-tests proves through the whole system what only it can prove
  Automate the scenarios the strategy assigns to the end-to-end tier by driving the system the
  way a user does, against the system and its dependencies started in containers from the
  repository, with a visual regression suite where a user interface exists.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with scenarios assigned to the end-to-end tier and container definitions in the repository

  Scenario: The environment comes from the repository, not from a shared server
    When "/aa-qa-e2e-tests" starts the system
    Then the system and its dependencies are started in containers from the committed definitions
    And the revision under test is recorded on the ticket
    And the environment is torn down after the run

  Scenario: A dependency that cannot be containerised is marked
    Given a dependency with no container definition and no faithful stand-in
    When "/aa-qa-e2e-tests" writes a test that needs it
    Then the test is marked as depending on a shared environment
    And the reason is recorded on the ticket

  Scenario: Development's happy-path tests are extended, not repeated
    Given Development wrote a happy-path end-to-end test for a scenario
    When "/aa-qa-e2e-tests" handles that scenario
    Then it does not write the happy path again
    And it adds what the strategy assigns that the happy path does not cover

  Scenario: Tests drive the real entry points and own their data
    When "/aa-qa-e2e-tests" writes a test
    Then the test acts through the system's real entry points and not its internals
    And the test creates the data it needs and removes it afterwards
    And the test is tagged with the scenario it proves

  Scenario: The tier runs from the root test script in any order
    When "/aa-qa-e2e-tests" proves the suite
    Then the end-to-end tier runs from the root test script with the tier selected
    And each new test passes alone and the tier passes in shuffled order
    And the output is quoted

  Scenario: A flaky test is quarantined with a ticket, never retried
    Given a new test passes on one run and fails on the next
    When "/aa-qa-e2e-tests" sees this
    Then the test is quarantined with a ticket the same day
    And no retry is added around it

  Scenario: Visual baselines are versioned and reviewed when they change
    Given the system has a user interface
    When "/aa-qa-e2e-tests" builds the visual regression suite
    Then the baselines are versioned beside the tests
    And a changed baseline appears in the staged diff rather than being accepted silently

  Scenario: The suite is staged and presented, never committed
    When "/aa-qa-e2e-tests" finishes
    Then the tests, baselines, and feature file changes are staged as one change set with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit
    And the ticket records which scenarios now have end-to-end tests and what remains

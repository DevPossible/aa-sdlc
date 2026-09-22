@framework @agent @O-23 @O-07 @T-07
Feature: Tests are deterministic and independent
  Every test, at every tier, gives the same result every time, alone or with any other tests
  in any order. Time is injected or frozen, randomness is seeded or injected, state is owned
  and cleaned up by the test that needs it, and external dependencies are replaced by a
  container, a fake, or a recorded response. A flaky test is a defect, quarantined with a
  ticket and never retried into green.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with scenarios and the tests that prove them

  @G-46
  Scenario: A test controls time
    Given a scenario whose behaviour depends on the current date
    When "/aa-dev-implement" writes the test
    Then the test injects or freezes the clock
    And it passes on any day it is run

  @G-46
  Scenario: A test controls randomness
    Given code that generates an identifier or shuffles a collection
    When "/aa-dev-implement" writes the test
    Then the random source is seeded or injected
    And the expected values are fixed

  @G-46
  Scenario: A test owns its state
    Given an integration test that writes to a database
    When "/aa-qa-generate-tests" writes it
    Then the test creates the data it needs
    And it cleans up after itself, or runs in a transaction that is rolled back
    And it does not depend on rows another test left behind

  @G-46
  Scenario: A test controls its external dependencies
    Given a unit or integration test for code that calls an external service
    When the test is written
    Then the service is replaced by a container, a fake, or a recorded response
    And no live call leaves the machine

  @G-46
  Scenario: Any test runs alone, and the tier runs in any order
    Given a tier that passes as a whole
    When the root test script runs one test by itself
    And runs the tier in a shuffled order
    Then each run gives the same result as the full run

  @G-46 @G-06
  Scenario: A flaky test is quarantined, not retried
    Given a test that failed once in five runs with no code change
    When "/aa-dev-fix-bug" or "/aa-qa-e2e-tests" handles it
    Then a ticket is raised for the test the same day
    And the test is quarantined with the ticket referenced
    And no retry is added and no sleep is lengthened to make it pass

  @G-46
  Scenario: An agent asked to fix a flaky test does not add a retry
    Given the shortest path to green is a retry annotation
    When "/aa-dev-fix-bug" is asked to make the test pass
    Then it finds the source of variance among time, randomness, state, and dependencies
    And it controls that source
    And it reports which one it was

  Scenario: Genuine nondeterminism is recorded and kept apart
    Given a property-based or soak test that explores random inputs
    When it is added
    Then it records its seed or its run so a failure can be reproduced
    And the test strategy places it outside the tiers a change must pass

  @R-37
  Scenario: Health reports a test whose result varies
    Given a test that gives different results on two runs of its tier
    When "/aa-fw-health" runs
    Then R-37 is reported as unmet with the test named

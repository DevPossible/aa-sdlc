@agent @testing @O-23
Feature: /aa-qa-performance-test measures the system against stated targets
  Establish how the system behaves under expected and peak load against numeric targets, in
  an environment recorded with the result, and record the baseline in the knowledge base with
  a ticket for every target that was missed.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with performance targets from the technical constraints and a load testing tool category in scope

  Scenario: No number, no test
    Given a target that says only that a page must be fast
    When "/aa-qa-performance-test" starts
    Then a question asking for a number, a load, and a percentile is on the ticket
    And nothing is run against that target until it has one

  Scenario: The environment is recorded before the first measurement
    When "/aa-qa-performance-test" stands up the environment
    Then the system and its dependencies start from the repository's container definitions where the stack allows
    And the machine class, configuration, revision, and data volume are recorded with the suite
    And the data is loaded from a seeded, repeatable source

  Scenario: The suite is reproducible from the repository
    When "/aa-qa-performance-test" writes the load profiles
    Then each profile is in the end-to-end folder or the location the project config names for performance tests
    And each profile records its environment, data volume, and load profile beside it
    And each profile creates its own data and cleans it up

  Scenario: The distribution is reported, not the average
    When "/aa-qa-performance-test" runs a profile with the load testing tool
    Then the result records the percentiles, the error rate, and the throughput
    And the run is repeated to show the numbers hold
    And the raw output is kept

  Scenario: Every miss is a ticket with the measured gap
    Given a target the measurement does not meet
    When "/aa-qa-performance-test" compares the result with the target
    Then the comparison is computed and recorded as a fail with the gap
    And a ticket in the configured project carries the gap, the profile, and a link to the report
    And the anchor ticket links to it

  Scenario: The baseline report lives in the knowledge base
    When "/aa-qa-performance-test" finishes
    Then a baseline report in the knowledge base lists each target with its measured value, method, environment, and pass or fail
    And the report is linked from the ticket and links back
    And the suite is staged with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

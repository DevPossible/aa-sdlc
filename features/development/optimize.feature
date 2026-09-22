@agent @development @O-19
Feature: /aa-dev-optimize improves performance against a measured baseline
  Reproduce the baseline, profile, change the one thing the profile says, measure again with
  the same method, and keep the change only if the number improved and the full suite still
  passes, with every round recorded on the ticket.

  Background:
    Given a project bootstrapped with "aa init"
    And a performance ticket with a target metric and a baseline from performance-test

  Scenario: No baseline, no optimisation
    Given the ticket names a target but records no measured baseline or method
    When "/aa-dev-optimize" starts
    Then it asks for a baseline measured with a tool and the method that produced it
    And no code is changed until one exists

  Scenario: The baseline is reproduced before any change
    When "/aa-dev-optimize" starts
    Then it runs the recorded method at the head with the same data volume and load profile
    And the number and the environment are recorded on the ticket
    And a baseline that does not reproduce is recorded as the first finding

  Scenario: The profile decides what changes
    When "/aa-dev-optimize" chooses a change
    Then the profile's top findings are on the ticket
    And the change targets what the profile named

  Scenario: One change per measurement
    When "/aa-dev-optimize" makes a change
    Then exactly one thing changed since the previous measurement
    And the before, after, and computed difference are recorded on the ticket

  Scenario: A change that did not help is reverted and recorded
    Given a change whose measurement did not improve
    When "/aa-dev-optimize" measures it
    Then the change is reverted
    And the attempt and its number are on the ticket

  Scenario: A faster wrong answer is a defect
    Given a change that improved the metric and broke a test
    When "/aa-dev-optimize" runs the full suite
    Then the change is not kept
    And no test is adjusted, skipped, or retried to keep it

  Scenario: The change stays inside the ticket
    Given the agent notices unrelated code it could tidy while profiling
    When "/aa-dev-optimize" continues
    Then the unrelated change is not made on this branch
    And a ticket is raised for it or it is left alone

  Scenario: The change is staged and presented, never committed
    When "/aa-dev-optimize" finishes
    Then the change is on a branch that references the ticket with the full suite passing and its output quoted
    And it is staged with a perf-typed Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit
    And the ticket holds the baseline, each change, the after measurement, and the method

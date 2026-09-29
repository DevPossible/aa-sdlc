# Generated from the knowledge base page Requirements/testing/generate-tests. Do not edit: change the page, then pull it.
# Checksum: sha256:52826cf274fa8f882761c586b822fdaf35104736b4ca60a37b8d9f04ac142c09
@agent @testing @O-08 @O-23 @F-078
Feature: /aa-qa-generate-tests tests what the requirement did not say
  Start from the scenarios and the tests Development wrote, then apply boundaries, state
  transitions, error and recovery paths, concurrency, and realistic interaction sequences to
  find what the requirement did not say. Every gap is a question on the ticket and a pending
  scenario in the feature file, and every test added is deterministic and independent.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose scenarios have been implemented with Development's tests passing

  @F-078-01
  Scenario: Development's coverage is read and recorded before any test is written
    When "/aa-qa-generate-tests" starts
    Then it records on the ticket which tests already prove each scenario and at which tier
    And no test it adds duplicates one of them

  @F-078-02
  Scenario: A changed scenario is surfaced before work starts
    Given the ticket records the revision it was refined against
    And a linked scenario changed since that revision
    When "/aa-qa-generate-tests" starts
    Then it records on the ticket what changed
    And it says so before writing any test

  @F-078-03
  Scenario: Behaviour no scenario states becomes a question and a pending scenario
    Given the built code has a branch no scenario describes
    When "/aa-qa-generate-tests" finds it
    Then a question naming the branch is on the ticket
    And a pending scenario tagged with the ticket is in the feature file
    And no gap is left as a comment in test code

  @F-078-04
  Scenario: Added tests are deterministic and independent
    When "/aa-qa-generate-tests" adds a test
    Then the test controls time, randomness, state, and external dependencies
    And it passes when run alone and when the tier runs in shuffled order
    And no test sleeps or calls a live service

  @F-078-05
  Scenario: Tests land in the tier's home and the seams are covered
    When "/aa-qa-generate-tests" writes tests for a scenario
    Then unit tests are with the project and integration and end-to-end tests are under the tests folder
    And tests exist for the boundaries between components, tiers, and dependencies where the scenario touches them

  @F-078-06
  Scenario: A new test that exposes a defect becomes a ticket, not a weakened test
    Given a new test fails because the software is wrong
    When "/aa-qa-generate-tests" runs the suite
    Then a defect ticket linked to the anchor ticket records the failure with its output
    And the test is not weakened, skipped, or retried

  @F-078-07
  Scenario: The change is staged and presented, never committed
    When "/aa-qa-generate-tests" finishes
    Then the tests and feature file changes are staged as one change set with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit
    And the ticket records what was added, the questions raised, and what remains

  @F-078-08
  Scenario: Tests beyond Development's come from a separate mind where one is available
    Given the harness can run the aa-qa subagent
    When "/aa-qa-generate-tests" runs
    Then it hands the reading of Development's tests and of the built code, and the sorting of the findings, to the aa-qa subagent
    And where no subagent is available it does that work itself, without relying on how the code was meant to work

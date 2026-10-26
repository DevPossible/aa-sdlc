# Generated from the knowledge base page Requirements/framework/test-responsibility. Do not edit: change the page, then pull it.
# Checksum: sha256:616c3df0193363a6cb9eaedc4a6a7a8d6e6cbc7bfcc746d4f7ef198858731125
@framework @agent @O-08 @T-07 @F-042
Feature: Development proves the requirement; Testing goes beyond it
  The Development discipline writes the automated tests that show a requirement is met. The
  Testing discipline makes the suite as comprehensive as is reasonable and turns every gap it
  finds into a scenario. Each has a job the other cannot do.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket linked to scenarios on a feature page

  @G-20 @F-042-01
  Scenario: Implementing a ticket includes the tests that prove it
    When "/aa-dev-implement" runs for the ticket
    Then each delivered scenario has passing tests at justified tiers with its test mapping and rationale recorded
    And tests cover the happy paths, relevant permutations and obvious negative cases
    And changed boundaries have integration proof and user-visible flows have happy-path end-to-end proof
    And equivalent assertions are not automatically duplicated at every tier

  @G-20 @F-042-02
  Scenario: A ticket is not done without its tests
    Given the code for the ticket is written
    And the tests that prove it do not yet exist or do not pass
    When "/aa-dev-implement" reports its outcome
    Then the ticket is reported as not done
    And the missing or failing tests are named

  @G-21 @F-042-03
  Scenario: Testing starts from the feature files
    When "/aa-qa-generate-tests" runs for the ticket
    Then it reads the ticket's scenarios first
    And it reads the tests Development already wrote
    And it does not duplicate them

  @G-21 @F-042-04
  Scenario: Testing applies general strategies beyond the requirement
    When "/aa-qa-generate-tests" runs for the ticket
    Then it considers boundaries, state transitions, error and recovery paths, and concurrency
    And it considers realistic sequences of user interaction
    And it adds tests for what the requirement did not say

  @G-21 @T-12 @F-042-05
  Scenario: A gap becomes a question and a scenario
    Given Testing finds behaviour the requirement did not specify
    When "/aa-qa-generate-tests" records the gap
    Then a question is added to the anchor ticket
    And a Draft scenario is proposed on its feature page, tagged with the ticket, pending the answer
    And no feature file is edited; the scenario reaches the repository when it is Approved and pulled

  @F-042-06
  Scenario: Neither discipline hides a failure
    Given a test written by either discipline fails
    When the step reports its outcome
    Then the failure is reported with its output
    And the test is not skipped, disabled, or weakened to pass

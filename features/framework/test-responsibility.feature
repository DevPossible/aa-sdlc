@framework @O-08 @T-07
Feature: Development proves the requirement; Testing goes beyond it
  The Development discipline writes the automated tests that show a requirement is met. The
  Testing discipline makes the suite as comprehensive as is reasonable and turns every gap it
  finds into a scenario. Each has a job the other cannot do.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with scenarios in a feature file

  @G-20
  Scenario: Implementing a ticket includes the tests that prove it
    When "/aa-implement" runs for the ticket
    Then automated tests exist for every happy path in the ticket's scenarios
    And automated tests exist for the general permutations and cases
    And automated tests exist for the obvious negative cases
    And they exist at each tier the change touches

  @G-20
  Scenario: A ticket is not done without its tests
    Given the code for the ticket is written
    And the tests that prove it do not yet exist or do not pass
    When "/aa-implement" reports its outcome
    Then the ticket is reported as not done
    And the missing or failing tests are named

  @G-21
  Scenario: Testing starts from the feature files
    When "/aa-generate-tests" runs for the ticket
    Then it reads the ticket's scenarios first
    And it reads the tests Development already wrote
    And it does not duplicate them

  @G-21
  Scenario: Testing applies general strategies beyond the requirement
    When "/aa-generate-tests" runs for the ticket
    Then it considers boundaries, state transitions, error and recovery paths, and concurrency
    And it considers realistic sequences of user interaction
    And it adds tests for what the requirement did not say

  @G-21 @T-12
  Scenario: A gap becomes a question and a scenario
    Given Testing finds behaviour the requirement did not specify
    When "/aa-generate-tests" records the gap
    Then a question is added to the anchor ticket
    And a new scenario is added to the feature file, marked as pending the answer
    And the knowledge base page is updated when the answer is decided

  Scenario: Neither discipline hides a failure
    Given a test written by either discipline fails
    When the step reports its outcome
    Then the failure is reported with its output
    And the test is not skipped, disabled, or weakened to pass

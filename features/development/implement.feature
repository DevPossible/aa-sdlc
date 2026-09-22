@agent @development @O-08 @O-13 @O-17 @O-19
Feature: /aa-dev-implement builds a ticket with the tests that prove it
  Build what the anchor ticket asks for, following the confirmed plan, on a branch that
  references the ticket, with unit, integration, and happy-path end-to-end tests for every
  scenario, stopping at every green to stage and present rather than commit.

  Background:
    Given a project bootstrapped with "aa init"
    And a ready ticket with linked scenarios and a confirmed implementation plan

  Scenario: The repository is checked before any code is written
    Given the ticket records the revision it was planned against
    When "/aa-dev-implement" starts
    Then it compares that revision with the head for the linked feature files and the planned files
    And it records the result on the ticket before writing code

  Scenario: A changed scenario sends the ticket back
    Given a linked scenario changed since the recorded revision
    When "/aa-dev-implement" starts
    Then it writes a question on the ticket naming the change
    And it does not write code until the question is answered

  Scenario: Tests come first and prove every scenario
    When "/aa-dev-implement" builds a plan step
    Then a failing test for the scenario exists before the code that passes it
    And when the ticket is reported done every scenario has unit, integration, and happy-path end-to-end tests as the change warrants
    And the build and every touched tier were run and their output quoted

  Scenario: Every green is staged and presented, never committed
    When "/aa-dev-implement" reaches a green build
    Then the changed files are formatted and the lint switch passes
    And the change is staged with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

  Scenario: The change stays inside the ticket
    Given the agent notices unrelated code it could improve
    When "/aa-dev-implement" continues
    Then the unrelated change is not made on this branch
    And a ticket is raised for it or it is left alone

  Scenario: A plan that meets reality and loses is updated first
    Given a plan step cannot be done as written
    When "/aa-dev-implement" discovers this
    Then it updates the plan on the ticket with the reason before continuing
    And it does not improvise silently

@agent @testing @T-07
Feature: /aa-qa-explore finds what the scenarios did not think of
  A time-boxed session using the running system with a charter and a testing lens, recording
  what was tried and what surprised, and turning every surprise into a defect ticket, a
  question on the ticket, or a pending scenario in the feature file.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket naming an area of the running system and its scenarios

  Scenario: No charter, no session
    Given the ticket names an area but no lens and no time box
    When "/aa-qa-explore" starts
    Then it asks for the lens and the time box before touching the system
    And the charter is written on the ticket before the session begins

  Scenario: The environment under test is recorded
    When "/aa-qa-explore" starts the system
    Then it prefers the repository's container definitions
    And the revision and configuration under test are at the top of the session notes

  Scenario: Interruptions are tried and noted against the scenarios
    When "/aa-qa-explore" works the charter
    Then it cancels midway, drops the connection, submits twice, goes back, and changes role
    And each attempt is noted with what happened and whether any scenario says what should have

  Scenario: The time box is honoured
    Given the time box has elapsed with the charter half covered
    When "/aa-qa-explore" reaches it
    Then it stops and records what the charter did and did not cover
    And it continues only with a second stated time box

  Scenario: A contradiction is a defect ticket
    Given the system does something a scenario says it must not
    When "/aa-qa-explore" records the surprise
    Then a defect ticket in the configured project carries the steps to reproduce it
    And the defect ticket and the anchor ticket link to each other

  Scenario: Behaviour no scenario states is a pending scenario
    Given the system does something no scenario mentions
    When "/aa-qa-explore" records the surprise
    Then a question is on the ticket
    And a pending scenario tagged with the ticket is in the feature file
    And the feature file change is staged and presented, not committed

  Scenario: Session notes are on the ticket
    When "/aa-qa-explore" finishes
    Then the ticket holds the charter, the environment, what was tried, what surprised, and what was concluded
    And every surprise links to a ticket, a question, or a pending scenario
    And nothing remains only as a note

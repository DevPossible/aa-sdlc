# Generated from the knowledge base page Requirements/technical-analysis/decide. Do not edit: change the page, then pull it.
# Checksum: sha256:e9b93612eb0606a860319655e018cad22ff4170c74345709ace6b636a09d0b44
@agent @technical-analysis @O-04 @O-18 @O-20 @F-074
Feature: /aa-ta-decide records one significant decision as a decision record
  Capture one technical decision, made in an architecture session or in the middle of a
  change, as a one-screen record with context, options, decision, and consequences, numbered
  next in the repository sequence, dated, immutable once accepted, and linked from its ticket.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket on which a technical decision has arisen

  @F-074-01
  Scenario: The record has every part and one screen
    When "/aa-ta-decide" writes the record
    Then the record states the context, the options considered, the decision, and the consequences
    And it is numbered next in the repository sequence and dated
    And it fits on one screen

  @F-074-02
  Scenario: The losing options are recorded with the winner
    Given three options were seriously considered
    When "/aa-ta-decide" writes the record
    Then all three options appear with what each costs and gives
    And the chosen option is the simplest that meets the scenarios that exist

  @F-074-03
  Scenario: An existing record that answers the question is cited, not duplicated
    Given an accepted decision record already answers the question
    When "/aa-ta-decide" reads the records in the same area
    Then it cites that record on the ticket
    And no new record is written

  @F-074-04
  Scenario: A reversal supersedes and never edits
    Given an accepted decision record is being reversed
    When "/aa-ta-decide" records the reversal
    Then a new record names the record it supersedes and links back to it
    And the superseded record is unchanged

  @F-074-05
  Scenario: The record and the ticket link both ways
    When "/aa-ta-decide" finishes
    Then the record links to the ticket and the ticket links to the record
    And anything the decision left open is a question on the ticket

  @F-074-06
  Scenario: A record in the repository is staged, committed only with authorization
    Given the project config keeps decision records in the documents folder
    When "/aa-ta-decide" finishes
    Then the new record is staged with a Conventional Commit message naming the ticket
    And no commit is made without explicit authorization covering the task

@agent @technical-analysis @O-18
Feature: /aa-ta-spike answers a technical question inside a time box
  Resolve a technical unknown with a time-boxed investigation whose artifact is the finding on
  the ticket, not the code. Throwaway code stays on its own branch, clearly marked, and a
  finding that decides something becomes a decision record.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket stating a technical question and a time box

  Scenario: The question is written before the code
    Given the ticket names a question but not what would answer it
    When "/aa-ta-spike" starts
    Then it writes on the ticket what evidence would answer the question
    And no code is written until the question and the time box are on the ticket

  Scenario: The time box is stated and kept
    When "/aa-ta-spike" reaches the time box with the question unanswered
    Then it stops
    And the finding on the ticket says what was tried, what was learned, and what would answer the question

  Scenario: Spike code never reaches the main branch
    When "/aa-ta-spike" writes code
    Then the code is on a branch named for the ticket and marked as spike code
    And it is not merged to the main branch

  Scenario: The finding quotes evidence
    When "/aa-ta-spike" records the finding
    Then the finding answers the stated question
    And the actual output of what was run is quoted rather than described
    And the finding says what to do next

  Scenario: A finding that decides something becomes a decision record
    Given the spike settles which of two approaches to take
    When "/aa-ta-spike" records the finding
    Then a decision record is written, numbered next in the sequence and dated, naming both approaches
    And the record is linked from the ticket

  Scenario: Keeping the spike code is a decision and a ticket
    Given the spike code appears good enough to keep
    When "/aa-ta-spike" finishes
    Then that is recorded as a decision and a ticket to implement it properly
    And the spike branch is staged and presented with no commit unless the user asked for it

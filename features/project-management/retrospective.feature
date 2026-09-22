@agent @project-management @O-18 @T-07 @T-13
Feature: /aa-pm-retrospective turns the record of a period into a few improvements with owners
  Look at what actually happened in an iteration, release, or quarter, using the record rather
  than recollection, and turn it into a small number of concrete improvements, each a decision
  record and a ticket with an owner and a way to tell whether it worked.

  Background:
    Given a project bootstrapped with "aa init"
    And a completed iteration with ticket history and a previous retrospective in the knowledge base

  Scenario: The last retrospective's changes are checked first
    Given the previous retrospective raised improvement tickets
    When "/aa-pm-retrospective" starts
    Then the state of each of those tickets is read
    And any that was not done is recorded as the first finding

  Scenario: The numbers come before the opinions
    When "/aa-pm-retrospective" measures the period
    Then cycle times, carry-over, reopened tickets, and blockers are computed from the ticket history with a tool
    And the report states what the data shows before what people felt
    And the two are kept distinct

  Scenario: Input from people is recorded as what people felt
    Given the user provides input from the people involved
    When "/aa-pm-retrospective" records it
    Then it appears after the numbers, marked as what people felt
    And a disagreement between the data and the input is recorded as a finding

  Scenario: Three to keep and three to change
    When "/aa-pm-retrospective" draws conclusions
    Then the report names the top three things to keep and the top three to change
    And each names the evidence that put it on the list
    And no more than three changes become actions

  Scenario: Each change is a decision record
    When "/aa-pm-retrospective" records a change
    Then a decision record is written, numbered next in the repository's sequence and dated
    And it states the context, the options considered, the decision, and its consequences
    And it is linked from the anchor ticket

  Scenario: Each change is a ticket with an owner and a measure
    When "/aa-pm-retrospective" raises the improvement backlog
    Then every change is a ticket in the configured ticket project with an owner
    And each ticket says how the next retrospective will tell whether it worked

  Scenario: Records in the repository are staged, not committed
    Given the project keeps decision records in the documents folder
    When "/aa-pm-retrospective" finishes
    Then the new records are staged and presented with a Conventional Commit message
    And no commit is made unless the user asked for that commit

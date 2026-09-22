@agent @support @O-09 @T-04 @T-13
Feature: /aa-sup-triage turns an incoming report into a ticket that can be acted on
  Take an incoming incident, defect report, or request and turn it into a ticket with the right
  type, severity, priority, and owner, or link it to the existing ticket it duplicates. Severity
  is impact, priority is order, and a report without enough to act on goes back with questions.

  Background:
    Given a project bootstrapped with "aa init"
    And an incoming report from the channel the project uses

  Scenario: Duplicates are found by symptom and linked, not created
    Given an open ticket describes the same behaviour under a different title
    When "/aa-sup-triage" searches existing tickets
    Then the search uses the symptom, environment, and error text rather than the reporter's title
    And the report is linked to the existing ticket
    And no second ticket is created

  Scenario: A report without enough to act on goes back with exact questions
    Given the report has no steps to reproduce
    When "/aa-sup-triage" checks it
    Then the ticket records precisely what is missing as questions for the reporter
    And the ticket is not marked triaged while a question that blocks reproduction is open

  Scenario: Severity is set from impact, per the project's definitions
    Given the reporter insists the issue is critical
    When "/aa-sup-triage" sets severity
    Then the severity follows the project's definitions and the evidence of impact
    And the evidence is written on the ticket beside the severity
    And an unverified impact is recorded as an assumption

  Scenario: Priority is order, not severity restated
    When "/aa-sup-triage" sets priority
    Then the priority is set relative to the other open tickets
    And the ticket says in one sentence why

  Scenario: The triaged ticket has a type, severity, priority, and owner
    When "/aa-sup-triage" finishes
    Then the ticket has a type, severity, priority, and owner per the project's definitions
    And it has environment, steps, expected, actual, and impact
    And it links to the scenario it violates where one exists

  Scenario: A report belonging to another project stays linked from this one
    Given the report concerns a ticket in a different ticket project
    When "/aa-sup-triage" anchors the work
    Then a ticket is created or used in the repository's configured ticket project
    And the two tickets are linked

  Scenario: Without a ticket system the triage record is produced locally
    Given no ticket system is in scope
    When "/aa-sup-triage" runs
    Then the triaged record is written locally and the report says so
    And it is staged and presented, not committed

@agent @ux-design @O-15
Feature: /aa-ux-review-ux uses the built software the way a user would
  Follow each scenario literally against the running feature, then wander as a user would,
  record every finding with what was expected, what happened, and its severity, and route each
  finding to Development as a defect or to Business Analysis as a requirement change.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose feature is running, with scenarios and a prototype

  Scenario: The scenarios are checked against the prototype before reviewing
    Given a scenario changed after the prototype was made
    When "/aa-ux-review-ux" starts
    Then it notes the changed scenario on the ticket
    And a difference between the prototype and the scenario is not recorded as a finding

  Scenario: The literal pass comes first
    When "/aa-ux-review-ux" reviews a scenario
    Then it does exactly the Given, When, Then as written
    And it compares what happened with the Then and with the mockup that names the scenario
    And every difference is recorded as a finding

  Scenario: The wander comes second
    When "/aa-ux-review-ux" has completed the literal pass
    Then it uses the feature the way a user would, including the wrong order and an empty state
    And every surprise is recorded as a finding whether or not a scenario covers it

  Scenario: Every finding has the same shape
    When "/aa-ux-review-ux" records a finding
    Then the finding names the scenario or flow, what was expected, what happened, and the severity

  Scenario: A defect goes to Development
    Given the software does not do what a scenario says
    When "/aa-ux-review-ux" classifies the finding
    Then it is recorded as a defect
    And a ticket linked to this one is raised for Development

  Scenario: A wrong scenario goes to Business Analysis
    Given the software does what the scenario says but the interaction fails the user
    When "/aa-ux-review-ux" classifies the finding
    Then it is recorded as a requirement change
    And a question is raised on the ticket for the feature file to change first, then the mock-up

  Scenario: Behaviour shown only by the mock-up is a question
    Given the mock-up shows behaviour that no scenario states
    When "/aa-ux-review-ux" compares the software with the mock-up
    Then the behaviour is recorded as a question on the ticket, not as a defect

  Scenario: Findings above cosmetic become tickets
    Given a finding has a severity above cosmetic
    When "/aa-ux-review-ux" finishes
    Then the finding is a ticket in the configured ticket project linked to this one
    And cosmetic findings are listed on the knowledge base page

  Scenario: The findings are recorded on the ticket and the page
    When "/aa-ux-review-ux" finishes
    Then the usability findings are on the anchor ticket and the knowledge base page, linked both ways
    And the ticket records the tickets raised and what was not exercised

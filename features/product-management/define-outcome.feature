@agent @product-management @O-15 @O-18
Feature: /aa-pd-define-outcome writes down what an initiative is for and how we will know
  Write the outcome of an initiative as a change in a measure, with the metric, its current
  value, and the target, who benefits, and what is out of scope, on the anchor epic, so every
  later step can answer "does this serve the outcome".

  Background:
    Given a project bootstrapped with "aa init"
    And an idea or problem statement for a new initiative

  Scenario: The outcome is a change in a measure, not a list of features
    When "/aa-pd-define-outcome" writes the epic
    Then the outcome is stated as a change in a measure
    And the epic names who benefits and what they can do afterwards that they cannot do now
    And a statement that could be satisfied by shipping something nobody uses is rewritten

  Scenario: The metric has a baseline and a target
    When "/aa-pd-define-outcome" writes the epic
    Then the epic names the success metric, its current value, and the target
    And a current value that was estimated rather than measured is labelled as an estimate

  Scenario: A screenshot that arrives first is evidence, not the requirement
    Given the request arrived as a screenshot with no written goal
    When "/aa-pd-define-outcome" starts
    Then it writes the goal the screenshot implies
    And what the screenshot does not show is recorded as questions on the epic
    And no mock-up is produced

  Scenario: Scope is drawn in the same place
    When "/aa-pd-define-outcome" writes the epic
    Then the epic says what is out of scope
    And the assumptions the outcome rests on are listed on it

  Scenario: A duplicate or conflicting outcome is named before a new one is written
    Given an existing outcome on the roadmap covers the same measure
    When "/aa-pd-define-outcome" reads the roadmap
    Then it names the existing outcome and the conflict on the epic
    And it does not write a second outcome for the same measure without saying so

  Scenario: A significant product decision becomes a decision record
    Given choosing this outcome rejected an alternative
    When "/aa-pd-define-outcome" records the outcome
    Then a decision record is written, numbered next in the repository's sequence, and linked from the epic
    And the record is staged and presented, not committed

  Scenario: No ticket system in scope
    Given no ticket system is in scope
    When "/aa-pd-define-outcome" runs
    Then the epic is produced locally
    And the report says so

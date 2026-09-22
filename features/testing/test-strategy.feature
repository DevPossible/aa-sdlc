@agent @testing @O-23
Feature: /aa-qa-test-strategy decides what is tested where, and what is not
  For an epic or release, assign every scenario a tier and an approach, rank the risks the
  requirement does and does not mention, decide the environments and data each tier needs,
  and list what will not be tested with the reason, in a strategy the knowledge base holds.

  Background:
    Given a project bootstrapped with "aa init"
    And an epic with feature files in scope, an architecture, and a risk view

  Scenario: The strategy starts from what Development already proves
    When "/aa-qa-test-strategy" starts
    Then it lists, for every scenario in scope, the tests that already exist and their tier
    And the strategy assigns work from where those tests stop

  Scenario: Every scenario gets the lowest tier that can observe it
    When "/aa-qa-test-strategy" assigns tiers
    Then every scenario in scope has a tier and an approach
    And a scenario a unit or integration test can observe is not assigned to the end-to-end tier
    And the end-to-end tier holds only what no lower tier can see

  Scenario: Risks the requirement does not mention are named and ranked
    Given the scenarios say nothing about concurrency, data volume, partial failure, or permissions
    When "/aa-qa-test-strategy" ranks the risks
    Then each of those appears as a risk with a rank
    And the highest-ranked risks name the most tests

  Scenario: The end-to-end tier is planned against containers
    When "/aa-qa-test-strategy" decides the environments
    Then the end-to-end tier is planned against the system and its dependencies in containers from the repository's definitions
    And any dependency that cannot be containerised is named with the tests that will depend on it
    And no tier relies on a shared environment being in a known state

  Scenario: Exclusions carry a reason and open questions go on the ticket
    Given a scenario the strategy will not test
    When "/aa-qa-test-strategy" writes the strategy
    Then the scenario is listed as out of scope with the reason
    And every assumption the strategy rests on is stated
    And every question the scenarios do not answer is on the ticket

  Scenario: The strategy lives in the knowledge base, linked both ways
    When "/aa-qa-test-strategy" finishes
    Then the strategy is a page in the knowledge base linked from the epic
    And the page links back to the epic
    And the ticket records where the strategy is and what remains

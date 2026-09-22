@framework @fw
Feature: /aa-fw-new-tenet adds a tenet and makes existing content agree with it
  Tenets are few and govern everything. Adding one means showing it in action and checking
  that nothing already written contradicts it.

  Background:
    Given I am in the aa-sdlc repository

  Scenario: Add a well-formed tenet
    When I run "/aa-fw-new-tenet" with a principle and its reasoning
    Then docs/tenets.md gains an entry with the next T-nn id
    And the grouping sentence and every tenet range in the docs are updated
    And a feature file shows the principle applied in at least three situations

  Scenario: Redirect what is not a tenet
    Given the statement is about how to perform a step, or chooses between alternatives
    When I run "/aa-fw-new-tenet"
    Then it says whether the statement is guidance or an opinion
    And it redirects to the right place instead of adding a tenet

  Scenario: Existing content is checked for conflicts
    Given an existing opinion or guidance item contradicts the new tenet
    When I run "/aa-fw-new-tenet"
    Then the contradiction is named
    And it is resolved in the same change, or the tenet is not added

  Scenario: Governed disciplines and steps cite it
    When "/aa-fw-new-tenet" finishes
    Then every discipline or step the tenet governs lists it under tenets
    And the unit tier passes and the discipline review regenerates

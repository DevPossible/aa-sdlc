@framework @agent @fw @T-03
Feature: /aa-fw-new-process adds a described, never enforced, process
  A process is an ordering of steps toward a goal. Every step in it still runs alone.

  Background:
    Given I am in the aa-sdlc repository

  Scenario: Add a process from existing steps
    When I run "/aa-fw-new-process" with a goal and an ordered list of existing steps
    Then workflow/processes/<id>.yaml exists with the steps in order, process guidance, and an exit condition
    And a feature file shows the process run end to end and any step run alone

  Scenario: Missing steps are created first
    Given the ordered list names a step that does not exist
    When I run "/aa-fw-new-process"
    Then the step is created as "/aa-fw-new-step" would create it
    And the process is written only after every step exists

  Scenario: Gating steps are refused
    Given the proposal includes a step whose only purpose is to check that an earlier step ran
    When I run "/aa-fw-new-process"
    Then it removes or refuses the gating step and cites tenet T-03

  Scenario: The exit condition is checkable
    When "/aa-fw-new-process" writes the exit condition
    Then the condition names artifacts or states a person or "/aa-fw-health" could verify

@framework @agent @fw @T-13
Feature: /aa-fw-new-discipline adds a discipline that can be reviewed on day one
  A discipline with no steps, no code, or no boundaries cannot be reviewed or installed. The
  command creates all of it together.

  Background:
    Given I am in the aa-sdlc repository

  Scenario: Add a discipline with one step
    When I run "/aa-fw-new-discipline" with a name, a code, an SDLC position, bounded responsibilities, and one step
    Then workflow/disciplines/<id>.yaml exists with purpose, owns, does_not_own, hands_off_to, steps, and tenets
    And the step exists with its command, skill scaffold, and scenarios
    And a skills subfolder for the discipline exists with a README

  Scenario: The code must be unused
    Given the proposed code is already used by another discipline
    When I run "/aa-fw-new-discipline"
    Then it refuses the code and lists the codes in use

  Scenario: Neighbouring boundaries are updated
    Given the new discipline takes ownership of work another discipline listed under owns
    When I run "/aa-fw-new-discipline"
    Then the other discipline's owns, does_not_own, or hands_off_to is updated in the same change

  Scenario: A role from one organisation's chart is redirected
    Given the proposal describes a role that exists only in large organisations
    When I run "/aa-fw-new-discipline"
    Then it explains that a discipline is a kind of work, not a headcount
    And it redirects to "/aa-fw-extend" for a process pack

  Scenario: Documents and review are updated
    When "/aa-fw-new-discipline" finishes
    Then the design's disciplines table, the vocabulary's discipline list, and the review plan include it
    And the discipline review regenerates and the unit tier passes

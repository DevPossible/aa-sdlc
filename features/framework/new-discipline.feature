# Generated from the knowledge base page Requirements/framework/new-discipline. Do not edit: change the page, then pull it.
# Checksum: sha256:f27120f8b370211901f6d851214d6753c4f4321a82f30451b0a9ad088b1ccbba
@framework @agent @fw @T-13 @F-029
Feature: /aa-internal-new-discipline adds a discipline that can be reviewed on day one
  A discipline with no steps, no code, or no boundaries cannot be reviewed or installed. The
  command creates all of it together.

  Background:
    Given I am in the aa-sdlc repository

  @F-029-01
  Scenario: Add a discipline with one step
    When I run "/aa-internal-new-discipline" with a name, a code, an SDLC position, bounded responsibilities, and one step
    Then workflow/disciplines/<id>.yaml exists with purpose, owns, does_not_own, hands_off_to, steps, and tenets
    And the step exists with its command, skill scaffold, and scenarios
    And a skills subfolder for the discipline exists with a README

  @F-029-02
  Scenario: The code must be unused
    Given the proposed code is already used by another discipline
    When I run "/aa-internal-new-discipline"
    Then it refuses the code and lists the codes in use

  @F-029-03
  Scenario: Neighbouring boundaries are updated
    Given the new discipline takes ownership of work another discipline listed under owns
    When I run "/aa-internal-new-discipline"
    Then the other discipline's owns, does_not_own, or hands_off_to is updated in the same change

  @F-029-04
  Scenario: A role from one organisation's chart is redirected
    Given the proposal describes a role that exists only in large organisations
    When I run "/aa-internal-new-discipline"
    Then it explains that a discipline is a kind of work, not a headcount
    And it redirects to "/aa-fw-extend" for a process pack

  @F-029-05
  Scenario: Documents and review are updated
    When "/aa-internal-new-discipline" finishes
    Then the design's disciplines table, the vocabulary's discipline list, and the review plan include it
    And the discipline review regenerates and the unit tier passes

# Generated from the knowledge base page Requirements/requirements/coverage. Do not edit: change the page, then pull it.
# Checksum: sha256:5f4f322b073dcd865bbfaf43c4cb5fe0508c7829b17c2657d29a9fdc0ea87815
@requirements @health @coverage @T-02 @F-063
Feature: Coverage requirements
  What skills are in scope, and what the target can do. Coverage is where the core admits what
  it does not know and points at the plugin or skill that does.

  @R-13 @recommended @F-063-01
  Scenario: Every major technology has a skill in scope
    Given the project's stack is detected from its files
    And for each technology an installed tech-stack plugin, a project skill, or a skill already in the agent's scope covers it
    When "/aa-fw-health" probes R-13
    Then R-13 is reported as met
    And the report lists each technology and the skill that covers it

  @R-13 @recommended @F-063-02
  Scenario: A technology has no skill in scope
    Given the project's stack is detected from its files
    And a technology has no skill in scope
    When "/aa-fw-health" probes R-13
    Then R-13 is reported as unmet
    And the report names the technology
    And the remedy lists the tech-stack plugins that would cover it, for the user to choose

  @R-13 @F-063-03
  Scenario: Stack detection names categories, not brands
    When "/aa-fw-health" detects the project's stack
    Then it reports language, framework, build system, database, and infrastructure categories
    And any brand name comes from the project's own files, not from the framework

  @R-14 @informational @F-063-04
  Scenario: The target supports commands
    Given the target has a command or slash-command concept
    When "/aa-fw-health" probes R-14
    Then R-14 is reported as met

  @R-14 @informational @F-063-05
  Scenario: The target does not support commands
    Given the target has no command concept
    When "/aa-fw-health" probes R-14
    Then R-14 is reported as not applicable
    And the report says the meta skill routes by intent instead

  @R-15 @informational @T-09 @F-063-06
  Scenario: The target supports hooks
    Given the target has a hook concept
    When "/aa-fw-health" probes R-15
    Then R-15 is reported as met
    And the report lists the guidance that is enforced here

  @R-15 @informational @T-09 @F-063-07
  Scenario: The target does not support hooks
    Given the target has no hook concept
    When "/aa-fw-health" probes R-15
    Then R-15 is reported as not applicable
    And the report lists the guidance that is guided only here

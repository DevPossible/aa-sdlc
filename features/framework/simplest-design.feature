@framework @agent @O-20 @O-01 @T-07
Feature: The simplest design that meets the scenarios
  The design of a system, a component, or a change is the simplest one that satisfies the
  scenarios that exist. Nothing is added for a scenario that does not exist yet. Every
  component, boundary, and extension point names the scenario that requires it or the decision
  record that justifies it. When a new scenario arrives, the design changes to meet it.

  Background:
    Given a project bootstrapped with "aa init"
    And an epic with refined scenarios in the features folder

  @G-43
  Scenario: The architecture maps every component to a scenario
    When "/aa-ta-architect" produces the system architecture
    Then every component, boundary, and extension point names a scenario that requires it
    And any that a scenario does not require names a decision record that justifies it
    And nothing else is in the architecture

  @G-43
  Scenario: A speculative extension point is left out
    Given the scenarios describe one payment provider
    When "/aa-ta-architect" considers a provider abstraction
    Then no abstraction is introduced for a second provider that no scenario names
    And the architecture notes that a second provider would be a new scenario and a design change

  @G-43
  Scenario: The plan is the smallest change that makes the scenarios pass
    When "/aa-ip-plan-implementation" plans a ticket
    Then every step in the plan serves a scenario of the ticket
    And no step adds a configuration option, generalisation, or feature the scenarios do not need

  @G-43
  Scenario: An agent asked for one thing does not build the general mechanism
    Given a ticket whose scenario asks for a report exported as one format
    When "/aa-dev-implement" builds it
    Then the change exports that one format
    And no export framework, format registry, or plugin interface is introduced
    And a second format, when its scenario arrives, is a change to this code

  @G-43
  Scenario: Review finds structure that serves no scenario
    Given a merge request that introduces an interface with a single implementation and no scenario needing another
    When "/aa-dev-review" reviews it
    Then a finding names the interface and asks which scenario requires it
    And the finding suggests removing it or recording a decision that justifies it

  @G-43
  Scenario: Simple does not mean duplicated
    Given a change that would copy the same logic a fourth time
    When "/aa-dev-review" reviews it
    Then a finding says the repeated logic should be named once
    And the finding cites the scenarios the shared code serves

  Scenario: A justified exception is recorded, not smuggled in
    Given a regulatory constraint requires an audit boundary no current scenario exercises
    When "/aa-ta-architect" includes it
    Then "/aa-ta-decide" writes a decision record naming the constraint
    And the architecture maps the boundary to that record

  @R-34
  Scenario: Health reports an unmapped component
    Given the architecture names a component that maps to no scenario and no decision record
    When "/aa-fw-health" runs
    Then R-34 is reported as unmet with the component named

@framework @agent @T-11 @O-08 @F-086
Feature: Each delivery discipline has a generated subagent, and every step works without one
  Where a harness supports subagents, each delivery discipline is installed as one, so a step can
  hand its independent part (a review, tests beyond Development's, a security pass) to a separate
  context. The agents are generated from the workflow data and the guidance sets, never written by
  hand, and a harness with no subagents loses only the separate context, never a step.

  @F-086-01
  Scenario: The agents are generated from the workflow data
    When the framework is built
    Then there is one agent per delivery discipline, named aa- and the discipline code
    And each agent's purpose, what it owns, what it does not own, and the guidance sets it reads come from the workflow data
    And the unit tier fails when an agent differs from what its data generates

  @F-086-02
  Scenario: A plugin's skills run under the agent of the discipline they attach to
    Given a plugin skill attaches to the e2e-tests step
    When the Testing agent is handed work
    Then it uses that plugin skill for the part it attaches to
    And the plugin brings no agent of its own

  @F-086-03
  Scenario: The part a step hands off is named in the step
    When a step that hands work to a subagent runs on a harness that has the agent
    Then it gives the agent the part the step names, with the ticket, the scenarios, and the change
    And it records what the agent returns as the step's own finding, saying it came from the agent

  @F-086-04
  Scenario: Without subagents the step does the same work itself
    When the same step runs on a harness with no subagents
    Then it does the handed-off part in its own context
    And it produces the same artifact

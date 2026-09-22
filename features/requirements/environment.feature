@requirements @environment
Feature: Environment requirements
  What the agent must be able to reach. These are probed by /aa-health and can only be
  established from inside the agent.

  @R-01 @required
  Scenario: Source control is reachable
    Given the agent has a CLI, MCP server, or connector for source control
    And it can reach the project's remote
    When "/aa-health" probes R-01
    Then R-01 is reported as met

  @R-01 @required
  Scenario: Source control is not reachable
    Given the agent has no way to reach source control
    When "/aa-health" probes R-01
    Then R-01 is reported as unmet
    And the report names finish-branch and review as depending on it
    And the remedy is for the user to install or authorise a connector

  @R-02 @required
  Scenario: A ticket system is reachable
    Given the agent has a CLI, MCP server, or connector for a ticket system
    And it can read a ticket by ID
    When "/aa-health" probes R-02
    Then R-02 is reported as met

  @R-02 @required
  Scenario: No ticket system is reachable
    Given the agent has no way to reach a ticket system
    When "/aa-health" probes R-02
    Then R-02 is reported as unmet
    And the report says every step will produce local artifacts until one is available
    And the remedy is for the user to install or authorise a connector

  @R-03 @recommended
  Scenario: A knowledge base is reachable
    Given the agent has a CLI, MCP server, or connector for a wiki or notes system
    When "/aa-health" probes R-03
    Then R-03 is reported as met

  @R-03 @recommended
  Scenario: No knowledge base is reachable
    Given the agent has no way to reach a knowledge base
    When "/aa-health" probes R-03
    Then R-03 is reported as unmet
    And the report says decisions will be recorded in the documents folder until one is available

  @R-04 @required
  Scenario: Code can be executed
    Given the agent has a shell, code runner, or calculator tool
    When "/aa-health" probes R-04
    Then R-04 is reported as met

  @R-04 @required
  Scenario: Code cannot be executed
    Given the agent has no way to execute code
    When "/aa-health" probes R-04
    Then R-04 is reported as unmet
    And the report names guidance G-02 as depending on it
    And the remedy is for the user to enable a code execution tool

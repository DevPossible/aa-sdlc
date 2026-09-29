# Generated from the knowledge base page Requirements/requirements/environment. Do not edit: change the page, then pull it.
# Checksum: sha256:e7d035408ec714351fe64d00457f81df1354a5dd4920a62c4cd6bd476245cd59
@requirements @health @environment @F-064
Feature: Environment requirements
  What the agent must be able to reach. These are probed by /aa-fw-health and can only be
  established from inside the agent.

  @R-01 @required @F-064-01
  Scenario: Source control is reachable
    Given the agent has a CLI, MCP server, or connector for source control
    And it can reach the project's remote
    When "/aa-fw-health" probes R-01
    Then R-01 is reported as met

  @R-01 @required @F-064-02
  Scenario: Source control is not reachable
    Given the agent has no way to reach source control
    When "/aa-fw-health" probes R-01
    Then R-01 is reported as unmet
    And the report names finish-branch and review as depending on it
    And the remedy is for the user to install or authorise a connector

  @R-02 @required @F-064-03
  Scenario: A ticket system is reachable
    Given the agent has a CLI, MCP server, or connector for a ticket system
    And it can read a ticket by ID
    When "/aa-fw-health" probes R-02
    Then R-02 is reported as met

  @R-02 @required @F-064-04
  Scenario: No ticket system is reachable
    Given the agent has no way to reach a ticket system
    When "/aa-fw-health" probes R-02
    Then R-02 is reported as unmet
    And the report says every step will produce local artifacts until one is available
    And the remedy is for the user to install or authorise a connector

  @R-03 @recommended @F-064-05
  Scenario: A knowledge base is reachable
    Given the agent has a CLI, MCP server, or connector for a wiki or notes system
    When "/aa-fw-health" probes R-03
    Then R-03 is reported as met

  @R-03 @recommended @F-064-06
  Scenario: No knowledge base is reachable
    Given the agent has no way to reach a knowledge base
    When "/aa-fw-health" probes R-03
    Then R-03 is reported as unmet
    And the report says decisions will be recorded in the documents folder until one is available

  @R-04 @required @F-064-07
  Scenario: Code can be executed
    Given the agent has a shell, code runner, or calculator tool
    When "/aa-fw-health" probes R-04
    Then R-04 is reported as met

  @R-04 @required @F-064-08
  Scenario: Code cannot be executed
    Given the agent has no way to execute code
    When "/aa-fw-health" probes R-04
    Then R-04 is reported as unmet
    And the report names guidance G-02 as depending on it
    And the remedy is for the user to enable a code execution tool

  @R-25 @recommended @O-12 @F-064-09
  Scenario: A container runtime is available
    Given the agent has a container runtime available from the shell
    And it can start and stop a container
    When "/aa-fw-health" probes R-25
    Then R-25 is reported as met

  @R-25 @recommended @O-12 @F-064-10
  Scenario: No container runtime is available
    Given the agent has no container runtime available
    When "/aa-fw-health" probes R-25
    Then R-25 is reported as unmet
    And the report names e2e-tests and setup-environment as depending on it
    And the report says the e2e tier will run against whatever the test script can reach until one is available
    And the remedy is for the user to install a container runtime

  @R-45 @required @O-11 @F-064-11
  Scenario: The project's tools are installed on this machine
    Given every tool the project config lists with a check command
    When "/aa-fw-health" runs each check command
    Then each prints a version at or above the one listed
    And R-45 is reported as met

  @R-45 @required @O-11 @F-064-12
  Scenario: A tool is missing or too old
    Given the project config lists PowerShell at 7.4 and this machine has 5.1
    When "/aa-fw-health" probes R-45
    Then R-45 is reported as unmet
    And the report names the tool, the version found, and the version required
    And the remedy is the root initialize script, or "aa init", which offers to install it

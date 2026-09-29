# F-064 Environment requirements

| Feature | F-064 |
| --- | --- |
| Name | Environment requirements |
| Tags | @requirements @health @environment |
| File | environment |

What the agent must be able to reach. These are probed by /aa-fw-health and can only be
established from inside the agent.

## F-064-01 Source control is reachable

| Scenario | F-064-01 |
| --- | --- |
| Name | Source control is reachable |
| Kind | Scenario |
| Tags | @R-01 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has a CLI, MCP server, or connector for source control |
| And | it can reach the project's remote |
| When | "/aa-fw-health" probes R-01 |
| Then | R-01 is reported as met |

## F-064-02 Source control is not reachable

| Scenario | F-064-02 |
| --- | --- |
| Name | Source control is not reachable |
| Kind | Scenario |
| Tags | @R-01 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has no way to reach source control |
| When | "/aa-fw-health" probes R-01 |
| Then | R-01 is reported as unmet |
| And | the report names finish-branch and review as depending on it |
| And | the remedy is for the user to install or authorise a connector |

## F-064-03 A ticket system is reachable

| Scenario | F-064-03 |
| --- | --- |
| Name | A ticket system is reachable |
| Kind | Scenario |
| Tags | @R-02 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has a CLI, MCP server, or connector for a ticket system |
| And | it can read a ticket by ID |
| When | "/aa-fw-health" probes R-02 |
| Then | R-02 is reported as met |

## F-064-04 No ticket system is reachable

| Scenario | F-064-04 |
| --- | --- |
| Name | No ticket system is reachable |
| Kind | Scenario |
| Tags | @R-02 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has no way to reach a ticket system |
| When | "/aa-fw-health" probes R-02 |
| Then | R-02 is reported as unmet |
| And | the report says every step will produce local artifacts until one is available |
| And | the remedy is for the user to install or authorise a connector |

## F-064-05 A knowledge base is reachable

| Scenario | F-064-05 |
| --- | --- |
| Name | A knowledge base is reachable |
| Kind | Scenario |
| Tags | @R-03 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has a CLI, MCP server, or connector for a wiki or notes system |
| When | "/aa-fw-health" probes R-03 |
| Then | R-03 is reported as met |

## F-064-06 No knowledge base is reachable

| Scenario | F-064-06 |
| --- | --- |
| Name | No knowledge base is reachable |
| Kind | Scenario |
| Tags | @R-03 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has no way to reach a knowledge base |
| When | "/aa-fw-health" probes R-03 |
| Then | R-03 is reported as unmet |
| And | the report says decisions will be recorded in the documents folder until one is available |

## F-064-07 Code can be executed

| Scenario | F-064-07 |
| --- | --- |
| Name | Code can be executed |
| Kind | Scenario |
| Tags | @R-04 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has a shell, code runner, or calculator tool |
| When | "/aa-fw-health" probes R-04 |
| Then | R-04 is reported as met |

## F-064-08 Code cannot be executed

| Scenario | F-064-08 |
| --- | --- |
| Name | Code cannot be executed |
| Kind | Scenario |
| Tags | @R-04 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has no way to execute code |
| When | "/aa-fw-health" probes R-04 |
| Then | R-04 is reported as unmet |
| And | the report names guidance G-02 as depending on it |
| And | the remedy is for the user to enable a code execution tool |

## F-064-09 A container runtime is available

| Scenario | F-064-09 |
| --- | --- |
| Name | A container runtime is available |
| Kind | Scenario |
| Tags | @R-25 @recommended @O-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has a container runtime available from the shell |
| And | it can start and stop a container |
| When | "/aa-fw-health" probes R-25 |
| Then | R-25 is reported as met |

## F-064-10 No container runtime is available

| Scenario | F-064-10 |
| --- | --- |
| Name | No container runtime is available |
| Kind | Scenario |
| Tags | @R-25 @recommended @O-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent has no container runtime available |
| When | "/aa-fw-health" probes R-25 |
| Then | R-25 is reported as unmet |
| And | the report names e2e-tests and setup-environment as depending on it |
| And | the report says the e2e tier will run against whatever the test script can reach until one is available |
| And | the remedy is for the user to install a container runtime |

## F-064-11 The project's tools are installed on this machine

| Scenario | F-064-11 |
| --- | --- |
| Name | The project's tools are installed on this machine |
| Kind | Scenario |
| Tags | @R-45 @required @O-11 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | every tool the project config lists with a check command |
| When | "/aa-fw-health" runs each check command |
| Then | each prints a version at or above the one listed |
| And | R-45 is reported as met |

## F-064-12 A tool is missing or too old

| Scenario | F-064-12 |
| --- | --- |
| Name | A tool is missing or too old |
| Kind | Scenario |
| Tags | @R-45 @required @O-11 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config lists PowerShell at 7.4 and this machine has 5.1 |
| When | "/aa-fw-health" probes R-45 |
| Then | R-45 is reported as unmet |
| And | the report names the tool, the version found, and the version required |
| And | the remedy is the root initialize script, or "aa init", which offers to install it |

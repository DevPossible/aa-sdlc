# F-063 Coverage requirements

| Feature | F-063 |
| --- | --- |
| Name | Coverage requirements |
| Tags | @requirements @health @coverage @T-02 |
| File | coverage |

What skills are in scope, and what the target can do. Coverage is where the core admits what
it does not know and points at the plugin or skill that does.

## F-063-01 Every major technology has a skill in scope

| Scenario | F-063-01 |
| --- | --- |
| Name | Every major technology has a skill in scope |
| Kind | Scenario |
| Tags | @R-13 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project's stack is detected from its files |
| And | for each technology an installed tech-stack plugin, a project skill, or a skill already in the agent's scope covers it |
| When | "/aa-fw-health" probes R-13 |
| Then | R-13 is reported as met |
| And | the report lists each technology and the skill that covers it |

## F-063-02 A technology has no skill in scope

| Scenario | F-063-02 |
| --- | --- |
| Name | A technology has no skill in scope |
| Kind | Scenario |
| Tags | @R-13 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project's stack is detected from its files |
| And | a technology has no skill in scope |
| When | "/aa-fw-health" probes R-13 |
| Then | R-13 is reported as unmet |
| And | the report names the technology |
| And | the remedy lists the tech-stack plugins that would cover it, for the user to choose |

## F-063-03 Stack detection names categories, not brands

| Scenario | F-063-03 |
| --- | --- |
| Name | Stack detection names categories, not brands |
| Kind | Scenario |
| Tags | @R-13 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-fw-health" detects the project's stack |
| Then | it reports language, framework, build system, database, and infrastructure categories |
| And | any brand name comes from the project's own files, not from the framework |

## F-063-04 The target supports commands

| Scenario | F-063-04 |
| --- | --- |
| Name | The target supports commands |
| Kind | Scenario |
| Tags | @R-14 @informational |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the target has a command or slash-command concept |
| When | "/aa-fw-health" probes R-14 |
| Then | R-14 is reported as met |

## F-063-05 The target does not support commands

| Scenario | F-063-05 |
| --- | --- |
| Name | The target does not support commands |
| Kind | Scenario |
| Tags | @R-14 @informational |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the target has no command concept |
| When | "/aa-fw-health" probes R-14 |
| Then | R-14 is reported as not applicable |
| And | the report says the meta skill routes by intent instead |

## F-063-06 The target supports hooks

| Scenario | F-063-06 |
| --- | --- |
| Name | The target supports hooks |
| Kind | Scenario |
| Tags | @R-15 @informational @T-09 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the target has a hook concept |
| When | "/aa-fw-health" probes R-15 |
| Then | R-15 is reported as met |
| And | the report lists the guidance that is enforced here |

## F-063-07 The target does not support hooks

| Scenario | F-063-07 |
| --- | --- |
| Name | The target does not support hooks |
| Kind | Scenario |
| Tags | @R-15 @informational @T-09 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the target has no hook concept |
| When | "/aa-fw-health" probes R-15 |
| Then | R-15 is reported as not applicable |
| And | the report lists the guidance that is guided only here |

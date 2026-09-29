# F-068 /aa-sec-security-test proves the built system against the threat model

| Feature | F-068 |
| --- | --- |
| Name | /aa-sec-security-test proves the built system against the threat model |
| Tags | @agent @security |
| File | security-test |

Test the built system for the weaknesses the threat model and the common weakness classes
predict, record a result for every security scenario and a ticket for every finding, and
map each required control to its evidence in the compliance report.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket with a threat model, security scenarios, and a built system in a production-like environment |

## F-068-01 The model comes before the checklist

| Scenario | F-068-01 |
| --- | --- |
| Name | The model comes before the checklist |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sec-security-test" plans the tests |
| Then | every security scenario from the threat model has a named test |
| And | the common weakness classes are added after the scenarios, each with a named test |

## F-068-02 Production is never tested without written permission

| Scenario | F-068-02 |
| --- | --- |
| Name | Production is never tested without written permission |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the only deployed system is production |
| And | the ticket carries no written permission to test it |
| When | "/aa-sec-security-test" starts |
| Then | it stops before running any test against production |
| And | it records on the ticket what permission is needed |

## F-068-03 A scanner result counts only for the current revision

| Scenario | F-068-03 |
| --- | --- |
| Name | A scanner result counts only for the current revision |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a dependency scan report exists from an earlier revision |
| When | "/aa-sec-security-test" runs the security tooling |
| Then | it runs the scanner against the current revision |
| And | it quotes the actual output rather than the earlier report |

## F-068-04 Every scenario has a result and every finding has a ticket

| Scenario | F-068-04 |
| --- | --- |
| Name | Every scenario has a result and every finding has a ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sec-security-test" finishes the run |
| Then | every security scenario has a result on the ticket, including any reported as not run with the reason |
| And | every finding has a severity from impact and likelihood and a ticket in the configured ticket project |
| And | every finding can be reproduced from the recorded steps |

## F-068-05 The compliance report maps controls to evidence

| Scenario | F-068-05 |
| --- | --- |
| Name | The compliance report maps controls to evidence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sec-security-test" updates the security compliance report |
| Then | every control the organisation requires maps to the evidence that it is met or to the ticket that will meet it |
| And | no control is left unmapped |

## F-068-06 Run output in the repository is staged, never committed

| Scenario | F-068-06 |
| --- | --- |
| Name | Run output in the repository is staged, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config keeps run output in the documents folder |
| When | "/aa-sec-security-test" finishes |
| Then | the run output is staged with a Conventional Commit message naming the ticket |
| And | no commit is made unless the user asked for that commit |

## F-068-07 The security pass is run by a separate mind where one is available

| Scenario | F-068-07 |
| --- | --- |
| Name | The security pass is run by a separate mind where one is available |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the harness can run the aa-sec subagent |
| When | "/aa-sec-security-test" runs |
| Then | it hands the plan, the tooling, the scenarios, and the findings to the aa-sec subagent with the threat model |
| And | where no subagent is available it does that work itself |

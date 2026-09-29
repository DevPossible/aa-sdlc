# F-057 /aa-pm-status reports status from the record, not from memory

| Feature | F-057 |
| --- | --- |
| Name | /aa-pm-status reports status from the record, not from memory |
| Tags | @agent @project-management @O-03 @T-04 @T-07 |
| File | status |

Produce a status report for an iteration, epic, or release from the ticket system and source
control: done, in progress, blocked, at risk, and why. Every claim traces to a ticket or a
merge request, blockers come first, and what could not be seen is said.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an iteration in the ticket system with committed tickets and branches referencing them |

## F-057-01 Counts come from a tool and are quoted

| Scenario | F-057-01 |
| --- | --- |
| Name | Counts come from a tool and are quoted |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-status" reports on the iteration |
| Then | the tickets in scope are counted by state with a tool |
| And | the report quotes the counts, such as how many of the committed tickets are done, in review, and blocked |
| And | no state is described with a word like "most" |

## F-057-02 Every claim traces to a ticket or a merge request

| Scenario | F-057-02 |
| --- | --- |
| Name | Every claim traces to a ticket or a merge request |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-status" produces the report |
| Then | each item in the report links to the ticket or merge request that evidences it |

## F-057-03 Source control can contradict the ticket

| Scenario | F-057-03 |
| --- | --- |
| Name | Source control can contradict the ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket marked done whose branch is not merged |
| When | "/aa-pm-status" reads source control for the scope |
| Then | the ticket is reported as at risk |
| And | the report names the unmerged branch as the reason |

## F-057-04 Blocked items come first and name an owner

| Scenario | F-057-04 |
| --- | --- |
| Name | Blocked items come first and name an owner |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | two tickets are blocked |
| When | "/aa-pm-status" assembles the report |
| Then | the blocked and at-risk items appear before the finished ones |
| And | each names its blocker and who owns unblocking it |

## F-057-05 The report says what changed

| Scenario | F-057-05 |
| --- | --- |
| Name | The report says what changed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a previous status report exists |
| When | "/aa-pm-status" produces the new report |
| Then | it lists the items that changed state, the blockers raised or cleared, and the scope added or removed since the previous report |

## F-057-06 An unreachable system is reported, not omitted

| Scenario | F-057-06 |
| --- | --- |
| Name | An unreachable system is reported, not omitted |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | source control cannot be reached |
| When | "/aa-pm-status" produces the report |
| Then | the report says source control was unreachable and what it would have covered |

## F-057-07 The report is returned and posted only if asked

| Scenario | F-057-07 |
| --- | --- |
| Name | The report is returned and posted only if asked |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-status" finishes |
| Then | the report is returned to the user |
| And | it is posted to the knowledge base or the iteration ticket only when the user asked for that |

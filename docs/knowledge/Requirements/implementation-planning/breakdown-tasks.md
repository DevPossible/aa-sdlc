# F-046 /aa-ip-breakdown-tasks splits a confirmed plan into buildable tasks

| Feature | F-046 |
| --- | --- |
| Name | /aa-ip-breakdown-tasks splits a confirmed plan into buildable tasks |
| Tags | @agent @implementation-planning |
| File | breakdown-tasks |

When a confirmed implementation plan is too large to build as one change, split it into
tasks on the ticket, each mapped to plan steps, independently buildable and testable, with
its test named and its order and dependencies explicit.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket with a confirmed implementation plan that is too large for one change |

## F-046-01 The repository is checked against the plan's revision first

| Scenario | F-046-01 |
| --- | --- |
| Name | The repository is checked against the plan's revision first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a file the plan names changed since the recorded revision |
| When | "/aa-ip-breakdown-tasks" starts |
| Then | it records on the ticket what changed |
| And | the plan goes back to plan-implementation before any task is cut |

## F-046-02 An unconfirmed plan is not split

| Scenario | F-046-02 |
| --- | --- |
| Name | An unconfirmed plan is not split |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the plan on the ticket has not been confirmed |
| When | "/aa-ip-breakdown-tasks" starts |
| Then | no tasks are created |
| And | the ticket says the plan must be confirmed first |

## F-046-03 Every task maps to plan steps and names its test

| Scenario | F-046-03 |
| --- | --- |
| Name | Every task maps to plan steps and names its test |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ip-breakdown-tasks" cuts the tasks |
| Then | each task names the plan steps it covers and the test that proves it |
| And | each task is sized so that its first commit is an hour away, not a day |

## F-046-04 Order and dependencies are explicit

| Scenario | F-046-04 |
| --- | --- |
| Name | Order and dependencies are explicit |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ip-breakdown-tasks" orders the tasks |
| Then | the tasks follow the plan's build order so that stopping after any task leaves the system working |
| And | every dependency between tasks is recorded as a link or an ordered checklist entry |

## F-046-05 The tasks add up to the whole plan

| Scenario | F-046-05 |
| --- | --- |
| Name | The tasks add up to the whole plan |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plan step is covered by no task |
| When | "/aa-ip-breakdown-tasks" checks the sum |
| Then | a task is added for it or the plan is changed on the ticket |
| And | nothing is left implicit |

## F-046-06 Done means the test passes and the change is committed

| Scenario | F-046-06 |
| --- | --- |
| Name | Done means the test passes and the change is committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ip-breakdown-tasks" creates a task |
| Then | the task states that it is done when its test passes and its change is committed |
| And | the tasks are children or a checklist of the anchor ticket, each linked back to it |

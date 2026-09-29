# F-013 /aa-dev-optimize improves performance against a measured baseline

| Feature | F-013 |
| --- | --- |
| Name | /aa-dev-optimize improves performance against a measured baseline |
| Tags | @agent @development @O-19 |
| File | optimize |

Reproduce the baseline, profile, change the one thing the profile says, measure again with
the same method, and keep the change only if the number improved and the full suite still
passes, with every round recorded on the ticket.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a performance ticket with a target metric and a baseline from performance-test |

## F-013-01 No baseline, no optimisation

| Scenario | F-013-01 |
| --- | --- |
| Name | No baseline, no optimisation |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket names a target but records no measured baseline or method |
| When | "/aa-dev-optimize" starts |
| Then | it asks for a baseline measured with a tool and the method that produced it |
| And | no code is changed until one exists |

## F-013-02 The baseline is reproduced before any change

| Scenario | F-013-02 |
| --- | --- |
| Name | The baseline is reproduced before any change |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-optimize" starts |
| Then | it runs the recorded method at the head with the same data volume and load profile |
| And | the number and the environment are recorded on the ticket |
| And | a baseline that does not reproduce is recorded as the first finding |

## F-013-03 The profile decides what changes

| Scenario | F-013-03 |
| --- | --- |
| Name | The profile decides what changes |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-optimize" chooses a change |
| Then | the profile's top findings are on the ticket |
| And | the change targets what the profile named |

## F-013-04 One change per measurement

| Scenario | F-013-04 |
| --- | --- |
| Name | One change per measurement |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-optimize" makes a change |
| Then | exactly one thing changed since the previous measurement |
| And | the before, after, and computed difference are recorded on the ticket |

## F-013-05 A change that did not help is reverted and recorded

| Scenario | F-013-05 |
| --- | --- |
| Name | A change that did not help is reverted and recorded |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a change whose measurement did not improve |
| When | "/aa-dev-optimize" measures it |
| Then | the change is reverted |
| And | the attempt and its number are on the ticket |

## F-013-06 A faster wrong answer is a defect

| Scenario | F-013-06 |
| --- | --- |
| Name | A faster wrong answer is a defect |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a change that improved the metric and broke a test |
| When | "/aa-dev-optimize" runs the full suite |
| Then | the change is not kept |
| And | no test is adjusted, skipped, or retried to keep it |

## F-013-07 The change stays inside the ticket

| Scenario | F-013-07 |
| --- | --- |
| Name | The change stays inside the ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent notices unrelated code it could tidy while profiling |
| When | "/aa-dev-optimize" continues |
| Then | the unrelated change is not made on this branch |
| And | a ticket is raised for it or it is left alone |

## F-013-08 The change is staged and presented, never committed

| Scenario | F-013-08 |
| --- | --- |
| Name | The change is staged and presented, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-optimize" finishes |
| Then | the change is on a branch that references the ticket with the full suite passing and its output quoted |
| And | it is staged with a perf-typed Conventional Commit message naming the ticket |
| And | no commit is made unless the user asked for that commit |
| And | the ticket holds the baseline, each change, the after measurement, and the method |

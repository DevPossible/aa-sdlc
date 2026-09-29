# F-056 /aa-pm-retrospective turns the record of a period into a few improvements with owners

| Feature | F-056 |
| --- | --- |
| Name | /aa-pm-retrospective turns the record of a period into a few improvements with owners |
| Tags | @agent @project-management @O-18 @T-07 @T-13 |
| File | retrospective |

Look at what actually happened in an iteration, release, or quarter, using the record rather
than recollection, and turn it into a small number of concrete improvements, each a decision
record and a ticket with an owner and a way to tell whether it worked.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a completed iteration with ticket history and a previous retrospective in the knowledge base |

## F-056-01 The last retrospective's changes are checked first

| Scenario | F-056-01 |
| --- | --- |
| Name | The last retrospective's changes are checked first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the previous retrospective raised improvement tickets |
| When | "/aa-pm-retrospective" starts |
| Then | the state of each of those tickets is read |
| And | any that was not done is recorded as the first finding |

## F-056-02 The numbers come before the opinions

| Scenario | F-056-02 |
| --- | --- |
| Name | The numbers come before the opinions |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-retrospective" measures the period |
| Then | cycle times, carry-over, reopened tickets, and blockers are computed from the ticket history with a tool |
| And | the report states what the data shows before what people felt |
| And | the two are kept distinct |

## F-056-03 Input from people is recorded as what people felt

| Scenario | F-056-03 |
| --- | --- |
| Name | Input from people is recorded as what people felt |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user provides input from the people involved |
| When | "/aa-pm-retrospective" records it |
| Then | it appears after the numbers, marked as what people felt |
| And | a disagreement between the data and the input is recorded as a finding |

## F-056-04 Three to keep and three to change

| Scenario | F-056-04 |
| --- | --- |
| Name | Three to keep and three to change |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-retrospective" draws conclusions |
| Then | the report names the top three things to keep and the top three to change |
| And | each names the evidence that put it on the list |
| And | no more than three changes become actions |

## F-056-05 Each change is a decision record

| Scenario | F-056-05 |
| --- | --- |
| Name | Each change is a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-retrospective" records a change |
| Then | a decision record is written, numbered next in the repository's sequence and dated |
| And | it states the context, the options considered, the decision, and its consequences |
| And | it is linked from the anchor ticket |

## F-056-06 Each change is a ticket with an owner and a measure

| Scenario | F-056-06 |
| --- | --- |
| Name | Each change is a ticket with an owner and a measure |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pm-retrospective" raises the improvement backlog |
| Then | every change is a ticket in the configured ticket project with an owner |
| And | each ticket says how the next retrospective will tell whether it worked |

## F-056-07 Records in the repository are staged, not committed

| Scenario | F-056-07 |
| --- | --- |
| Name | Records in the repository are staged, not committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project keeps decision records in the documents folder |
| When | "/aa-pm-retrospective" finishes |
| Then | the new records are staged and presented with a Conventional Commit message |
| And | no commit is made unless the user asked for that commit |

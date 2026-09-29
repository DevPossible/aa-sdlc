# F-075 /aa-ta-spike answers a technical question inside a time box

| Feature | F-075 |
| --- | --- |
| Name | /aa-ta-spike answers a technical question inside a time box |
| Tags | @agent @technical-analysis @O-18 |
| File | spike |

Resolve a technical unknown with a time-boxed investigation whose artifact is the finding on
the ticket, not the code. Throwaway code stays on its own branch, clearly marked, and a
finding that decides something becomes a decision record.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket stating a technical question and a time box |

## F-075-01 The question is written before the code

| Scenario | F-075-01 |
| --- | --- |
| Name | The question is written before the code |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket names a question but not what would answer it |
| When | "/aa-ta-spike" starts |
| Then | it writes on the ticket what evidence would answer the question |
| And | no code is written until the question and the time box are on the ticket |

## F-075-02 The time box is stated and kept

| Scenario | F-075-02 |
| --- | --- |
| Name | The time box is stated and kept |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-spike" reaches the time box with the question unanswered |
| Then | it stops |
| And | the finding on the ticket says what was tried, what was learned, and what would answer the question |

## F-075-03 Spike code never reaches the main branch

| Scenario | F-075-03 |
| --- | --- |
| Name | Spike code never reaches the main branch |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-spike" writes code |
| Then | the code is on a branch named for the ticket and marked as spike code |
| And | it is not merged to the main branch |

## F-075-04 The finding quotes evidence

| Scenario | F-075-04 |
| --- | --- |
| Name | The finding quotes evidence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-spike" records the finding |
| Then | the finding answers the stated question |
| And | the actual output of what was run is quoted rather than described |
| And | the finding says what to do next |

## F-075-05 A finding that decides something becomes a decision record

| Scenario | F-075-05 |
| --- | --- |
| Name | A finding that decides something becomes a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the spike settles which of two approaches to take |
| When | "/aa-ta-spike" records the finding |
| Then | a decision record is written, numbered next in the sequence and dated, naming both approaches |
| And | the record is linked from the ticket |

## F-075-06 Keeping the spike code is a decision and a ticket

| Scenario | F-075-06 |
| --- | --- |
| Name | Keeping the spike code is a decision and a ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the spike code appears good enough to keep |
| When | "/aa-ta-spike" finishes |
| Then | that is recorded as a decision and a ticket to implement it properly |
| And | the spike branch is staged and presented with no commit unless the user asked for it |

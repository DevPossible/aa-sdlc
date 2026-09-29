# F-053 /aa-pd-iterate turns feedback into decisions and a roadmap update

| Feature | F-053 |
| --- | --- |
| Name | /aa-pd-iterate turns feedback into decisions and a roadmap update |
| Tags | @agent @product-management @O-18 |
| File | iterate |

Group what users, support, and production are saying into themes with computed counts,
decide for each theme whether to enhance, fix, stop, or wait, write the analysis in the
knowledge base, and update the roadmap with a ticket for every decision to build.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | user feedback, support tickets, a post-mortem, and production metrics for a released feature |

## F-053-01 Feedback is grouped by theme with computed counts

| Scenario | F-053-01 |
| --- | --- |
| Name | Feedback is grouped by theme with computed counts |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-iterate" analyses the feedback |
| Then | every item is placed in a theme by what the user was trying to do |
| And | each theme carries a count and its sources computed with a tool, not estimated |

## F-053-02 Signal outranks volume and says so

| Scenario | F-053-02 |
| --- | --- |
| Name | Signal outranks volume and says so |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | one report concerns a critical workflow and twenty concern a cosmetic one |
| When | "/aa-pd-iterate" ranks the themes |
| Then | the critical theme may rank first |
| And | the analysis says explicitly that it was ranked that way and why |

## F-053-03 Every theme has a decision with a reason

| Scenario | F-053-03 |
| --- | --- |
| Name | Every theme has a decision with a reason |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-iterate" writes the analysis |
| Then | each theme has one decision: enhance, fix, stop, or wait |
| And | each decision names the outcome or metric it serves |

## F-053-04 The analysis lives in the knowledge base

| Scenario | F-053-04 |
| --- | --- |
| Name | The analysis lives in the knowledge base |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-iterate" finishes the analysis |
| Then | the product feedback analysis is a page in the knowledge base linked from the roadmap epic |
| And | it can be read by someone who was not in the session |

## F-053-05 Decisions become tickets

| Scenario | F-053-05 |
| --- | --- |
| Name | Decisions become tickets |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a theme is decided as enhance and another as stop |
| When | "/aa-pd-iterate" updates the roadmap |
| Then | the enhance decision has a new ticket |
| And | the stop decision has a closed ticket with the reason on it |

## F-053-06 The loop is closed on the source ticket

| Scenario | F-053-06 |
| --- | --- |
| Name | The loop is closed on the source ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | feedback came from a support ticket |
| When | "/aa-pd-iterate" records the decision for its theme |
| Then | a comment on that support ticket states the decision and links to the analysis |

## F-053-07 A change of roadmap direction is a decision record

| Scenario | F-053-07 |
| --- | --- |
| Name | A change of roadmap direction is a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stop decision changes the roadmap |
| When | "/aa-pd-iterate" records it |
| Then | a decision record is written, numbered next in the repository's sequence, and linked from the epic |
| And | the record is staged and presented, not committed |

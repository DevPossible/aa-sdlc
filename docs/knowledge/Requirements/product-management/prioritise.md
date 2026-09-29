# F-054 /aa-pd-prioritise orders the backlog and records why

| Feature | F-054 |
| --- | --- |
| Name | /aa-pd-prioritise orders the backlog and records why |
| Tags | @agent @product-management @O-18 |
| File | prioritise |

Order epics and stories by contribution to the outcome, then risk, then cost, rank blocked
items after what blocks them, and record every move as a comment on the ticket. The ordered
backlog lives in the ticket system; the reasoning lives on the tickets.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a backlog of epics and stories in the ticket system with outcomes defined |

## F-054-01 Every item gets a rank and a reason

| Scenario | F-054-01 |
| --- | --- |
| Name | Every item gets a rank and a reason |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-prioritise" orders the backlog |
| Then | every item has a rank |
| And | every item has a one-line reason on its ticket naming the outcome it serves |

## F-054-02 Blocked items rank after what blocks them

| Scenario | F-054-02 |
| --- | --- |
| Name | Blocked items rank after what blocks them |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a story depends on another story that is not yet done |
| When | "/aa-pd-prioritise" orders the backlog |
| Then | the dependent story is ranked after the story it depends on |
| And | the dependency is a link between the tickets, not prose |

## F-054-03 Nothing is reordered silently

| Scenario | F-054-03 |
| --- | --- |
| Name | Nothing is reordered silently |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a story moves from fifth to second |
| When | "/aa-pd-prioritise" applies the new order |
| Then | a comment on that ticket says what moved and why |

## F-054-04 An ungrounded size is not treated as a size

| Scenario | F-054-04 |
| --- | --- |
| Name | An ungrounded size is not treated as a size |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a story carries a number with no implementation thinking recorded on it |
| When | "/aa-pd-prioritise" ranks it |
| Then | it ranks on a range labelled as a guess |
| And | the ticket notes that the size needs grounding before an iteration is committed on it |

## F-054-05 Demoting work in progress is a conversation

| Scenario | F-054-05 |
| --- | --- |
| Name | Demoting work in progress is a conversation |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an item someone is working on would drop out of the current iteration |
| When | "/aa-pd-prioritise" reaches it |
| Then | it stops and asks before changing the rank |

## F-054-06 Demoting committed work is a decision record

| Scenario | F-054-06 |
| --- | --- |
| Name | Demoting committed work is a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | committed work is demoted with the user's agreement |
| When | "/aa-pd-prioritise" applies the demotion |
| Then | a decision record is written, numbered next in the repository's sequence, and linked from the ticket |
| And | the record is staged and presented, not committed |

## F-054-07 The top of the backlog is not raw ideas

| Scenario | F-054-07 |
| --- | --- |
| Name | The top of the backlog is not raw ideas |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a raw idea ranks high on value |
| When | "/aa-pd-prioritise" checks the top of the backlog |
| Then | the idea is sent to refinement with a note on its ticket |
| And | the top of the backlog contains only items that are ready or in refinement |

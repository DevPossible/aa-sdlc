# F-088 /aa-pd-amend-doctrines changes one doctrine, from evidence, with a record

| Feature | F-088 |
| --- | --- |
| Name | /aa-pd-amend-doctrines changes one doctrine, from evidence, with a record |
| Tags | @agent @product-management @O-28 @O-18 |
| File | amend-doctrines |

Add, change, or retire one doctrine or non-goal, from evidence, with a decision record that
states it before and after and what it invalidates. Ids are permanent: a new doctrine takes
the next free id, a changed one keeps its id, and a retired one is marked and kept.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" with a linked knowledge base |
| And | the product's doctrines page holds doctrines D-01 to D-04 |

## F-088-01 A new doctrine takes the next free id

| Scenario | F-088-01 |
| --- | --- |
| Name | A new doctrine takes the next free id |
| Kind | Scenario |
| Tags | @G-58 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-amend-doctrines" adds a doctrine and I confirm it |
| Then | the new doctrine is D-05 |
| And | a decision record states the evidence, the options considered, and the consequences |
| And | the page links the record beside the doctrine |

## F-088-02 A retired doctrine keeps its id

| Scenario | F-088-02 |
| --- | --- |
| Name | A retired doctrine keeps its id |
| Kind | Scenario |
| Tags | @G-58 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-amend-doctrines" retires D-02 and I confirm it |
| Then | D-02 is marked retired and still on the page |
| And | no later doctrine is renumbered |
| And | the decision record that retired it is linked |

## F-088-03 What the amendment invalidates is raised, not changed

| Scenario | F-088-03 |
| --- | --- |
| Name | What the amendment invalidates is raised, not changed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | open tickets and approved scenarios cite D-03 |
| When | "/aa-pd-amend-doctrines" changes D-03 and I confirm it |
| Then | the decision record lists each item that cited D-03 and whether it still holds |
| And | each item that no longer holds gets a question on its ticket |
| And | none of those items is changed by this step |

## F-088-04 Convenience is not evidence

| Scenario | F-088-04 |
| --- | --- |
| Name | Convenience is not evidence |
| Kind | Scenario |
| Tags | @G-57 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the only reason given for changing D-01 is that a requirement in hand conflicts with it |
| When | I run "/aa-pd-amend-doctrines" |
| Then | it says the change has no evidence beyond the requirement |
| And | it recommends changing the requirement instead |
| And | it changes no doctrine unless I still confirm the amendment |

## F-088-05 Nothing is written before I confirm

| Scenario | F-088-05 |
| --- | --- |
| Name | Nothing is written before I confirm |
| Kind | Scenario |
| Tags | @T-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-amend-doctrines" proposes an amendment and I decline it |
| Then | the doctrines page is unchanged |
| And | no decision record is written |

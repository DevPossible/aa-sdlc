# F-087 Every product has doctrines, and every requirement is checked against them

| Feature | F-087 |
| --- | --- |
| Name | Every product has doctrines, and every requirement is checked against them |
| Tags | @framework @agent @O-28 @O-18 @T-03 @T-07 |
| File | doctrines |

Every product has one set of doctrines on a page in the Overview section of its knowledge base:
a one-sentence mission, who the product is for, a small number of doctrines each with a
permanent D-nn id, and its non-goals. Outcomes, scenarios, architecture, decision records, the
order of the backlog, and merge requests are checked against them and cite the doctrine they
serve or are bounded by. A conflict is never absorbed silently: the work changes, or the
doctrines are amended from evidence with a decision record. No step blocks when there are none.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" with a linked knowledge base |

## F-087-01 An outcome cites the doctrine it serves

| Scenario | F-087-01 |
| --- | --- |
| Name | An outcome cites the doctrine it serves |
| Kind | Scenario |
| Tags | @G-57 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the product's doctrines page holds a mission, doctrines D-01 to D-04, and non-goals |
| When | "/aa-pd-define-outcome" writes the anchor epic |
| Then | the epic names the doctrines its outcome serves by their ids |
| And | the epic says it conflicts with no doctrine or non-goal |

## F-087-02 A scenario that conflicts with a non-goal is raised, not absorbed

| Scenario | F-087-02 |
| --- | --- |
| Name | A scenario that conflicts with a non-goal is raised, not absorbed |
| Kind | Scenario |
| Tags | @G-57 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the product's doctrines list a non-goal |
| And | a stakeholder asks for a behaviour the non-goal excludes |
| When | "/aa-ba-refine-requirements" refines the scenario for it |
| Then | it names the non-goal and the conflict on the ticket |
| And | it does not mark the scenario Approved until the user decides to change the scenario or to propose an amendment |

## F-087-03 A conflicting decision is checked the same way

| Scenario | F-087-03 |
| --- | --- |
| Name | A conflicting decision is checked the same way |
| Kind | Scenario |
| Tags | @G-57 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the product's doctrines include a doctrine that a proposed technical option contradicts |
| When | "/aa-ta-decide" records the decision |
| Then | the decision record names the doctrine among the reasons for the option chosen or rejected |
| And | a choice that contradicts the doctrine is recorded only with an amendment the user agreed to |

## F-087-04 The doctrines are amended deliberately, with a record

| Scenario | F-087-04 |
| --- | --- |
| Name | The doctrines are amended deliberately, with a record |
| Kind | Scenario |
| Tags | @G-58 @O-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | feedback from production shows a doctrine no longer describes what the product is for |
| When | "/aa-pd-iterate" proposes an amendment and the user agrees |
| Then | a decision record states what changed in the doctrines and why |
| And | a new doctrine takes the next free D-nn id |
| And | a doctrine it replaces is marked retired and keeps its id |

## F-087-05 No doctrines does not block a step

| Scenario | F-087-05 |
| --- | --- |
| Name | No doctrines does not block a step |
| Kind | Scenario |
| Tags | @T-03 @G-57 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the product has no doctrines page |
| When | "/aa-ba-discover" runs for a ticket |
| Then | it produces its draft scenarios and question log |
| And | it says the doctrine check was made against nothing |

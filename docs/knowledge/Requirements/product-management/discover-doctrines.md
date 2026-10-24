# F-091 /aa-pd-discover-doctrines proposes doctrines from what the project already shows

| Feature | F-091 |
| --- | --- |
| Name | /aa-pd-discover-doctrines proposes doctrines from what the project already shows |
| Tags | @agent @product-management @O-28 |
| File | discover-doctrines |

Read an existing product's code, documents, decision records, knowledge base pages, and
tickets, and propose a mission, who it is for, candidate doctrines, and non-goals, each with
the evidence it was drawn from. It proposes; it writes no doctrine and assigns no id.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" with a linked knowledge base |
| And | the product has no doctrines page |

## F-091-01 Every proposal names its evidence

| Scenario | F-091-01 |
| --- | --- |
| Name | Every proposal names its evidence |
| Kind | Scenario |
| Tags | @G-58 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a repository with a README, decision records, and code, and a ticket project with epics |
| When | I run "/aa-pd-discover-doctrines" |
| Then | it proposes a mission, who the product is for, candidate doctrines, and non-goals |
| And | each proposal names the file, decision record, page, or ticket it was drawn from |
| And | each proposal is marked stated or inferred |

## F-091-02 Non-goals come from what was deliberately left out

| Scenario | F-091-02 |
| --- | --- |
| Name | Non-goals come from what was deliberately left out |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a decision record that rejected an option and tickets closed as out of scope |
| When | I run "/aa-pd-discover-doctrines" |
| Then | the proposed non-goals cite that decision record and those tickets |

## F-091-03 Contradictions are listed, not resolved

| Scenario | F-091-03 |
| --- | --- |
| Name | Contradictions are listed, not resolved |
| Kind | Scenario |
| Tags | @G-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the README states an aim that the code contradicts |
| When | I run "/aa-pd-discover-doctrines" |
| Then | the proposal lists the contradiction with the evidence on both sides |
| And | neither side is proposed as a doctrine |

## F-091-04 It writes no doctrine

| Scenario | F-091-04 |
| --- | --- |
| Name | It writes no doctrine |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-discover-doctrines" finishes |
| Then | no doctrines page was created or changed |
| And | no D-nn id was assigned |
| And | it recommends "/aa-pd-define-doctrines" to adopt the proposal |

## F-091-05 With an anchor ticket the proposal is written on it

| Scenario | F-091-05 |
| --- | --- |
| Name | With an anchor ticket the proposal is written on it |
| Kind | Scenario |
| Tags | @G-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket for writing the product's doctrines |
| When | I run "/aa-pd-discover-doctrines" with the ticket id |
| Then | the proposal is written on the ticket |

## F-091-06 A blank project has nothing to discover

| Scenario | F-091-06 |
| --- | --- |
| Name | A blank project has nothing to discover |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a blank repository and an empty ticket project |
| When | I run "/aa-pd-discover-doctrines" |
| Then | it says there was nothing to read |
| And | it recommends "/aa-pd-define-doctrines", which asks |

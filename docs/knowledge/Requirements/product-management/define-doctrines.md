# F-090 /aa-pd-define-doctrines writes the product's first set of doctrines

| Feature | F-090 |
| --- | --- |
| Name | /aa-pd-define-doctrines writes the product's first set of doctrines |
| Tags | @agent @product-management @O-28 @O-18 |
| File | define-doctrines |

Write the product's first set of doctrines with the user, from a discovered proposal or from
the user's answers: a one-sentence mission, who it is for, doctrines numbered from D-01, and
the non-goals, on a page in the Overview section, holding only what the user confirmed, with a
decision record for the adoption.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" with a linked knowledge base |

## F-090-01 Adopt a discovered proposal

| Scenario | F-090-01 |
| --- | --- |
| Name | Adopt a discovered proposal |
| Kind | Scenario |
| Tags | @G-58 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a proposal from "/aa-pd-discover-doctrines" |
| When | I run "/aa-pd-define-doctrines" |
| Then | it walks me through each proposal to accept, edit, or drop |
| And | the doctrines page holds only what I confirmed |
| And | the doctrines are numbered from D-01, each with why it holds |

## F-090-02 Ask where there is nothing to read

| Scenario | F-090-02 |
| --- | --- |
| Name | Ask where there is nothing to read |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a blank repository and an empty ticket project |
| When | I run "/aa-pd-define-doctrines" |
| Then | it asks one question at a time for the mission, who the product is for, what it must always do, and what it must never become |
| And | it writes the page once I confirm the whole set |

## F-090-03 The page lives in the Overview section

| Scenario | F-090-03 |
| --- | --- |
| Name | The page lives in the Overview section |
| Kind | Scenario |
| Tags | @G-53 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-define-doctrines" writes the doctrines |
| Then | the page is in the Overview section under the project's knowledge root |
| And | it records the date the set was adopted |

## F-090-04 The adoption is a decision record

| Scenario | F-090-04 |
| --- | --- |
| Name | The adoption is a decision record |
| Kind | Scenario |
| Tags | @G-41 @O-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-define-doctrines" writes the doctrines |
| Then | a decision record numbered next in the sequence records the adoption and the candidates I rejected |
| And | the page and the anchor ticket link to it |

## F-090-05 An existing set is never overwritten

| Scenario | F-090-05 |
| --- | --- |
| Name | An existing set is never overwritten |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the product already has a doctrines page |
| When | I run "/aa-pd-define-doctrines" |
| Then | it changes nothing |
| And | it recommends "/aa-pd-amend-doctrines" |

## F-090-06 No knowledge base in scope

| Scenario | F-090-06 |
| --- | --- |
| Name | No knowledge base in scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no knowledge base is in scope |
| When | "/aa-pd-define-doctrines" writes the doctrines |
| Then | the page is written in the documents folder's knowledge folder in the same format |

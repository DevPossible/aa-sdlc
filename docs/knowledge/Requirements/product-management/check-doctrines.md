# F-089 /aa-pd-check-doctrines reports what conflicts with the doctrines

| Feature | F-089 |
| --- | --- |
| Name | /aa-pd-check-doctrines reports what conflicts with the doctrines |
| Tags | @agent @product-management @O-28 @T-03 |
| File | check-doctrines |

Read the doctrines and report every open ticket, approved scenario, and decision record that
conflicts with a doctrine or non-goal, the doctrines nothing cites, and the epics that cite no
doctrine, with one recommended command per conflict. It changes nothing.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" with a linked knowledge base |

## F-089-01 A conflict is reported as a specific pair

| Scenario | F-089-01 |
| --- | --- |
| Name | A conflict is reported as a specific pair |
| Kind | Scenario |
| Tags | @G-57 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an open ticket asks for a behaviour a non-goal excludes |
| When | I run "/aa-pd-check-doctrines" |
| Then | the report names the ticket, the non-goal, and the sentence in each that disagrees |
| And | it recommends one command for the conflict with the ticket id |

## F-089-02 What nothing cites is reported

| Scenario | F-089-02 |
| --- | --- |
| Name | What nothing cites is reported |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no ticket, scenario, or decision record cites D-04 |
| And | an open epic cites no doctrine |
| When | I run "/aa-pd-check-doctrines" |
| Then | the report lists D-04 as cited by nothing |
| And | it lists the epic as citing no doctrine |

## F-089-03 It changes nothing

| Scenario | F-089-03 |
| --- | --- |
| Name | It changes nothing |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-check-doctrines" finishes with conflicts found |
| Then | no ticket, page, or decision record was edited, commented on, or transitioned |

## F-089-04 An unread source is not reported clean

| Scenario | F-089-04 |
| --- | --- |
| Name | An unread source is not reported clean |
| Kind | Scenario |
| Tags | @T-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket system is out of reach |
| When | I run "/aa-pd-check-doctrines" |
| Then | the report says the tickets could not be read and why |
| And | it still checks the scenarios and decision records |

## F-089-05 No doctrines to check against

| Scenario | F-089-05 |
| --- | --- |
| Name | No doctrines to check against |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the product has no doctrines page |
| When | I run "/aa-pd-check-doctrines" |
| Then | it reports that alone |
| And | it recommends "/aa-pd-discover-doctrines" for a project with anything to read, or "/aa-pd-define-doctrines" for a new one |

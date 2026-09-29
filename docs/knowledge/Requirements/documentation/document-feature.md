# F-016 /aa-doc-document-feature documents a ticket from its scenarios

| Feature | F-016 |
| --- | --- |
| Name | /aa-doc-document-feature documents a ticket from its scenarios |
| Tags | @agent @documentation @O-16 |
| File | document-feature |

Write or update the user-facing and developer-facing documentation for a ticket, written
from its scenarios and verified against the running software, in the places the project
keeps each kind, linked from the ticket and the feature's knowledge base page.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket whose change has merged, with scenarios and configured documentation locations |

## F-016-01 Documentation is written where the project keeps it

| Scenario | F-016-01 |
| --- | --- |
| Name | Documentation is written where the project keeps it |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-doc-document-feature" starts |
| Then | it reads the documentation locations from the project config or the knowledge base |
| And | developer documentation goes in the documents folder |
| And | user documentation goes in the knowledge base or the configured user documentation location |
| And | no new location is invented |

## F-016-02 The feature is run before it is described

| Scenario | F-016-02 |
| --- | --- |
| Name | The feature is run before it is described |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-doc-document-feature" writes the user documentation |
| Then | it has walked each scenario against the running software |
| And | a user can do what each scenario describes by following the documentation |

## F-016-03 The software and a scenario disagree

| Scenario | F-016-03 |
| --- | --- |
| Name | The software and a scenario disagree |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the running software does not do what a scenario says |
| When | "/aa-doc-document-feature" finds this |
| Then | a question naming the difference is on the ticket |
| And | the documentation describes what the scenario says, not what the software does |

## F-016-04 Scenarios are linked or embedded, never restated

| Scenario | F-016-04 |
| --- | --- |
| Name | Scenarios are linked or embedded, never restated |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-doc-document-feature" refers to a scenario |
| Then | the documentation links to or embeds the scenario |
| And | no prose copy of the scenario exists |

## F-016-05 The unhappy path is documented

| Scenario | F-016-05 |
| --- | --- |
| Name | The unhappy path is documented |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario describes what happens when the feature goes wrong |
| When | "/aa-doc-document-feature" writes the user documentation |
| Then | the documentation says what the user sees and what to do next |

## F-016-06 A developer can find the feature and its tests

| Scenario | F-016-06 |
| --- | --- |
| Name | A developer can find the feature and its tests |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-doc-document-feature" writes the developer documentation |
| Then | it names where the feature lives, its configuration keys and environment templates, and any migration |
| And | it names how the feature is tested at each tier and how to run those tests from the root test script |

## F-016-07 The change is staged, linked, and presented, never committed

| Scenario | F-016-07 |
| --- | --- |
| Name | The change is staged, linked, and presented, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-doc-document-feature" finishes |
| Then | the documentation links to the ticket and the feature's knowledge base page and both link back |
| And | the changes are staged as one change set with a docs-typed Conventional Commit message naming the ticket |
| And | no commit is made unless the user asked for that commit |

# F-012 /aa-dev-implement builds a ticket with the tests that prove it

| Feature | F-012 |
| --- | --- |
| Name | /aa-dev-implement builds a ticket with the tests that prove it |
| Tags | @agent @development @O-08 @O-13 @O-17 @O-19 |
| File | implement |

Build what the anchor ticket asks for, following the confirmed plan, on a branch that
references the ticket, with unit, integration, and happy-path end-to-end tests for every
scenario, stopping at every green to stage and present rather than commit.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ready ticket with linked scenarios and a confirmed implementation plan |

## F-012-01 The repository is checked before any code is written

| Scenario | F-012-01 |
| --- | --- |
| Name | The repository is checked before any code is written |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket records the revision it was planned against |
| When | "/aa-dev-implement" starts |
| Then | it compares that revision with the head for the linked feature files and the planned files |
| And | it records the result on the ticket before writing code |

## F-012-02 A changed scenario sends the ticket back

| Scenario | F-012-02 |
| --- | --- |
| Name | A changed scenario sends the ticket back |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a linked scenario changed since the recorded revision |
| When | "/aa-dev-implement" starts |
| Then | it writes a question on the ticket naming the change |
| And | it does not write code until the question is answered |

## F-012-03 Tests come first and prove every scenario

| Scenario | F-012-03 |
| --- | --- |
| Name | Tests come first and prove every scenario |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-implement" builds a plan step |
| Then | a failing test for the scenario exists before the code that passes it |
| And | when the ticket is reported done every scenario has unit, integration, and happy-path end-to-end tests as the change warrants |
| And | the build and every touched tier were run and their output quoted |

## F-012-04 Every green is staged and presented, never committed

| Scenario | F-012-04 |
| --- | --- |
| Name | Every green is staged and presented, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-implement" reaches a green build |
| Then | the changed files are formatted and the lint switch passes |
| And | the change is staged with a Conventional Commit message naming the ticket |
| And | no commit is made unless the user asked for that commit |

## F-012-05 The change stays inside the ticket

| Scenario | F-012-05 |
| --- | --- |
| Name | The change stays inside the ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent notices unrelated code it could improve |
| When | "/aa-dev-implement" continues |
| Then | the unrelated change is not made on this branch |
| And | a ticket is raised for it or it is left alone |

## F-012-06 A plan that meets reality and loses is updated first

| Scenario | F-012-06 |
| --- | --- |
| Name | A plan that meets reality and loses is updated first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plan step cannot be done as written |
| When | "/aa-dev-implement" discovers this |
| Then | it updates the plan on the ticket with the reason before continuing |
| And | it does not improvise silently |

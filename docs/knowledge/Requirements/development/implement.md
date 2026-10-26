# F-012 /aa-dev-implement builds a ticket with the tests that prove it

| Feature | F-012 |
| --- | --- |
| Name | /aa-dev-implement builds a ticket with the tests that prove it |
| Tags | @agent @development @O-08 @O-13 @O-17 @O-19 |
| File | implement |

Build what the anchor ticket asks for, following the confirmed plan, on a branch that
references the ticket, with tests at justified tiers. One approved brief covers the loop;
coherent checkpoints honor explicit task commit permission without stopping at every green.

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
| Given | a linked scenario materially conflicts with the approved brief since the recorded revision |
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
| Then | meaningful failing behavior is established and tests and implementation evolve together |
| And | the named real collaborator is exercised after the first focused behavior before broad private test expansion |
| And | every delivered scenario has passing tests at justified tiers and all promised cases remain required |
| And | the affected build and relevant tiers were run with their actual output linked |

## F-012-04 Coherent checkpoints respect existing authorization

| Scenario | F-012-04 |
| --- | --- |
| Name | Coherent checkpoints respect existing authorization |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-implement" reaches a coherent checkpoint |
| Then | the changed files are formatted and the lint switch passes |
| And | the change is staged with a Conventional Commit message naming the ticket |
| And | only task-owned changes are committed under existing explicit permission, or presented without committing |
| And | a focused green check alone does not stop implementation for another approval |

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

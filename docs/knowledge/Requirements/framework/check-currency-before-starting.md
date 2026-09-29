# F-019 A refined ticket is checked against the repository before work starts

| Feature | F-019 |
| --- | --- |
| Name | A refined ticket is checked against the repository before work starts |
| Tags | @framework @agent @O-13 @T-12 @T-03 |
| File | check-currency-before-starting |

Refinement has a shelf life. A ticket records the repository revision its scenarios and plan
were checked against. The step that picks it up compares that revision with the repository
as it is now, records whether the requirement and the plan still hold, and sends any
conflict back to refinement rather than building on it. The framework does not gate; the
step performs the check as its first act.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ready ticket with linked scenarios and a confirmed implementation plan |

## F-019-01 Refinement and planning record the revision

| Scenario | F-019-01 |
| --- | --- |
| Name | Refinement and planning record the revision |
| Kind | Scenario |
| Tags | @G-31 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rf-refine-ticket" marks the ticket ready |
| Then | the ticket records the repository revision its scenarios were checked against |
| When | "/aa-ip-plan-implementation" confirms the plan |
| Then | the ticket records the repository revision the plan was written against |

## F-019-02 Nothing the ticket touches has changed

| Scenario | F-019-02 |
| --- | --- |
| Name | Nothing the ticket touches has changed |
| Kind | Scenario |
| Tags | @G-32 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no commit since the recorded revision touches the linked feature files or the files the plan names |
| When | "/aa-dev-implement" starts the ticket |
| Then | the check is recorded on the ticket as current, naming the revisions compared |
| And | work proceeds from the plan |

## F-019-03 A linked feature file changed since refinement

| Scenario | F-019-03 |
| --- | --- |
| Name | A linked feature file changed since refinement |
| Kind | Scenario |
| Tags | @G-32 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit since the recorded revision changed a scenario the ticket links |
| When | "/aa-dev-implement" starts the ticket |
| Then | the check lists the changed scenario and the commit that changed it |
| And | a question is added to the ticket asking whether the requirement still holds |
| And | the ticket is handed back to refinement |
| And | no code is written for it until the question is answered |

## F-019-04 The code the plan names has moved

| Scenario | F-019-04 |
| --- | --- |
| Name | The code the plan names has moved |
| Kind | Scenario |
| Tags | @G-32 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit since the recorded revision removed or reshaped a file the plan names |
| When | "/aa-dev-implement" starts the ticket |
| Then | the check lists the file and what changed |
| And | the plan is marked as needing revision on the ticket |
| And | "/aa-ip-plan-implementation" is run again before any code is written |

## F-019-05 A defect ticket is checked the same way

| Scenario | F-019-05 |
| --- | --- |
| Name | A defect ticket is checked the same way |
| Kind | Scenario |
| Tags | @G-32 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a defect ticket that names a scenario and a suspected location |
| When | "/aa-dev-fix-bug" starts the ticket |
| Then | the check compares the revision the ticket was triaged against with the current head |
| And | changes to the named scenario or location since then are recorded on the ticket |

## F-019-06 The check never blocks silently

| Scenario | F-019-06 |
| --- | --- |
| Name | The check never blocks silently |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the repository has moved since the recorded revision |
| When | any step starts the ticket |
| Then | it says what it found and what it decided |
| And | it does not refuse to run, and it does not proceed without saying so |

## F-019-07 Health reports tickets started without a check

| Scenario | F-019-07 |
| --- | --- |
| Name | Health reports tickets started without a check |
| Kind | Scenario |
| Tags | @R-27 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | in-progress tickets in the configured project record no currency check |
| When | "/aa-fw-health" runs |
| Then | R-27 is reported as unmet with those tickets listed |

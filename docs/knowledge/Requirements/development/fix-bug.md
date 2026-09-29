# F-011 /aa-dev-fix-bug reproduces a defect before fixing its cause

| Feature | F-011 |
| --- | --- |
| Name | /aa-dev-fix-bug reproduces a defect before fixing its cause |
| Tags | @agent @development @O-23 @T-12 |
| File | fix-bug |

Reproduce a reported defect with a failing test, find the cause, fix the cause, and prove it
with the test now passing, on a branch that references the ticket.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a defect ticket with symptoms, environment, and steps to reproduce |

## F-011-01 No reproduction, no fix

| Scenario | F-011-01 |
| --- | --- |
| Name | No reproduction, no fix |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the defect cannot be reproduced from the ticket |
| When | "/aa-dev-fix-bug" runs |
| Then | the ticket records what was tried |
| And | it goes back for more information |
| And | no code is changed |

## F-011-02 The cause is found before code is touched

| Scenario | F-011-02 |
| --- | --- |
| Name | The cause is found before code is touched |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-fix-bug" investigates |
| Then | each hypothesis and its test are recorded on the ticket |
| And | after three hypotheses without evidence it stops and reassesses |

## F-011-03 The fix is proven by the test that reproduced it

| Scenario | F-011-03 |
| --- | --- |
| Name | The fix is proven by the test that reproduced it |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a failing test reproduces the defect |
| When | the fix is made |
| Then | the reproducing test passes |
| And | the full tier it lives in passes |
| And | no existing test was weakened, skipped, or retried |

## F-011-04 A defect no scenario covers gets a scenario

| Scenario | F-011-04 |
| --- | --- |
| Name | A defect no scenario covers gets a scenario |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the defect violates behaviour no scenario states |
| When | "/aa-dev-fix-bug" fixes it |
| Then | a scenario is added to the feature file with the fix |

## F-011-05 An intermittent test is controlled, not retried

| Scenario | F-011-05 |
| --- | --- |
| Name | An intermittent test is controlled, not retried |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the defect is a test that fails one run in five |
| When | "/aa-dev-fix-bug" fixes it |
| Then | the source of variance among time, randomness, state, and dependencies is named and controlled |
| And | no retry is added |

## F-011-06 The fix is staged, not committed

| Scenario | F-011-06 |
| --- | --- |
| Name | The fix is staged, not committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | the fix passes its proof |
| Then | it is staged with a fix-typed Conventional Commit message naming the ticket |
| And | no commit is made unless the user asked for that commit |

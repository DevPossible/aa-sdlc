# F-042 Development proves the requirement; Testing goes beyond it

| Feature | F-042 |
| --- | --- |
| Name | Development proves the requirement; Testing goes beyond it |
| Tags | @framework @agent @O-08 @T-07 |
| File | test-responsibility |

The Development discipline writes the automated tests that show a requirement is met. The
Testing discipline makes the suite as comprehensive as is reasonable and turns every gap it
finds into a scenario. Each has a job the other cannot do.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket with scenarios in a feature file |

## F-042-01 Implementing a ticket includes the tests that prove it

| Scenario | F-042-01 |
| --- | --- |
| Name | Implementing a ticket includes the tests that prove it |
| Kind | Scenario |
| Tags | @G-20 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-implement" runs for the ticket |
| Then | unit and integration tests exist for every happy path in the ticket's scenarios |
| And | unit and integration tests exist for the general permutations and cases |
| And | unit and integration tests exist for the obvious negative cases |
| And | a happy-path end-to-end test exists for each scenario |

## F-042-02 A ticket is not done without its tests

| Scenario | F-042-02 |
| --- | --- |
| Name | A ticket is not done without its tests |
| Kind | Scenario |
| Tags | @G-20 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the code for the ticket is written |
| And | the tests that prove it do not yet exist or do not pass |
| When | "/aa-dev-implement" reports its outcome |
| Then | the ticket is reported as not done |
| And | the missing or failing tests are named |

## F-042-03 Testing starts from the feature files

| Scenario | F-042-03 |
| --- | --- |
| Name | Testing starts from the feature files |
| Kind | Scenario |
| Tags | @G-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-qa-generate-tests" runs for the ticket |
| Then | it reads the ticket's scenarios first |
| And | it reads the tests Development already wrote |
| And | it does not duplicate them |

## F-042-04 Testing applies general strategies beyond the requirement

| Scenario | F-042-04 |
| --- | --- |
| Name | Testing applies general strategies beyond the requirement |
| Kind | Scenario |
| Tags | @G-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-qa-generate-tests" runs for the ticket |
| Then | it considers boundaries, state transitions, error and recovery paths, and concurrency |
| And | it considers realistic sequences of user interaction |
| And | it adds tests for what the requirement did not say |

## F-042-05 A gap becomes a question and a scenario

| Scenario | F-042-05 |
| --- | --- |
| Name | A gap becomes a question and a scenario |
| Kind | Scenario |
| Tags | @G-21 @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Testing finds behaviour the requirement did not specify |
| When | "/aa-qa-generate-tests" records the gap |
| Then | a question is added to the anchor ticket |
| And | a new scenario is added to the feature file, marked as pending the answer |
| And | the knowledge base page is updated when the answer is decided |

## F-042-06 Neither discipline hides a failure

| Scenario | F-042-06 |
| --- | --- |
| Name | Neither discipline hides a failure |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a test written by either discipline fails |
| When | the step reports its outcome |
| Then | the failure is reported with its output |
| And | the test is not skipped, disabled, or weakened to pass |

# F-004 /aa-ba-refine-requirements turns draft scenarios into testable ones

| Feature | F-004 |
| --- | --- |
| Name | /aa-ba-refine-requirements turns draft scenarios into testable ones |
| Tags | @agent @business-analysis @O-01 @O-15 |
| File | refine-requirements |

Close the gaps in the Draft scenarios: apply stakeholder answers to the feature page first,
split scenarios that describe two outcomes, make every step observable, approve what the
stakeholder confirms and tag it with its ticket, pull the Approved scenarios into the
repository, and record the technical constraints the scenarios must live within.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket with draft scenarios, a question log, and answers from stakeholders |

## F-004-01 An answer changes the feature page first

| Scenario | F-004-01 |
| --- | --- |
| Name | An answer changes the feature page first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a question in the log has been answered |
| When | "/aa-ba-refine-requirements" applies the answer |
| Then | the scenario on its feature page is changed first |
| And | the ticket's acceptance criteria follow from the page |
| And | the ticket is not edited before the page |
| And | no feature file is edited |

## F-004-02 Two outcomes become two scenarios

| Scenario | F-004-02 |
| --- | --- |
| Name | Two outcomes become two scenarios |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario's Then describes two outcomes that could fail independently |
| When | "/aa-ba-refine-requirements" refines it |
| Then | it is split into two scenarios, one behaviour each |

## F-004-03 Every step is observable

| Scenario | F-004-03 |
| --- | --- |
| Name | Every step is observable |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario says the feature "should work correctly" |
| When | "/aa-ba-refine-requirements" refines it |
| Then | the step is replaced with concrete Given, When, Then steps a test could observe |
| And | a step that cannot be made observable is recorded as a question on the ticket |

## F-004-04 Every scenario is linked

| Scenario | F-004-04 |
| --- | --- |
| Name | Every scenario is linked |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-refine-requirements" finishes a feature page |
| Then | every Approved scenario is tagged with its ticket |
| And | the ticket links to the feature page and the ids of its scenarios |

## F-004-05 An unanswered question stays open with an owner

| Scenario | F-004-05 |
| --- | --- |
| Name | An unanswered question stays open with an owner |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a question in the log has no answer |
| When | "/aa-ba-refine-requirements" finishes |
| Then | the question remains on the ticket as an open question with an owner |
| And | no scenario is invented to close it |

## F-004-06 A mock-up offered as an answer is evidence

| Scenario | F-004-06 |
| --- | --- |
| Name | A mock-up offered as an answer is evidence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stakeholder answered a question with a mock-up |
| When | "/aa-ba-refine-requirements" applies it |
| Then | it writes the scenario the mock-up implies |
| And | what the mock-up does not show is logged as a question |

## F-004-07 The technical constraints are recorded with their sources

| Scenario | F-004-07 |
| --- | --- |
| Name | The technical constraints are recorded with their sources |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Technical Analysis and Security have stated constraints |
| When | "/aa-ba-refine-requirements" records them |
| Then | a technical constraints document in the knowledge base lists each constraint with its source |
| And | the document is linked from the epic |
| And | a constraint that contradicts a scenario is a question on the ticket |

## F-004-08 The changes are staged and presented, never committed

| Scenario | F-004-08 |
| --- | --- |
| Name | The changes are staged and presented, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-refine-requirements" finishes |
| Then | the pulled feature files, and the changed pages where they are in the documents folder, are staged with a Conventional Commit message |
| And | no commit is made unless the user asked for that commit |

## F-004-09 Only what the stakeholder confirmed is Approved and pulled

| Scenario | F-004-09 |
| --- | --- |
| Name | Only what the stakeholder confirmed is Approved and pulled |
| Kind | Scenario |
| Tags | @G-19 @G-54 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a feature page with one scenario the stakeholder confirmed and one still in question |
| When | "/aa-ba-refine-requirements" finishes the page |
| Then | the confirmed scenario is Approved and tagged with its ticket |
| And | the scenario still in question stays Draft |
| And | the page is pulled, so only the Approved scenario reaches the features folder |

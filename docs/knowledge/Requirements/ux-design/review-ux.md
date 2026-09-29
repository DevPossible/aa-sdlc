# F-082 /aa-ux-review-ux uses the built software the way a user would

| Feature | F-082 |
| --- | --- |
| Name | /aa-ux-review-ux uses the built software the way a user would |
| Tags | @agent @ux-design @O-15 |
| File | review-ux |

Follow each scenario literally against the running feature, then wander as a user would,
record every finding with what was expected, what happened, and its severity, and route each
finding to Development as a defect or to Business Analysis as a requirement change.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket whose feature is running, with scenarios and a prototype |

## F-082-01 The scenarios are checked against the prototype before reviewing

| Scenario | F-082-01 |
| --- | --- |
| Name | The scenarios are checked against the prototype before reviewing |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario changed after the prototype was made |
| When | "/aa-ux-review-ux" starts |
| Then | it notes the changed scenario on the ticket |
| And | a difference between the prototype and the scenario is not recorded as a finding |

## F-082-02 The literal pass comes first

| Scenario | F-082-02 |
| --- | --- |
| Name | The literal pass comes first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ux-review-ux" reviews a scenario |
| Then | it does exactly the Given, When, Then as written |
| And | it compares what happened with the Then and with the mockup that names the scenario |
| And | every difference is recorded as a finding |

## F-082-03 The wander comes second

| Scenario | F-082-03 |
| --- | --- |
| Name | The wander comes second |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ux-review-ux" has completed the literal pass |
| Then | it uses the feature the way a user would, including the wrong order and an empty state |
| And | every surprise is recorded as a finding whether or not a scenario covers it |

## F-082-04 Every finding has the same shape

| Scenario | F-082-04 |
| --- | --- |
| Name | Every finding has the same shape |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ux-review-ux" records a finding |
| Then | the finding names the scenario or flow, what was expected, what happened, and the severity |

## F-082-05 A defect goes to Development

| Scenario | F-082-05 |
| --- | --- |
| Name | A defect goes to Development |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the software does not do what a scenario says |
| When | "/aa-ux-review-ux" classifies the finding |
| Then | it is recorded as a defect |
| And | a ticket linked to this one is raised for Development |

## F-082-06 A wrong scenario goes to Business Analysis

| Scenario | F-082-06 |
| --- | --- |
| Name | A wrong scenario goes to Business Analysis |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the software does what the scenario says but the interaction fails the user |
| When | "/aa-ux-review-ux" classifies the finding |
| Then | it is recorded as a requirement change |
| And | a question is raised on the ticket for the feature file to change first, then the mock-up |

## F-082-07 Behaviour shown only by the mock-up is a question

| Scenario | F-082-07 |
| --- | --- |
| Name | Behaviour shown only by the mock-up is a question |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the mock-up shows behaviour that no scenario states |
| When | "/aa-ux-review-ux" compares the software with the mock-up |
| Then | the behaviour is recorded as a question on the ticket, not as a defect |

## F-082-08 Findings above cosmetic become tickets

| Scenario | F-082-08 |
| --- | --- |
| Name | Findings above cosmetic become tickets |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a finding has a severity above cosmetic |
| When | "/aa-ux-review-ux" finishes |
| Then | the finding is a ticket in the configured ticket project linked to this one |
| And | cosmetic findings are listed on the knowledge base page |

## F-082-09 The findings are recorded on the ticket and the page

| Scenario | F-082-09 |
| --- | --- |
| Name | The findings are recorded on the ticket and the page |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ux-review-ux" finishes |
| Then | the usability findings are on the anchor ticket and the knowledge base page, linked both ways |
| And | the ticket records the tickets raised and what was not exercised |

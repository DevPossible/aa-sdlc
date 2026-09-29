# F-052 /aa-pd-define-outcome writes down what an initiative is for and how we will know

| Feature | F-052 |
| --- | --- |
| Name | /aa-pd-define-outcome writes down what an initiative is for and how we will know |
| Tags | @agent @product-management @O-15 @O-18 |
| File | define-outcome |

Write the outcome of an initiative as a change in a measure, with the metric, its current
value, and the target, who benefits, and what is out of scope, on the anchor epic, so every
later step can answer "does this serve the outcome".

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an idea or problem statement for a new initiative |

## F-052-01 The outcome is a change in a measure, not a list of features

| Scenario | F-052-01 |
| --- | --- |
| Name | The outcome is a change in a measure, not a list of features |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-define-outcome" writes the epic |
| Then | the outcome is stated as a change in a measure |
| And | the epic names who benefits and what they can do afterwards that they cannot do now |
| And | a statement that could be satisfied by shipping something nobody uses is rewritten |

## F-052-02 The metric has a baseline and a target

| Scenario | F-052-02 |
| --- | --- |
| Name | The metric has a baseline and a target |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-define-outcome" writes the epic |
| Then | the epic names the success metric, its current value, and the target |
| And | a current value that was estimated rather than measured is labelled as an estimate |

## F-052-03 A screenshot that arrives first is evidence, not the requirement

| Scenario | F-052-03 |
| --- | --- |
| Name | A screenshot that arrives first is evidence, not the requirement |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the request arrived as a screenshot with no written goal |
| When | "/aa-pd-define-outcome" starts |
| Then | it writes the goal the screenshot implies |
| And | what the screenshot does not show is recorded as questions on the epic |
| And | no mock-up is produced |

## F-052-04 Scope is drawn in the same place

| Scenario | F-052-04 |
| --- | --- |
| Name | Scope is drawn in the same place |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-pd-define-outcome" writes the epic |
| Then | the epic says what is out of scope |
| And | the assumptions the outcome rests on are listed on it |

## F-052-05 A duplicate or conflicting outcome is named before a new one is written

| Scenario | F-052-05 |
| --- | --- |
| Name | A duplicate or conflicting outcome is named before a new one is written |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an existing outcome on the roadmap covers the same measure |
| When | "/aa-pd-define-outcome" reads the roadmap |
| Then | it names the existing outcome and the conflict on the epic |
| And | it does not write a second outcome for the same measure without saying so |

## F-052-06 A significant product decision becomes a decision record

| Scenario | F-052-06 |
| --- | --- |
| Name | A significant product decision becomes a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | choosing this outcome rejected an alternative |
| When | "/aa-pd-define-outcome" records the outcome |
| Then | a decision record is written, numbered next in the repository's sequence, and linked from the epic |
| And | the record is staged and presented, not committed |

## F-052-07 No ticket system in scope

| Scenario | F-052-07 |
| --- | --- |
| Name | No ticket system in scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no ticket system is in scope |
| When | "/aa-pd-define-outcome" runs |
| Then | the epic is produced locally |
| And | the report says so |

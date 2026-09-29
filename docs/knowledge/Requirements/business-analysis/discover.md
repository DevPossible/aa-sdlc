# F-003 /aa-ba-discover captures what stakeholders need as draft scenarios

| Feature | F-003 |
| --- | --- |
| Name | /aa-ba-discover captures what stakeholders need as draft scenarios |
| Tags | @agent @business-analysis @O-01 @O-15 |
| File | discover |

Capture stakeholder input as Draft scenarios on feature pages in the knowledge base from the
first pass, tagged with the epic, with a question log on the epic for everything not yet
answered. No feature file is written; the repository gets a scenario by pulling its page once
the scenario is Approved.
A screenshot or mock-up that arrives as the request is treated as evidence, not as the
requirement.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an anchor epic with an outcome and a transcript of a stakeholder conversation |

## F-003-01 Needs are written as Gherkin from the first pass

| Scenario | F-003-01 |
| --- | --- |
| Name | Needs are written as Gherkin from the first pass |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-discover" captures the stated needs |
| Then | each need is a Draft scenario on a feature page under the project's Requirements section |
| And | each scenario is tagged with the epic |
| And | the feature description states the business objectives and the scope boundaries |
| And | no feature file is written |

## F-003-02 A screenshot is a witness, not a specification

| Scenario | F-003-02 |
| --- | --- |
| Name | A screenshot is a witness, not a specification |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the request arrived as a screenshot |
| When | "/aa-ba-discover" starts |
| Then | it writes the goals and scenarios the screenshot implies |
| And | what the screenshot does not show is logged as questions on the epic |
| And | the screenshot is not recorded as the requirement |

## F-003-03 Silence becomes a question

| Scenario | F-003-03 |
| --- | --- |
| Name | Silence becomes a question |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stakeholder said nothing about what happens when the input is invalid |
| When | "/aa-ba-discover" reviews the draft scenarios |
| Then | a question about the error case is added to the question log |
| And | the question has its context and an owner |
| And | no behaviour is assumed for it |

## F-003-04 An out-of-scope need is an explicit non-requirement

| Scenario | F-003-04 |
| --- | --- |
| Name | An out-of-scope need is an explicit non-requirement |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stakeholder asked for something outside the epic's outcome |
| When | "/aa-ba-discover" captures it |
| Then | it is recorded as an explicit non-requirement in the feature description |
| And | it is not silently dropped |

## F-003-05 An existing scenario is not written twice

| Scenario | F-003-05 |
| --- | --- |
| Name | An existing scenario is not written twice |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an existing feature page already states one of the needs |
| When | "/aa-ba-discover" captures the needs |
| Then | the existing scenario is linked from the epic |
| And | no duplicate scenario is written |

## F-003-06 A requirement found only in the ticket is a conflict

| Scenario | F-003-06 |
| --- | --- |
| Name | A requirement found only in the ticket is a conflict |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the epic description states a requirement that no feature page contains |
| When | "/aa-ba-discover" checks where the truth lives |
| Then | it raises the requirement as a conflict on the epic |
| And | it does not absorb it silently |

## F-003-07 The pages are linked and presented, never committed

| Scenario | F-003-07 |
| --- | --- |
| Name | The pages are linked and presented, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-discover" finishes |
| Then | the epic links to each feature page and its scenario ids, and each page links back |
| And | where the pages are in the documents folder, the new and changed pages are staged with a Conventional Commit message |
| And | no commit is made unless the user asked for that commit |

## F-003-08 A requirement found only in a feature file is a conflict

| Scenario | F-003-08 |
| --- | --- |
| Name | A requirement found only in a feature file is a conflict |
| Kind | Scenario |
| Tags | @G-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a feature file in the repository states a requirement that no feature page generates |
| When | "/aa-ba-discover" checks where the truth lives |
| Then | it raises the requirement as a conflict on the epic |
| And | it does not absorb it into a page silently |

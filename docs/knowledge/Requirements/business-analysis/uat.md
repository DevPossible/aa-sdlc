# F-005 /aa-ba-uat confirms with stakeholders that what was built is what they meant

| Feature | F-005 |
| --- | --- |
| Name | /aa-ba-uat confirms with stakeholders that what was built is what they meant |
| Tags | @agent @business-analysis @T-07 @T-12 |
| File | uat |

Walk stakeholders through the scenarios as written against the deployed software, record
acceptance by name and date for each scenario, and turn every gap into a ticket or a scenario
change, never a note that fades.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket whose scenarios are built and deployed to an environment the stakeholder can use |

## F-005-01 The scenarios are checked against the build before the walkthrough

| Scenario | F-005-01 |
| --- | --- |
| Name | The scenarios are checked against the build before the walkthrough |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket records the revision it was built against |
| When | "/aa-ba-uat" starts |
| Then | it compares that revision with the head for the linked feature files |
| And | a scenario that changed since is noted on the ticket before the walkthrough |

## F-005-02 The walkthrough covers every scenario

| Scenario | F-005-02 |
| --- | --- |
| Name | The walkthrough covers every scenario |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-uat" writes the walkthrough order on the ticket |
| Then | every scenario for the ticket appears in it with the Given it needs set up |
| And | the scenarios themselves are the test cases, not a rewrite of them |

## F-005-03 The scenario is walked as written

| Scenario | F-005-03 |
| --- | --- |
| Name | The scenario is walked as written |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stakeholder asks to see something the scenario does not state |
| When | "/aa-ba-uat" walks the scenario |
| Then | the Given, When, Then are walked as written |
| And | the request is recorded as a question on the ticket for the feature file, not as a demo step |

## F-005-04 Acceptance is recorded by name

| Scenario | F-005-04 |
| --- | --- |
| Name | Acceptance is recorded by name |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-uat" records a scenario as accepted |
| Then | the result names who accepted it and on what date |
| And | "UAT passed" on its own is not recorded as a result |

## F-005-05 A scenario not met becomes a ticket for Development

| Scenario | F-005-05 |
| --- | --- |
| Name | A scenario not met becomes a ticket for Development |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the software does not do what a scenario says |
| When | "/aa-ba-uat" records the result |
| Then | the scenario is marked not accepted with the gap described |
| And | a new ticket linked to this one is raised for Development |

## F-005-06 A met scenario that is not what was meant is a requirement change

| Scenario | F-005-06 |
| --- | --- |
| Name | A met scenario that is not what was meant is a requirement change |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the software does what a scenario says but the stakeholder meant something else |
| When | "/aa-ba-uat" records the result |
| Then | the gap is raised as a question on the ticket and changed in the feature file first |
| And | it is not recorded as a failure of the build |

## F-005-07 The results report is on the ticket and linked from the page

| Scenario | F-005-07 |
| --- | --- |
| Name | The results report is on the ticket and linked from the page |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-uat" finishes |
| Then | the UAT results report is on the anchor ticket |
| And | the knowledge base page links to it and it links back |
| And | any changed feature file is staged and presented, not committed |

# F-028 A requirement starts with written goals; the mock-up comes after

| Feature | F-028 |
| --- | --- |
| Name | A requirement starts with written goals; the mock-up comes after |
| Tags | @framework @agent @O-15 @O-01 @T-12 |
| File | goals-before-mockups |

No requirement begins as a screenshot or a mock-up. It begins as written goals, the outcome
and then the scenarios, refined until they are unambiguous and testable. The mock-up is
generated from the scenarios and names the ones it renders. A picture that arrives first is
evidence for discovery, not a requirement.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an anchor epic with a measurable outcome |

## F-028-01 The normal order, goals then scenarios then mock-up

| Scenario | F-028-01 |
| --- | --- |
| Name | The normal order, goals then scenarios then mock-up |
| Kind | Scenario |
| Tags | @G-35 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-discover" and "/aa-ba-refine-requirements" produce confirmed scenarios |
| And | "/aa-ux-prototype" runs for the ticket |
| Then | every mock-up is produced from the confirmed scenarios |
| And | every mock-up names the scenarios it renders |
| And | no scenario cites a mock-up as its source |

## F-028-02 A screenshot arrives as the whole requirement

| Scenario | F-028-02 |
| --- | --- |
| Name | A screenshot arrives as the whole requirement |
| Kind | Scenario |
| Tags | @G-35 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stakeholder provides a screenshot and the words "build this" |
| When | "/aa-ba-discover" runs |
| Then | the screenshot is treated as evidence of what the stakeholder wants |
| And | the goals and scenarios it implies are written as draft scenarios |
| And | what the screenshot does not show is recorded as questions on the ticket |
| And | no scenario is written that cites the screenshot as its source |

## F-028-03 The mock-up is regenerated once the goals are confirmed

| Scenario | F-028-03 |
| --- | --- |
| Name | The mock-up is regenerated once the goals are confirmed |
| Kind | Scenario |
| Tags | @G-35 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | draft scenarios written from a screenshot have been refined and confirmed |
| When | "/aa-ux-prototype" runs |
| Then | a new mock-up is produced from the confirmed scenarios |
| And | it names the scenarios it renders |
| And | where it differs from the original screenshot, the difference is explained on the ticket |

## F-028-04 A mock-up shows behaviour no scenario states

| Scenario | F-028-04 |
| --- | --- |
| Name | A mock-up shows behaviour no scenario states |
| Kind | Scenario |
| Tags | @G-36 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a mock-up shows a control whose behaviour no scenario describes |
| When | "/aa-ux-prototype" or "/aa-ux-review-ux" notices it |
| Then | a question is added to the ticket |
| And | the scenario is changed first if the behaviour is wanted |
| And | the mock-up is changed after the scenario |

## F-028-05 The unhappy path is in the goals before it is in the picture

| Scenario | F-028-05 |
| --- | --- |
| Name | The unhappy path is in the goals before it is in the picture |
| Kind | Scenario |
| Tags | @G-36 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | confirmed scenarios include an error case |
| When | "/aa-ux-prototype" runs |
| Then | the mock-up shows the error state the scenario describes |
| And | it is not left to be invented at implementation time |

## F-028-06 The step still runs when handed a picture

| Scenario | F-028-06 |
| --- | --- |
| Name | The step still runs when handed a picture |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the only input available is a screenshot |
| When | "/aa-ba-discover" runs |
| Then | it does not refuse |
| And | it says it is treating the picture as evidence and why |

## F-028-07 Health reports mock-ups with no scenarios behind them

| Scenario | F-028-07 |
| --- | --- |
| Name | Health reports mock-ups with no scenarios behind them |
| Kind | Scenario |
| Tags | @R-29 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | mock-ups linked from tickets name no scenarios |
| When | "/aa-fw-health" runs |
| Then | R-29 is reported as unmet with the mock-ups listed |

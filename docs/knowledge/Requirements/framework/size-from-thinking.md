# F-040 A size is grounded in implementation thinking

| Feature | F-040 |
| --- | --- |
| Name | A size is grounded in implementation thinking |
| Tags | @framework @agent @O-10 @T-07 |
| File | size-from-thinking |

No unit of work carries a size or an effort estimate that is not backed by written thought
about how it will be built: what changes, what is unknown, what could go wrong. The depth
matches the stakes. The framework does not say when the thinking happens or who does it;
it says a number without it is a guess, labelled as one and never recorded as the size.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket whose scenarios are linked and whose questions are answered |
| And | the ticket has no size |

## F-040-01 A ticket is sized from written implementation thinking

| Scenario | F-040-01 |
| --- | --- |
| Name | A ticket is sized from written implementation thinking |
| Kind | Scenario |
| Tags | @G-28 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rf-refine-ticket" sizes the ticket |
| Then | the ticket first records what changes, what is unknown, and what could go wrong |
| And | the size is recorded on the ticket after that reasoning |
| And | the size cites the reasoning as its basis |

## F-040-02 The depth of thinking matches the stakes

| Scenario | F-040-02 |
| --- | --- |
| Name | The depth of thinking matches the stakes |
| Kind | Scenario |
| Tags | @G-28 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | one ticket changes a label and another changes a payment flow |
| When | each is sized |
| Then | the label ticket's reasoning is a sentence naming the file that changes |
| And | the payment ticket's reasoning is a full implementation plan |
| And | both sizes cite their reasoning |

## F-040-03 A number asked for before any thinking is a labelled guess

| Scenario | F-040-03 |
| --- | --- |
| Name | A number asked for before any thinking is a labelled guess |
| Kind | Scenario |
| Tags | @G-28 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket has no written thought about how it will be built |
| When | a size or estimate is requested for it |
| Then | the answer is a range labelled as a guess |
| And | no size is recorded on the ticket |
| And | the ticket is not reported as ready |

## F-040-04 An iteration is not committed on a guess

| Scenario | F-040-04 |
| --- | --- |
| Name | An iteration is not committed on a guess |
| Kind | Scenario |
| Tags | @G-28 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket carries a size with no reasoning behind it |
| When | "/aa-pm-plan-iteration" considers it |
| Then | the ticket is reported as not ready |
| And | it is not committed to the iteration |
| And | the reason names the missing reasoning |

## F-040-05 The implementation plan checks the size

| Scenario | F-040-05 |
| --- | --- |
| Name | The implementation plan checks the size |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sized ticket whose reasoning was a short sketch |
| When | "/aa-ip-plan-implementation" produces a plan that reveals more than the sketch saw |
| Then | the size on the ticket is revised |
| And | the revision says what the plan found that the sketch did not |

## F-040-06 Health reports sizes with nothing behind them

| Scenario | F-040-06 |
| --- | --- |
| Name | Health reports sizes with nothing behind them |
| Kind | Scenario |
| Tags | @R-23 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | sized tickets in the configured project have no implementation thinking recorded |
| When | "/aa-fw-health" runs |
| Then | R-23 is reported as unmet with those tickets listed |

# F-033 /aa-internal-new-tenet adds a tenet and makes existing content agree with it

| Feature | F-033 |
| --- | --- |
| Name | /aa-internal-new-tenet adds a tenet and makes existing content agree with it |
| Tags | @framework @agent @fw |
| File | new-tenet |

Tenets are few and govern everything. Adding one means showing it in action and checking
that nothing already written contradicts it.

## Background

| Step | Text |
| --- | --- |
| Given | I am in the aa-sdlc repository |

## F-033-01 Add a well-formed tenet

| Scenario | F-033-01 |
| --- | --- |
| Name | Add a well-formed tenet |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-internal-new-tenet" with a principle and its reasoning |
| Then | docs/tenets.md gains an entry with the next T-nn id |
| And | the grouping sentence and every tenet range in the docs are updated |
| And | a feature file shows the principle applied in at least three situations |

## F-033-02 Redirect what is not a tenet

| Scenario | F-033-02 |
| --- | --- |
| Name | Redirect what is not a tenet |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the statement is about how to perform a step, or chooses between alternatives |
| When | I run "/aa-internal-new-tenet" |
| Then | it says whether the statement is guidance or an opinion |
| And | it redirects to the right place instead of adding a tenet |

## F-033-03 Existing content is checked for conflicts

| Scenario | F-033-03 |
| --- | --- |
| Name | Existing content is checked for conflicts |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an existing opinion or guidance item contradicts the new tenet |
| When | I run "/aa-internal-new-tenet" |
| Then | the contradiction is named |
| And | it is resolved in the same change, or the tenet is not added |

## F-033-04 Governed disciplines and steps cite it

| Scenario | F-033-04 |
| --- | --- |
| Name | Governed disciplines and steps cite it |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-internal-new-tenet" finishes |
| Then | every discipline or step the tenet governs lists it under tenets |
| And | the unit tier passes and the discipline review regenerates |

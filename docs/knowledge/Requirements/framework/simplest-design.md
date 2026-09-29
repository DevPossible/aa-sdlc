# F-039 The simplest design that meets the scenarios

| Feature | F-039 |
| --- | --- |
| Name | The simplest design that meets the scenarios |
| Tags | @framework @agent @O-20 @O-01 @T-07 |
| File | simplest-design |

The design of a system, a component, or a change is the simplest one that satisfies the
scenarios that exist. Nothing is added for a scenario that does not exist yet. Every
component, boundary, and extension point names the scenario that requires it or the decision
record that justifies it. When a new scenario arrives, the design changes to meet it.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an epic with refined scenarios in the features folder |

## F-039-01 The architecture maps every component to a scenario

| Scenario | F-039-01 |
| --- | --- |
| Name | The architecture maps every component to a scenario |
| Kind | Scenario |
| Tags | @G-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-architect" produces the system architecture |
| Then | every component, boundary, and extension point names a scenario that requires it |
| And | any that a scenario does not require names a decision record that justifies it |
| And | nothing else is in the architecture |

## F-039-02 A speculative extension point is left out

| Scenario | F-039-02 |
| --- | --- |
| Name | A speculative extension point is left out |
| Kind | Scenario |
| Tags | @G-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the scenarios describe one payment provider |
| When | "/aa-ta-architect" considers a provider abstraction |
| Then | no abstraction is introduced for a second provider that no scenario names |
| And | the architecture notes that a second provider would be a new scenario and a design change |

## F-039-03 The plan is the smallest change that makes the scenarios pass

| Scenario | F-039-03 |
| --- | --- |
| Name | The plan is the smallest change that makes the scenarios pass |
| Kind | Scenario |
| Tags | @G-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ip-plan-implementation" plans a ticket |
| Then | every step in the plan serves a scenario of the ticket |
| And | no step adds a configuration option, generalisation, or feature the scenarios do not need |

## F-039-04 An agent asked for one thing does not build the general mechanism

| Scenario | F-039-04 |
| --- | --- |
| Name | An agent asked for one thing does not build the general mechanism |
| Kind | Scenario |
| Tags | @G-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket whose scenario asks for a report exported as one format |
| When | "/aa-dev-implement" builds it |
| Then | the change exports that one format |
| And | no export framework, format registry, or plugin interface is introduced |
| And | a second format, when its scenario arrives, is a change to this code |

## F-039-05 Review finds structure that serves no scenario

| Scenario | F-039-05 |
| --- | --- |
| Name | Review finds structure that serves no scenario |
| Kind | Scenario |
| Tags | @G-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merge request that introduces an interface with a single implementation and no scenario needing another |
| When | "/aa-dev-review" reviews it |
| Then | a finding names the interface and asks which scenario requires it |
| And | the finding suggests removing it or recording a decision that justifies it |

## F-039-06 Simple does not mean duplicated

| Scenario | F-039-06 |
| --- | --- |
| Name | Simple does not mean duplicated |
| Kind | Scenario |
| Tags | @G-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a change that would copy the same logic a fourth time |
| When | "/aa-dev-review" reviews it |
| Then | a finding says the repeated logic should be named once |
| And | the finding cites the scenarios the shared code serves |

## F-039-07 A justified exception is recorded, not smuggled in

| Scenario | F-039-07 |
| --- | --- |
| Name | A justified exception is recorded, not smuggled in |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a regulatory constraint requires an audit boundary no current scenario exercises |
| When | "/aa-ta-architect" includes it |
| Then | "/aa-ta-decide" writes a decision record naming the constraint |
| And | the architecture maps the boundary to that record |

## F-039-08 Health reports an unmapped component

| Scenario | F-039-08 |
| --- | --- |
| Name | Health reports an unmapped component |
| Kind | Scenario |
| Tags | @R-34 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the architecture names a component that maps to no scenario and no decision record |
| When | "/aa-fw-health" runs |
| Then | R-34 is reported as unmet with the component named |

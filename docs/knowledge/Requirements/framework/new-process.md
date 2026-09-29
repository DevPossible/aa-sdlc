# F-031 /aa-internal-new-process adds a described, never enforced, process

| Feature | F-031 |
| --- | --- |
| Name | /aa-internal-new-process adds a described, never enforced, process |
| Tags | @framework @agent @fw @T-03 |
| File | new-process |

A process is an ordering of steps toward a goal. Every step in it still runs alone.

## Background

| Step | Text |
| --- | --- |
| Given | I am in the aa-sdlc repository |

## F-031-01 Add a process from existing steps

| Scenario | F-031-01 |
| --- | --- |
| Name | Add a process from existing steps |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-internal-new-process" with a goal and an ordered list of existing steps |
| Then | workflow/processes/<id>.yaml exists with the steps in order, process guidance, and an exit condition |
| And | a feature file shows the process run end to end and any step run alone |

## F-031-02 Missing steps are created first

| Scenario | F-031-02 |
| --- | --- |
| Name | Missing steps are created first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ordered list names a step that does not exist |
| When | I run "/aa-internal-new-process" |
| Then | the step is created as "/aa-internal-new-step" would create it |
| And | the process is written only after every step exists |

## F-031-03 Gating steps are refused

| Scenario | F-031-03 |
| --- | --- |
| Name | Gating steps are refused |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the proposal includes a step whose only purpose is to check that an earlier step ran |
| When | I run "/aa-internal-new-process" |
| Then | it removes or refuses the gating step and cites tenet T-03 |

## F-031-04 The exit condition is checkable

| Scenario | F-031-04 |
| --- | --- |
| Name | The exit condition is checkable |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-internal-new-process" writes the exit condition |
| Then | the condition names artifacts or states a person or "/aa-fw-health" could verify |

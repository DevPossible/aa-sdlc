# F-029 /aa-internal-new-discipline adds a discipline that can be reviewed on day one

| Feature | F-029 |
| --- | --- |
| Name | /aa-internal-new-discipline adds a discipline that can be reviewed on day one |
| Tags | @framework @agent @fw @T-13 |
| File | new-discipline |

A discipline with no steps, no code, or no boundaries cannot be reviewed or installed. The
command creates all of it together.

## Background

| Step | Text |
| --- | --- |
| Given | I am in the aa-sdlc repository |

## F-029-01 Add a discipline with one step

| Scenario | F-029-01 |
| --- | --- |
| Name | Add a discipline with one step |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-internal-new-discipline" with a name, a code, an SDLC position, bounded responsibilities, and one step |
| Then | workflow/disciplines/<id>.yaml exists with purpose, owns, does_not_own, hands_off_to, steps, and tenets |
| And | the step exists with its command, skill scaffold, and scenarios |
| And | a skills subfolder for the discipline exists with a README |

## F-029-02 The code must be unused

| Scenario | F-029-02 |
| --- | --- |
| Name | The code must be unused |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the proposed code is already used by another discipline |
| When | I run "/aa-internal-new-discipline" |
| Then | it refuses the code and lists the codes in use |

## F-029-03 Neighbouring boundaries are updated

| Scenario | F-029-03 |
| --- | --- |
| Name | Neighbouring boundaries are updated |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the new discipline takes ownership of work another discipline listed under owns |
| When | I run "/aa-internal-new-discipline" |
| Then | the other discipline's owns, does_not_own, or hands_off_to is updated in the same change |

## F-029-04 A role from one organisation's chart is redirected

| Scenario | F-029-04 |
| --- | --- |
| Name | A role from one organisation's chart is redirected |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the proposal describes a role that exists only in large organisations |
| When | I run "/aa-internal-new-discipline" |
| Then | it explains that a discipline is a kind of work, not a headcount |
| And | it redirects to "/aa-fw-extend" for a process pack |

## F-029-05 Documents and review are updated

| Scenario | F-029-05 |
| --- | --- |
| Name | Documents and review are updated |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-internal-new-discipline" finishes |
| Then | the design's disciplines table, the vocabulary's discipline list, and the review plan include it |
| And | the discipline review regenerates and the unit tier passes |

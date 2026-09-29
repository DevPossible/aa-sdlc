# F-085 Tickets follow one hierarchy and one life cycle

| Feature | F-085 |
| --- | --- |
| Name | Tickets follow one hierarchy and one life cycle |
| Tags | @framework @agent @O-26 @T-01 |
| File | ticket-life-cycle |

Every ticket is an epic, a story, a task, a bug, or a spike, and moves through New, Refined,
Planned, In progress, In review, Accepted, and Done. A ticket moves only in the step that
produces the evidence for the new state, and the project config maps each kind and state to the
ticket system's own names.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | the project config maps the ticket kinds and states to the ticket system |

## F-085-01 A step moves the ticket and writes the evidence

| Scenario | F-085-01 |
| --- | --- |
| Name | A step moves the ticket and writes the evidence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a New story |
| When | "/aa-rf-refine-ticket" completes on it |
| Then | the story is in the state the config maps Refined to |
| And | the ticket records the scenarios linked and the repository revision checked against |

## F-085-02 No step, no move

| Scenario | F-085-02 |
| --- | --- |
| Name | No step, no move |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a Refined story with no confirmed plan |
| When | work is started on it without "/aa-ip-plan-implementation" |
| Then | the step says the ticket is not Planned and names the step that plans it |
| And | it does not move the ticket to Planned itself |

## F-085-03 Each state is set by one step

| Scenario | F-085-03 |
| --- | --- |
| Name | Each state is set by one step |
| Kind | Scenario Outline |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "<step>" completes on a ticket |
| Then | the ticket is in the state the config maps <state> to |

### Examples

| step | state |
| --- | --- |
| /aa-rf-refine-ticket | Refined |
| /aa-ip-plan-implementation | Planned |
| /aa-dev-implement | In progress |
| /aa-dev-finish-branch | In review |
| /aa-ba-uat | Accepted |
| /aa-rel-release | Done |

## F-085-04 Tickets are created as one of the five kinds

| Scenario | F-085-04 |
| --- | --- |
| Name | Tickets are created as one of the five kinds |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rf-plan-work" breaks an epic into work |
| Then | each piece is created as a story, in the ticket system's name for a story |
| And | each story is linked to the epic as its parent |

## F-085-05 The ticket system keeps its own words

| Scenario | F-085-05 |
| --- | --- |
| Name | The ticket system keeps its own words |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket system calls the Refined state "Ready for dev" |
| When | a step moves a ticket to Refined |
| Then | the ticket moves to "Ready for dev" |

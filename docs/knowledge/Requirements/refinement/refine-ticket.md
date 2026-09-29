# F-059 /aa-rf-refine-ticket brings one ticket to the definition of ready

| Feature | F-059 |
| --- | --- |
| Name | /aa-rf-refine-ticket brings one ticket to the definition of ready |
| Tags | @agent @refinement @O-10 @O-13 @T-12 |
| File | refine-ticket |

Scenarios linked and complete, acceptance criteria checkable, size grounded in implementation
thinking, dependencies clear, questions answered or owned, and the repository revision
recorded so the step that picks the ticket up can see what moved.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket with draft scenarios and open questions |

## F-059-01 Scenarios are read before the description

| Scenario | F-059-01 |
| --- | --- |
| Name | Scenarios are read before the description |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rf-refine-ticket" starts |
| Then | it reads the linked scenarios first |
| And | the acceptance criteria it records are the scenarios, not a restatement |

## F-059-02 A gap becomes a question, not a guess

| Scenario | F-059-02 |
| --- | --- |
| Name | A gap becomes a question, not a guess |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario the ticket needs does not exist |
| When | "/aa-rf-refine-ticket" notices |
| Then | a question is added to the ticket for Business Analysis |
| And | no scenario is invented |

## F-059-03 A scope-changing question blocks readiness

| Scenario | F-059-03 |
| --- | --- |
| Name | A scope-changing question blocks readiness |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an open question would change the scope of the ticket |
| When | "/aa-rf-refine-ticket" assesses readiness |
| Then | the ticket is reported as not ready however small it looks |

## F-059-04 The size is grounded in thinking

| Scenario | F-059-04 |
| --- | --- |
| Name | The size is grounded in thinking |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rf-refine-ticket" sizes the ticket |
| Then | the ticket first records what changes, what is unknown, and what could go wrong |
| And | the size cites that reasoning |
| And | a number requested before the thinking exists is given as a labelled range and not recorded |

## F-059-05 The revision is recorded

| Scenario | F-059-05 |
| --- | --- |
| Name | The revision is recorded |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rf-refine-ticket" marks the ticket ready |
| Then | the ticket records the repository revision its scenarios were checked against |

## F-059-06 Not ready is said plainly

| Scenario | F-059-06 |
| --- | --- |
| Name | Not ready is said plainly |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | one item of the definition of ready is not met |
| When | "/aa-rf-refine-ticket" finishes |
| Then | the ticket says which item is unmet and whether it proceeds anyway |

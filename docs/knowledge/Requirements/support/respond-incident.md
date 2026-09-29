# F-071 /aa-sup-respond-incident contains an incident and keeps the record as it happens

| Feature | F-071 |
| --- | --- |
| Name | /aa-sup-respond-incident contains an incident and keeps the record as it happens |
| Tags | @agent @support @O-19 @T-06 @T-07 |
| File | respond-incident |

Coordinate an active incident: keep a timeline on the incident ticket, contain the impact
before diagnosing it, communicate at a stated cadence, and close the incident only when
restoration is verified with evidence and a post-incident review is scheduled.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an incident ticket with a severity and a current impact |

## F-071-01 The timeline is written as it happens

| Scenario | F-071-01 |
| --- | --- |
| Name | The timeline is written as it happens |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sup-respond-incident" takes an action or makes an observation |
| Then | it is recorded on the incident ticket with a timestamp at the time it happens |
| And | nothing is added to the timeline from memory afterwards |

## F-071-02 Containment comes before diagnosis

| Scenario | F-071-02 |
| --- | --- |
| Name | Containment comes before diagnosis |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a rollback option exists for the last release |
| When | "/aa-sup-respond-incident" begins |
| Then | containment such as rollback, turning the feature off, or scaling is chosen before the cause is sought |

## F-071-03 Irreversible actions wait for the user

| Scenario | F-071-03 |
| --- | --- |
| Name | Irreversible actions wait for the user |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user has not granted rollback in advance |
| When | "/aa-sup-respond-incident" decides to roll back |
| Then | it stops and asks before doing so |
| And | the ask and the answer are recorded on the timeline |

## F-071-04 Status goes out at a stated cadence

| Scenario | F-071-04 |
| --- | --- |
| Name | Status goes out at a stated cadence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sup-respond-incident" confirms the incident |
| Then | a status is sent saying what is known, what is not, what is being done, and who is affected |
| And | it says when the next status will come |
| And | each communication is recorded on the ticket with its audience |

## F-071-05 Every change made during the incident names the incident

| Scenario | F-071-05 |
| --- | --- |
| Name | Every change made during the incident names the incident |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a fix is made while the incident is open |
| When | the change is prepared |
| Then | the branch, the commit message footer, and the merge request name the incident ticket |

## F-071-06 Restoration is verified with evidence

| Scenario | F-071-06 |
| --- | --- |
| Name | Restoration is verified with evidence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sup-respond-incident" declares service restored |
| Then | the dashboards, the cleared alerts, and where possible the broken scenario passing are quoted on the ticket |
| And | the time to restore is computed from the timeline with a tool |

## F-071-07 Closing the incident schedules the review

| Scenario | F-071-07 |
| --- | --- |
| Name | Closing the incident schedules the review |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sup-respond-incident" closes the incident |
| Then | the ticket records the mitigation with links to any rollback or change |
| And | a post-incident review is scheduled and linked from the incident |
| And | any change staged during the incident is presented, not committed |

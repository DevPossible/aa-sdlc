# F-062 /aa-rel-rollback returns production to the previous known-good release

| Feature | F-062 |
| --- | --- |
| Name | /aa-rel-rollback returns production to the previous known-good release |
| Tags | @agent @release-management @O-24 |
| File | rollback |

The trigger is recorded first, the target is confirmed known-good by its verification record
and returned to by its artifact identity through the pipeline, data that will not roll back
is named before anything moves, the user is asked before the step, and the cause becomes a
ticket.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a release in production, a previous release with a verification record, and a rollback runbook |

## F-062-01 The trigger is recorded before anything else

| Scenario | F-062-01 |
| --- | --- |
| Name | The trigger is recorded before anything else |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an incident or a failed verification check |
| When | "/aa-rel-rollback" runs |
| Then | the trigger is recorded on the release ticket before any other action |

## F-062-02 The target must be known-good, not just previous

| Scenario | F-062-02 |
| --- | --- |
| Name | The target must be known-good, not just previous |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the previous release's verification checks failed or were never run |
| When | "/aa-rel-rollback" chooses the target |
| Then | it does not use that release |
| And | it names the most recent release whose verification record passed, or stops and asks |

## F-062-03 One-way data changes are named before anything moves

| Scenario | F-062-03 |
| --- | --- |
| Name | One-way data changes are named before anything moves |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a schema or data migration since the target release |
| When | "/aa-rel-rollback" prepares |
| Then | it names each migration that will not roll back with the code |
| And | it follows the runbook's data steps, or stops and asks when the runbook is silent |

## F-062-04 The user is asked before the rollback

| Scenario | F-062-04 |
| --- | --- |
| Name | The user is asked before the rollback |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-rollback" is ready |
| Then | it presents the current identity, the target identity, the trigger, the data implications, and the pipeline run |
| And | it rolls back only when the user grants it |

## F-062-05 Rollback returns to an identity, not a rebuilt tag

| Scenario | F-062-05 |
| --- | --- |
| Name | Rollback returns to an identity, not a rebuilt tag |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user grants the rollback |
| When | "/aa-rel-rollback" rolls back |
| Then | the pipeline deploys the target release's immutable artifact identity |
| And | nothing is rebuilt from the target's tag |
| And | the run's result is quoted |

## F-062-06 Verification follows the rollback

| Scenario | F-062-06 |
| --- | --- |
| Name | Verification follows the rollback |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the rollback pipeline run completed |
| When | "/aa-rel-rollback" verifies |
| Then | the target release's verification checks are run and each result recorded with evidence |
| And | the identity now running is confirmed to be the target |
| And | a check that still fails is escalated on the incident, not retried |

## F-062-07 The cause becomes a ticket and the record is complete

| Scenario | F-062-07 |
| --- | --- |
| Name | The cause becomes a ticket and the record is complete |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-rollback" finishes |
| Then | a ticket for the cause is linked from the release ticket and the incident |
| And | the rollback record states what was reverted to, when, by whom, the trigger, and the verification results |

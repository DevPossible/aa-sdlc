# F-061 /aa-rel-release deploys a prepared release to production and proves it

| Feature | F-061 |
| --- | --- |
| Name | /aa-rel-release deploys a prepared release to production and proves it |
| Tags | @agent @release-management @O-24 |
| File | release |

The deployment goes through the pipeline with the artifact identity the release names, never
rebuilt and never by hand; the user is asked before the irreversible step every time; the
release is done when the checks pass in production, and a failure rolls back by default.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a prepared release with a go decision, an artifact identity, verification checks, and a deployment runbook |

## F-061-01 No go decision, no deployment

| Scenario | F-061-01 |
| --- | --- |
| Name | No go decision, no deployment |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the release ticket records no go decision |
| When | "/aa-rel-release" runs |
| Then | it stops before any deployment |
| And | it says on the release ticket what is missing |

## F-061-02 The user is asked before every production deployment

| Scenario | F-061-02 |
| --- | --- |
| Name | The user is asked before every production deployment |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-release" is ready to deploy |
| Then | it presents the identity, the target, the pipeline run, the strategy, and what rollback would return to |
| And | it deploys only when the user grants this deployment |
| And | a permission granted for an earlier release does not carry over |

## F-061-03 The same identity is deployed, through the pipeline

| Scenario | F-061-03 |
| --- | --- |
| Name | The same identity is deployed, through the pipeline |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user grants the deployment |
| When | "/aa-rel-release" deploys |
| Then | the pipeline deploys the identity the release names |
| And | nothing is rebuilt for production |
| And | no deployment step is performed by hand |

## F-061-04 A blocking gate is never bypassed

| Scenario | F-061-04 |
| --- | --- |
| Name | A blocking gate is never bypassed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a pipeline gate or check blocks the run |
| When | "/aa-rel-release" reaches it |
| Then | no bypass flag is used |
| And | it fixes the cause or tells the user |

## F-061-05 Verification happens before anything is announced

| Scenario | F-061-05 |
| --- | --- |
| Name | Verification happens before anything is announced |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the pipeline run is green |
| When | "/aa-rel-release" verifies |
| Then | every verification check on the release has a result with evidence |
| And | the identity running in production is confirmed to be the one deployed |
| And | the release is reported done only when the checks pass |

## F-061-06 A failed check rolls back by default

| Scenario | F-061-06 |
| --- | --- |
| Name | A failed check rolls back by default |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a verification check fails in production |
| When | "/aa-rel-release" handles it |
| Then | it returns to the previous known-good identity through the pipeline, or raises an incident where the runbook says rollback is unsafe |
| And | which was done and why is recorded on the release ticket |

## F-061-07 The deployment is recorded

| Scenario | F-061-07 |
| --- | --- |
| Name | The deployment is recorded |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-release" finishes |
| Then | the release ticket and the knowledge base record what was deployed by identity, when, by whom, and with which pipeline run |
| And | the verification report on the release ticket has every check's result |

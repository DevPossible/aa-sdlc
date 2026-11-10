# F-094 Checkpoint full-suite policy

| Feature | F-094 |
| --- | --- |
| Name | Checkpoint full-suite policy |
| Tags | @framework @agent @O-29 @G-04 @G-59 @AP-413 |
| File | checkpoint-full-suite |

The default is a full suite at every branch finish. A project may explicitly choose scoped
merge gates with full-suite checkpoints on its integration branch. A checkpoint changes when
the full run is owed; it does not change what full means or replace release and exposure gates.

## F-094-01 Default branch finish keeps the full suite

| Scenario | F-094-01 |
| --- | --- |
| Name | Default branch finish keeps the full suite |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | testing.fullSuite is absent, its mode is absent, or its mode is per-branch |
| When | "/aa-dev-finish-branch" verifies the branch as it will be merged |
| Then | full build, lint, provenance and every test tier are required |

## F-094-02 Checkpoint branch finish proves the scoped merge gate

| Scenario | F-094-02 |
| --- | --- |
| Name | Checkpoint branch finish proves the scoped merge gate |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | testing.fullSuite selects checkpoint with an integration branch, perMerge gates and checkpointBefore events |
| When | "/aa-dev-finish-branch" verifies a merge into that integration branch |
| Then | it runs build, lint, smoke and the changed components' suites on the candidate as it will be merged |
| And | it also runs the suites pinning every changed public API, schema or shared kernel |
| And | the feature-file provenance check still passes before the merge |
| And | the ticket or linked durable record names the scoped results, integration branch and full run owed at the next checkpoint |

## F-094-03 Each configured event requires a full integration-branch checkpoint

| Scenario | F-094-03 |
| --- | --- |
| Name | Each configured event requires a full integration-branch checkpoint |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | checkpointBefore lists release, exposure and demonstration |
| When | any listed event is about to occur |
| Then | full build, lint, provenance and every test tier must pass on the integration-branch candidate for that event |
| And | changed relevant inputs invalidate earlier proof under G-59 |
| And | the event waits for the full checkpoint and its evidence |

## F-094-04 A backstop bounds the time and merges between full runs

| Scenario | F-094-04 |
| --- | --- |
| Name | A backstop bounds the time and merges between full runs |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | checkpoint mode has a backstop with merges 10 and days 3 |
| When | either bound since the last successful full checkpoint is reached |
| Then | a full integration-branch checkpoint is due before another merge |
| And | if no successful full checkpoint is recorded, one is due before the next merge |
| And | a failed or partial run does not reset either bound |

## F-094-05 A failed checkpoint is fixed forward

| Scenario | F-094-05 |
| --- | --- |
| Name | A failed checkpoint is fixed forward |
| Kind | Scenario |
| Tags | @O-23 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a full integration-branch checkpoint fails |
| When | work continues |
| Then | the failure and affected claims remain recorded and the event remains unproven |
| And | the cause is fixed forward on the integration branch and the affected proof is rerun |
| And | a flaky test gets a defect ticket and distinguishing experiment, never retry-to-green |

## F-094-06 Scoped success is never called a full run

| Scenario | F-094-06 |
| --- | --- |
| Name | Scoped success is never called a full run |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | only the scoped merge gate passed under checkpoint mode |
| When | the evidence is reported |
| Then | it names the candidate, what actually ran, actual results and the outstanding full checkpoint |
| And | it never labels the partial run full or claims release or installed exposure acceptance |

## F-094-07 Configuration cannot weaken the mandatory merge gate

| Scenario | F-094-07 |
| --- | --- |
| Name | Configuration cannot weaken the mandatory merge gate |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a checkpoint config omits build, lint, smoke or changed-components from perMerge |
| When | it is validated against the config schema |
| Then | validation fails and names the invalid configuration |
| And | unknown modes, empty event lists and nonpositive backstop bounds also fail |

## F-094-08 Policy survives config loading writing and scope merging

| Scenario | F-094-08 |
| --- | --- |
| Name | Policy survives config loading writing and scope merging |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an enterprise config selects checkpoint and a project config selects per-branch |
| When | the CLI loads, merges and writes the config |
| Then | the later scope replaces the entire testing.fullSuite policy |
| And | unrelated config writes preserve every configured policy field |
| And | an absent policy leaves the per-branch default in force |

## F-094-09 Release and exposure retain their existing gates

| Scenario | F-094-09 |
| --- | --- |
| Name | Release and exposure retain their existing gates |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a project opts into checkpoint mode |
| When | it prepares a release or exposes an installed artifact |
| Then | existing full-suite, artifact identity, independent acceptance and authorization gates still apply |
| And | omitting release or exposure from checkpointBefore does not waive those gates |

## F-094-10 A merge outside the integration branch retains the default gate

| Scenario | F-094-10 |
| --- | --- |
| Name | A merge outside the integration branch retains the default gate |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | checkpoint mode names develop as the integration branch |
| When | "/aa-dev-finish-branch" verifies a merge targeting a different branch |
| Then | full build, lint, provenance and every test tier remain required |
| And | a missing or malformed checkpoint policy cannot justify deferred proof |

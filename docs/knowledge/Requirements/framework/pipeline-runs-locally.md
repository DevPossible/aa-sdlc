# F-036 Every pipeline step runs locally, exactly

| Feature | F-036 |
| --- | --- |
| Name | Every pipeline step runs locally, exactly |
| Tags | @framework @agent @O-11 @O-06 @T-07 @T-13 |
| File | pipeline-runs-locally |

Every step the delivery pipeline performs can be reproduced exactly on any machine, from the
command line or a local tool, with the same script, the same arguments, and the same inputs.
The pipeline calls scripts that live in the repository and holds no logic of its own. A step
that exists only in the pipeline is a defect.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | root scripts for initialize, build, test, and pack |

## F-036-01 The pipeline calls the root scripts

| Scenario | F-036-01 |
| --- | --- |
| Name | The pipeline calls the root scripts |
| Kind | Scenario |
| Tags | @G-29 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" writes the pipeline configuration |
| Then | every stage calls a root script or a command committed to the repository |
| And | each call uses the same arguments a person would use locally |
| And | no stage contains logic beyond the call |

## F-036-02 A pipeline failure is reproduced locally before it is fixed

| Scenario | F-036-02 |
| --- | --- |
| Name | A pipeline failure is reproduced locally before it is fixed |
| Kind | Scenario |
| Tags | @G-29 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a pipeline stage has failed |
| When | "/aa-dev-fix-bug" or "/aa-dev-finish-branch" addresses the failure |
| Then | the same script is run locally with the same arguments |
| And | the local run shows the same failure |
| And | the fix is proven by the local run before anything is pushed |

## F-036-03 Logic found only in the pipeline is moved out

| Scenario | F-036-03 |
| --- | --- |
| Name | Logic found only in the pipeline is moved out |
| Kind | Scenario |
| Tags | @G-29 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stage in the pipeline configuration contains logic that exists nowhere else |
| When | "/aa-ops-setup-pipeline" or "/aa-dev-setup-environment" reviews the pipeline |
| Then | the logic is moved into a script in the repository |
| And | the stage is changed to call that script |
| And | the script is run locally and its output quoted |

## F-036-04 A step that truly cannot run locally is recorded, with a stand-in

| Scenario | F-036-04 |
| --- | --- |
| Name | A step that truly cannot run locally is recorded, with a stand-in |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stage depends on a signing key held only by the pipeline |
| When | "/aa-ops-setup-pipeline" writes the configuration |
| Then | the stage is recorded as pipeline-only with the reason |
| And | a local stand-in exercises everything up to the point of difference |
| And | the deployment strategy documentation names the stand-in |

## F-036-05 Health reports steps that exist only in the pipeline

| Scenario | F-036-05 |
| --- | --- |
| Name | Health reports steps that exist only in the pipeline |
| Kind | Scenario |
| Tags | @R-24 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stage in the pipeline configuration holds logic of its own |
| When | "/aa-fw-health" runs |
| Then | R-24 is reported as unmet with the stage named |

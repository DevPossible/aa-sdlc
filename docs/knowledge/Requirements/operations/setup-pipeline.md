# F-050 /aa-ops-setup-pipeline builds the path from a merged change to production

| Feature | F-050 |
| --- | --- |
| Name | /aa-ops-setup-pipeline builds the path from a merged change to production |
| Tags | @agent @operations @O-06 @O-11 @O-16 @O-17 @O-21 @O-24 @O-25 |
| File | setup-pipeline |

The pipeline calls the root scripts and holds no logic of its own, runs every test tier and the
lint stage, builds one artifact with an immutable identity and deploys that identity to every
environment with the environment's settings supplied at deploy time, and documents the
deployment strategy and how rollback works for it.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | working root scripts and infrastructure code with one configuration template per environment |

## F-050-01 Every stage is a root script call that ran locally first

| Scenario | F-050-01 |
| --- | --- |
| Name | Every stage is a root script call that ran locally first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" runs |
| Then | each stage calls a script or command in the repository with the same arguments it takes locally |
| And | each of those calls was run locally and its output quoted before the configuration was written |
| And | no logic lives in the pipeline configuration |

## F-050-02 Every test tier runs and any failure fails the run

| Scenario | F-050-02 |
| --- | --- |
| Name | Every test tier runs and any failure fails the run |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" writes the test stages |
| Then | there is a stage for the unit, integration, and end-to-end tiers |
| And | a failure in any tier fails the run |
| And | a stage that is skipped carries a recorded reason |

## F-050-03 The lint stage is the root build with the lint switch

| Scenario | F-050-03 |
| --- | --- |
| Name | The lint stage is the root build with the lint switch |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" writes the lint stage |
| Then | the stage runs the root build with the lint switch |
| And | a finding fails the run rather than being suppressed |

## F-050-04 One artifact is built once and promoted

| Scenario | F-050-04 |
| --- | --- |
| Name | One artifact is built once and promoted |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" writes the deploy stages |
| Then | the pack stage runs once per commit and gives the artifact an immutable identity |
| And | every deploy stage deploys that identity |
| And | no deploy stage builds |

## F-050-05 Environment settings are supplied at deploy time

| Scenario | F-050-05 |
| --- | --- |
| Name | Environment settings are supplied at deploy time |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" writes the deploy stages |
| Then | each deploy stage supplies the environment's settings from its committed template |
| And | secrets come from the pipeline's secret store and none is committed |

## F-050-06 The branches the pipeline deploys from are protected

| Scenario | F-050-06 |
| --- | --- |
| Name | The branches the pipeline deploys from are protected |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" configures branch protection |
| Then | a deploy cannot start from an unreviewed change |
| And | no bypass flag is used on the protection |
| And | any protection the source control tool cannot express is recorded in the strategy document |

## F-050-07 The deployment strategy is documented with its rollback

| Scenario | F-050-07 |
| --- | --- |
| Name | The deployment strategy is documented with its rollback |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" finishes |
| Then | a document in the documents folder states the deployment strategy |
| And | it says how rollback returns to a previous artifact identity rather than a rebuilt tag |

## F-050-08 A failing stage is reproduced locally before anything changes

| Scenario | F-050-08 |
| --- | --- |
| Name | A failing stage is reproduced locally before anything changes |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a stage fails on the first pipeline run |
| When | "/aa-ops-setup-pipeline" handles it |
| Then | the same script is run locally with the same arguments before anything is changed |
| And | nothing is suppressed to reach green |

## F-050-09 The change is staged, not committed

| Scenario | F-050-09 |
| --- | --- |
| Name | The change is staged, not committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" finishes |
| Then | the pipeline configuration, the strategy document, and any script changes are staged as one change set with a Conventional Commit message |
| And | no commit is made unless the user asked for it |
| And | the ticket records what was produced, the run that proved it, and what remains |

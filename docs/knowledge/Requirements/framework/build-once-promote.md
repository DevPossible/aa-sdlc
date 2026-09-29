# F-018 Build once; promote the same artifact

| Feature | F-018 |
| --- | --- |
| Name | Build once; promote the same artifact |
| Tags | @framework @agent @O-24 @O-06 @O-11 @T-07 |
| File | build-once-promote |

A release artifact is built once, from one commit, and given an immutable identity. That
same identity is what every successive environment deploys. Nothing is rebuilt for a later
environment; environment configuration is supplied at deploy time from committed templates.
The release records the identity and validation confirms it is what is running.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a pipeline written by "/aa-ops-setup-pipeline" |

## F-018-01 The pipeline builds once and promotes

| Scenario | F-018-01 |
| --- | --- |
| Name | The pipeline builds once and promotes |
| Kind | Scenario |
| Tags | @G-47 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | a commit is merged to the default branch |
| Then | the pipeline runs the root pack script once |
| And | the artifact is given an immutable identity tied to the commit |
| And | each deploy stage deploys that identity |
| And | no deploy stage runs a build |

## F-018-02 Configuration is supplied at deploy time

| Scenario | F-018-02 |
| --- | --- |
| Name | Configuration is supplied at deploy time |
| Kind | Scenario |
| Tags | @G-47 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the artifact has been deployed to a test environment |
| When | the same artifact is deployed to production |
| Then | the production configuration comes from the committed template for that environment |
| And | the artifact's identity is unchanged |
| And | no environment value is baked into the artifact |

## F-018-03 The release records the identity

| Scenario | F-018-03 |
| --- | --- |
| Name | The release records the identity |
| Kind | Scenario |
| Tags | @G-47 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" assembles the release |
| Then | the release names the artifact identity that was tested |
| And | "/aa-rel-release" deploys that identity and records it |
| And | the deployment record names the identity, not a tag that could be rebuilt |

## F-018-04 Validation confirms what is running

| Scenario | F-018-04 |
| --- | --- |
| Name | Validation confirms what is running |
| Kind | Scenario |
| Tags | @G-47 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-validate-production" runs after a release |
| Then | it reads the identity of the running artifact |
| And | it confirms the identity matches the one the release named |
| And | a mismatch is an incident, not a note |

## F-018-05 Rollback returns to a previous identity

| Scenario | F-018-05 |
| --- | --- |
| Name | Rollback returns to a previous identity |
| Kind | Scenario |
| Tags | @G-47 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a release that failed verification in production |
| When | "/aa-rel-rollback" runs |
| Then | it deploys the previous known-good identity |
| And | it does not rebuild the previous tag |
| And | the rollback record names the identity restored |

## F-018-06 A pipeline that rebuilds per environment is corrected

| Scenario | F-018-06 |
| --- | --- |
| Name | A pipeline that rebuilds per environment is corrected |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a pipeline with a build stage for each environment |
| When | "/aa-ops-setup-pipeline" reviews it |
| Then | it restructures the pipeline to one build stage and promoting deploy stages |
| And | the deployment strategy documentation explains the change |

## F-018-07 A platform that forces a rebuild is a recorded exception

| Scenario | F-018-07 |
| --- | --- |
| Name | A platform that forces a rebuild is a recorded exception |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a deployment platform that can only deploy from a build it performs |
| When | "/aa-ops-setup-pipeline" configures it |
| Then | a decision record explains the constraint and how the built output is verified to match |
| And | the exception is limited to that platform |

## F-018-08 Health reports a rebuild in the promotion path

| Scenario | F-018-08 |
| --- | --- |
| Name | Health reports a rebuild in the promotion path |
| Kind | Scenario |
| Tags | @R-38 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a deploy stage for a later environment runs a build |
| When | "/aa-fw-health" runs |
| Then | R-38 is reported as unmet with the stage named |

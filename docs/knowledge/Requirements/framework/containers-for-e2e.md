# F-020 End-to-end tests run against containers

| Feature | F-020 |
| --- | --- |
| Name | End-to-end tests run against containers |
| Tags | @framework @agent @O-12 @O-07 @O-11 @T-07 |
| File | containers-for-e2e |

The end-to-end tier starts the system and its dependencies in containers, from definitions
committed to the repository, wherever the stack allows. The same definitions serve any
machine and the pipeline, so the e2e tier is one command everywhere and its environment is
part of the repository.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a container runtime is available |

## F-020-01 The e2e tier starts its own environment

| Scenario | F-020-01 |
| --- | --- |
| Name | The e2e tier starts its own environment |
| Kind | Scenario |
| Tags | @G-30 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | container definitions for the system and its dependencies exist in the repository |
| When | "test" is run with the e2e tier |
| Then | the containers are started from those definitions |
| And | the end-to-end tests run against them |
| And | the containers are stopped and removed when the run ends |

## F-020-02 Setting up the environment writes the container definitions

| Scenario | F-020-02 |
| --- | --- |
| Name | Setting up the environment writes the container definitions |
| Kind | Scenario |
| Tags | @G-30 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stack can run in containers |
| When | "/aa-dev-setup-environment" fills in the root scripts |
| Then | container definitions for the system and its dependencies are committed to the repository |
| And | "test" with the e2e tier uses them |
| And | the same definitions are what the pipeline uses |

## F-020-03 The same command runs the same way in the pipeline

| Scenario | F-020-03 |
| --- | --- |
| Name | The same command runs the same way in the pipeline |
| Kind | Scenario |
| Tags | @G-30 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the pipeline's e2e stage calls "test" with the e2e tier |
| When | the stage runs |
| Then | it starts the same containers from the same definitions as a local run |
| And | a failure in the stage can be reproduced locally with the same command |

## F-020-04 A dependency that cannot be containerised is recorded

| Scenario | F-020-04 |
| --- | --- |
| Name | A dependency that cannot be containerised is recorded |
| Kind | Scenario |
| Tags | @G-30 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a dependency has no container image and no faithful stand-in |
| When | "/aa-dev-setup-environment" or "/aa-qa-e2e-tests" reaches it in a shared environment |
| Then | the development environment configuration names the dependency and why |
| And | the tests that depend on it are marked |
| And | every other dependency still runs in containers |

## F-020-05 No container runtime degrades, never blocks

| Scenario | F-020-05 |
| --- | --- |
| Name | No container runtime degrades, never blocks |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no container runtime is available |
| When | "test" is run with the e2e tier |
| Then | it runs against whatever it can reach |
| And | it says that R-25 is unmet and what that means for the results |

## F-020-06 Health reports a repository whose e2e environment is undefined

| Scenario | F-020-06 |
| --- | --- |
| Name | Health reports a repository whose e2e environment is undefined |
| Kind | Scenario |
| Tags | @R-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no container definitions for the system exist in the repository |
| When | "/aa-fw-health" runs |
| Then | R-26 is reported as unmet |
| And | the remedy names "/aa-dev-setup-environment" |

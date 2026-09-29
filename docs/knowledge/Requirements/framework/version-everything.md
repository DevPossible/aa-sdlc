# F-044 Version everything needed to build and operate the software

| Feature | F-044 |
| --- | --- |
| Name | Version everything needed to build and operate the software |
| Tags | @framework @agent @O-16 @O-02 @T-07 |
| File | version-everything |

The repository holds everything required to build, deploy, and run the system: the code,
configuration templates with no secret values, migrations, automation, and the documentation
that operates it. The test is a fresh clone plus the documented secrets. Secrets are never
committed; their templates always are.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | the project is under source control with a remote |

## F-044-01 A fresh clone can build, deploy, and run the system

| Scenario | F-044-01 |
| --- | --- |
| Name | A fresh clone can build, deploy, and run the system |
| Kind | Scenario |
| Tags | @G-37 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a fresh clone of the repository |
| And | the secrets the development environment configuration names |
| When | initialize, build, test, and pack are run |
| And | the deployment is run from the repository's pipeline and infrastructure definitions |
| Then | the system builds, deploys, and runs |
| And | nothing was fetched from a machine, a wiki page, or a person outside the repository |

## F-044-02 A change ships with the migration and the config it needs

| Scenario | F-044-02 |
| --- | --- |
| Name | A change ships with the migration and the config it needs |
| Kind | Scenario |
| Tags | @G-37 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket that adds a database column and a new configuration key |
| When | "/aa-dev-implement" commits the change |
| Then | the migration is committed with the code that needs it |
| And | every environment's configuration template gains the new key |
| And | the development environment configuration says where the key's value comes from |

## F-044-03 Infrastructure and alerts are committed as code

| Scenario | F-044-03 |
| --- | --- |
| Name | Infrastructure and alerts are committed as code |
| Kind | Scenario |
| Tags | @G-37 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-infrastructure" and "/aa-ops-observability" run |
| Then | the infrastructure definitions and alert configuration are in the repository |
| And | every manual operation has a runbook in the documents folder |
| And | each runbook is versioned with the scripts it describes |

## F-044-04 A secret is templated, never committed

| Scenario | F-044-04 |
| --- | --- |
| Name | A secret is templated, never committed |
| Kind | Scenario |
| Tags | @G-38 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the system needs a database password |
| When | "/aa-dev-setup-environment" writes the configuration templates |
| Then | each template names the password key with a placeholder |
| And | the development environment configuration says how a fresh clone obtains the value |
| And | no committed file contains the value |

## F-044-05 A committed secret is rotated and replaced

| Scenario | F-044-05 |
| --- | --- |
| Name | A committed secret is rotated and replaced |
| Kind | Scenario |
| Tags | @G-38 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a secret value is found in a committed file |
| When | "/aa-sec-maintain-security" handles it |
| Then | the secret is rotated |
| And | the value is replaced with a placeholder |
| And | the report names the file and never the value |

## F-044-06 The knowledge base still holds why

| Scenario | F-044-06 |
| --- | --- |
| Name | The knowledge base still holds why |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a decision about how the system is deployed |
| When | it is recorded |
| Then | the decision and its rationale go to the knowledge base |
| And | the runbook and the automation that carry it out go to the repository |
| And | each links to the other |

## F-044-07 Health reports what a fresh clone could not do

| Scenario | F-044-07 |
| --- | --- |
| Name | Health reports what a fresh clone could not do |
| Kind | Scenario |
| Tags | @R-30 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an environment has no configuration template in the repository |
| And | a manual operation has no runbook in the documents folder |
| When | "/aa-fw-health" runs |
| Then | R-30 is reported as unmet |
| And | the report names the missing template and the missing runbook |

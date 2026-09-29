# F-022 Conventions are enforced by tools, not by people

| Feature | F-022 |
| --- | --- |
| Name | Conventions are enforced by tools, not by people |
| Tags | @framework @agent @O-21 @T-09 @T-10 |
| File | conventions-by-tools |

Coding conventions live as formatter and linter configuration committed to the repository.
Formatting is automated on changed files. Linting runs from the root build and the pipeline
calls the same script. A formatter is required; a linter is recommended, and where none is
known for a language the project says so once and health warns rather than blocks.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | formatter and linter configuration committed for the project's languages |

## F-022-01 A change is formatted and linted before it is presented

| Scenario | F-022-01 |
| --- | --- |
| Name | A change is formatted and linted before it is presented |
| Kind | Scenario |
| Tags | @G-44 @G-01 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-implement" reaches a green build |
| Then | the formatter has run on the changed files and no others |
| And | the root build has run with the lint switch and reported no findings |
| And | the staged change is presented for the user to commit |

## F-022-02 A linter finding is fixed or justified, never ignored

| Scenario | F-022-02 |
| --- | --- |
| Name | A linter finding is fixed or justified, never ignored |
| Kind | Scenario |
| Tags | @G-44 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the linter reports a finding on a changed file |
| When | "/aa-dev-implement" handles it |
| Then | the finding is fixed, or a suppression is added beside it with the reason |
| And | the change is not presented with the finding outstanding |

## F-022-03 Style is not argued in review

| Scenario | F-022-03 |
| --- | --- |
| Name | Style is not argued in review |
| Kind | Scenario |
| Tags | @G-44 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merge request whose only stylistic issue is one the formatter would fix |
| When | "/aa-dev-review" reviews it |
| Then | no style comment is made |
| And | the review notes that the formatter did not run on that file, if so |

## F-022-04 The pipeline and the developer run the same lint

| Scenario | F-022-04 |
| --- | --- |
| Name | The pipeline and the developer run the same lint |
| Kind | Scenario |
| Tags | @G-44 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ops-setup-pipeline" writes the lint stage |
| Then | the stage calls the root build with the lint switch |
| And | a lint failure in the pipeline can be reproduced locally with the same command |

## F-022-05 A language with no known linter is recorded, not blocked

| Scenario | F-022-05 |
| --- | --- |
| Name | A language with no known linter is recorded, not blocked |
| Kind | Scenario |
| Tags | @G-44 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project uses a language for which no linter is known |
| When | "/aa-dev-setup-environment" configures the tools |
| Then | the development environment configuration records that no linter is known for that language |
| And | the formatter is still configured for it |
| And | "/aa-fw-health" warns for R-12 and nothing blocks |

## F-022-06 Conventions never live only in a document

| Scenario | F-022-06 |
| --- | --- |
| Name | Conventions never live only in a document |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a style rule that can be expressed as formatter or linter configuration |
| When | it is proposed as a paragraph in a document |
| Then | it is added to the configuration instead |
| And | the document, if any, points to the configuration |

## F-022-07 Enforced by a hook where the target allows

| Scenario | F-022-07 |
| --- | --- |
| Name | Enforced by a hook where the target allows |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the target supports hooks |
| When | "aa setup" installs the framework |
| Then | a pre-commit hook runs the formatter on changed files and the linter |
| And | a failure is reported with its output, never bypassed |

## F-022-08 Health reports a project with no root way to lint

| Scenario | F-022-08 |
| --- | --- |
| Name | Health reports a project with no root way to lint |
| Kind | Scenario |
| Tags | @R-35 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | neither a lint switch on the build script nor a root lint script exists |
| When | "/aa-fw-health" runs |
| Then | R-35 is reported as unmet |
| And | the remedy names "aa init" |

# F-065 Project requirements

| Feature | F-065 |
| --- | --- |
| Name | Project requirements |
| Tags | @requirements @health @project |
| File | project |

What the repository must contain. aa init lays most of these down; /aa-fw-health reports them.

## Background

| Step | Text |
| --- | --- |
| Given | I am in a project directory |

## F-065-01 The project is under source control with a remote

| Scenario | F-065-01 |
| --- | --- |
| Name | The project is under source control with a remote |
| Kind | Scenario |
| Tags | @R-05 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a repository is initialised at the project root |
| And | it has at least one remote |
| When | "/aa-fw-health" probes R-05 |
| Then | R-05 is reported as met |

## F-065-02 The project is not under source control

| Scenario | F-065-02 |
| --- | --- |
| Name | The project is not under source control |
| Kind | Scenario |
| Tags | @R-05 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no repository is initialised at the project root |
| When | "/aa-fw-health" probes R-05 |
| Then | R-05 is reported as unmet |
| And | the remedy is for "aa init" or "/aa-fw-init" to initialise a repository with consent |
| And | the user supplies the remote |

## F-065-03 A documents folder exists

| Scenario | F-065-03 |
| --- | --- |
| Name | A documents folder exists |
| Kind | Scenario |
| Tags | @R-06 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a documents folder exists at the conventional location or the project config names one |
| When | "/aa-fw-health" probes R-06 |
| Then | R-06 is reported as met |

## F-065-04 No documents folder exists

| Scenario | F-065-04 |
| --- | --- |
| Name | No documents folder exists |
| Kind | Scenario |
| Tags | @R-06 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no documents folder exists |
| When | "/aa-fw-health" probes R-06 |
| Then | R-06 is reported as unmet |
| And | the remedy is for "aa init" or "/aa-fw-init" to create it |

## F-065-05 A project config exists

| Scenario | F-065-05 |
| --- | --- |
| Name | A project config exists |
| Kind | Scenario |
| Tags | @R-07 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the config file exists at the project root and parses |
| When | "/aa-fw-health" probes R-07 |
| Then | R-07 is reported as met |

## F-065-06 No project config exists

| Scenario | F-065-06 |
| --- | --- |
| Name | No project config exists |
| Kind | Scenario |
| Tags | @R-07 @required |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no config file exists at the project root |
| When | "/aa-fw-health" probes R-07 |
| Then | R-07 is reported as unmet |
| And | the remedy is for "aa init" to create it from the merged scopes |

## F-065-07 Ticket reference conventions are defined

| Scenario | F-065-07 |
| --- | --- |
| Name | Ticket reference conventions are defined |
| Kind | Scenario |
| Tags | @R-08 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config or the ticket system defines a ticket reference pattern |
| When | "/aa-fw-health" probes R-08 |
| Then | R-08 is reported as met |

## F-065-08 No ticket reference convention is defined

| Scenario | F-065-08 |
| --- | --- |
| Name | No ticket reference convention is defined |
| Kind | Scenario |
| Tags | @R-08 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | neither the project config nor the ticket system defines a pattern |
| When | "/aa-fw-health" probes R-08 |
| Then | R-08 is reported as unmet |
| And | the remedy is for "aa init" to write a default pattern into the project config |

## F-065-09 A features folder exists

| Scenario | F-065-09 |
| --- | --- |
| Name | A features folder exists |
| Kind | Scenario |
| Tags | @R-16 @required @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a features folder exists at the conventional location or the project config names one |
| When | "/aa-fw-health" probes R-16 |
| Then | R-16 is reported as met |

## F-065-10 No features folder exists

| Scenario | F-065-10 |
| --- | --- |
| Name | No features folder exists |
| Kind | Scenario |
| Tags | @R-16 @required @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no features folder exists |
| When | "/aa-fw-health" probes R-16 |
| Then | R-16 is reported as unmet |
| And | the report says requirements cannot be captured as the source of truth until it exists |
| And | the remedy is for "aa init" or "/aa-fw-init" to create it |

## F-065-11 The repository maps to one ticket project

| Scenario | F-065-11 |
| --- | --- |
| Name | The repository maps to one ticket project |
| Kind | Scenario |
| Tags | @R-22 @required @O-09 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the merged config names exactly one ticket project |
| And | the tickets referenced in recent branches and commits resolve within it |
| When | "/aa-fw-health" probes R-22 |
| Then | R-22 is reported as met |

## F-065-12 The repository names no ticket project

| Scenario | F-065-12 |
| --- | --- |
| Name | The repository names no ticket project |
| Kind | Scenario |
| Tags | @R-22 @required @O-09 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the merged config has no ticket project |
| When | "/aa-fw-health" probes R-22 |
| Then | R-22 is reported as unmet |
| And | the remedy is for "aa init" to ask for the project and write it |

## F-065-13 The repository references tickets in more than one project

| Scenario | F-065-13 |
| --- | --- |
| Name | The repository references tickets in more than one project |
| Kind | Scenario |
| Tags | @R-22 @required @O-09 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the config names one ticket project |
| And | branches or commits reference tickets in a different project |
| When | "/aa-fw-health" probes R-22 |
| Then | R-22 is reported as unmet |
| And | the report lists the foreign references |
| And | the remedy is for "/aa-fw-init" to help relink them to tickets in the configured project |

## F-065-14 Every sized ticket carries the thinking behind its size

| Scenario | F-065-14 |
| --- | --- |
| Name | Every sized ticket carries the thinking behind its size |
| Kind | Scenario |
| Tags | @R-23 @required @O-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sample of sized tickets in the configured project |
| And | each has written implementation thinking on the ticket at a depth that matches its stakes |
| And | each size cites that reasoning as its basis |
| When | "/aa-fw-health" probes R-23 |
| Then | R-23 is reported as met |

## F-065-15 A ticket carries a size but no implementation thinking

| Scenario | F-065-15 |
| --- | --- |
| Name | A ticket carries a size but no implementation thinking |
| Kind | Scenario |
| Tags | @R-23 @required @O-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sized ticket in the configured project has no written thought about how it will be built |
| When | "/aa-fw-health" probes R-23 |
| Then | R-23 is reported as unmet |
| And | the report lists the ticket |
| And | the remedy is for the user to write down how it will be built and re-size it, or clear the size |

## F-065-16 A size does not cite its reasoning

| Scenario | F-065-16 |
| --- | --- |
| Name | A size does not cite its reasoning |
| Kind | Scenario |
| Tags | @R-23 @required @O-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sized ticket in the configured project has implementation thinking on it |
| But | the size does not cite it |
| When | "/aa-fw-health" probes R-23 |
| Then | R-23 is reported as unmet |
| And | the report says the size is not linked to its basis |
| And | the remedy is for the user to cite the reasoning from the size, or re-size from it |

## F-065-17 The local end-to-end environment is defined as code

| Scenario | F-065-17 |
| --- | --- |
| Name | The local end-to-end environment is defined as code |
| Kind | Scenario |
| Tags | @R-26 @recommended @O-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a container definition or composition for the system and its dependencies exists in the repository |
| And | "test" with the e2e tier starts it |
| And | the development environment configuration names any dependency reached outside it |
| When | "/aa-fw-health" probes R-26 |
| Then | R-26 is reported as met |

## F-065-18 No local end-to-end environment is defined

| Scenario | F-065-18 |
| --- | --- |
| Name | No local end-to-end environment is defined |
| Kind | Scenario |
| Tags | @R-26 @recommended @O-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no container definition for the system and its dependencies exists in the repository |
| When | "/aa-fw-health" probes R-26 |
| Then | R-26 is reported as unmet |
| And | the report says the e2e tier depends on an environment the repository does not describe |
| And | the remedy is for "/aa-dev-setup-environment" to write one |

## F-065-19 A dependency is reached outside the containers without being recorded

| Scenario | F-065-19 |
| --- | --- |
| Name | A dependency is reached outside the containers without being recorded |
| Kind | Scenario |
| Tags | @R-26 @recommended @O-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the e2e tier reaches a dependency that is not in the container definitions |
| And | the development environment configuration does not name it |
| When | "/aa-fw-health" probes R-26 |
| Then | R-26 is reported as unmet |
| And | the report names the dependency |
| And | the remedy is for the user to containerise it or record it as reached in a shared environment |

## F-065-20 Refined tickets record their revision and started tickets record their check

| Scenario | F-065-20 |
| --- | --- |
| Name | Refined tickets record their revision and started tickets record their check |
| Kind | Scenario |
| Tags | @R-27 @required @O-13 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sample of ready tickets in the configured project each record a repository revision |
| And | a sample of in-progress tickets each record a currency check made at or after work started |
| And | each check names what changed and whether the scenarios and plan still hold |
| When | "/aa-fw-health" probes R-27 |
| Then | R-27 is reported as met |

## F-065-21 A ready ticket records no revision

| Scenario | F-065-21 |
| --- | --- |
| Name | A ready ticket records no revision |
| Kind | Scenario |
| Tags | @R-27 @required @O-13 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ready ticket in the configured project records no repository revision |
| When | "/aa-fw-health" probes R-27 |
| Then | R-27 is reported as unmet |
| And | the report lists the ticket |
| And | the remedy is for "/aa-rf-refine-ticket" or "/aa-ip-plan-implementation" to record the revision the next time it runs |

## F-065-22 Work started on a ticket with no currency check

| Scenario | F-065-22 |
| --- | --- |
| Name | Work started on a ticket with no currency check |
| Kind | Scenario |
| Tags | @R-27 @required @O-13 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an in-progress ticket in the configured project records a revision |
| But | it records no check of that revision against the head at the time work started |
| When | "/aa-fw-health" probes R-27 |
| Then | R-27 is reported as unmet |
| And | the report says the ticket may be building against a repository that has moved |
| And | the remedy is for the user to run the check now and record it |

## F-065-23 Commits follow the configured Conventional Commits format

| Scenario | F-065-23 |
| --- | --- |
| Name | Commits follow the configured Conventional Commits format |
| Kind | Scenario |
| Tags | @R-28 @required @O-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the merged config has a commit pattern and a list of allowed types |
| And | a sample of recent commits on the default branch parse against them |
| When | "/aa-fw-health" probes R-28 |
| Then | R-28 is reported as met |

## F-065-24 The config names no commit format

| Scenario | F-065-24 |
| --- | --- |
| Name | The config names no commit format |
| Kind | Scenario |
| Tags | @R-28 @required @O-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the merged config has no commit pattern or no list of types |
| When | "/aa-fw-health" probes R-28 |
| Then | R-28 is reported as unmet |
| And | the remedy is for "aa init" to write the default pattern and types |

## F-065-25 Commits on the default branch do not conform

| Scenario | F-065-25 |
| --- | --- |
| Name | Commits on the default branch do not conform |
| Kind | Scenario |
| Tags | @R-28 @required @O-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the merged config names the commit format |
| And | recent commits on the default branch do not parse against it |
| When | "/aa-fw-health" probes R-28 |
| Then | R-28 is reported as unmet |
| And | the report lists the non-conforming commits |
| And | the report says prepare-release cannot derive notes or a version from them |
| And | the remedy names a commit-message hook where the target supports hooks |

## F-065-26 Every mock-up names the scenarios it renders

| Scenario | F-065-26 |
| --- | --- |
| Name | Every mock-up names the scenarios it renders |
| Kind | Scenario |
| Tags | @R-29 @required @O-15 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sample of mock-ups linked from tickets and pages each name the scenarios they render |
| And | those scenarios exist in the features folder |
| And | no scenario in the feature files cites an image or design file as its source |
| When | "/aa-fw-health" probes R-29 |
| Then | R-29 is reported as met |

## F-065-27 A mock-up names no scenario

| Scenario | F-065-27 |
| --- | --- |
| Name | A mock-up names no scenario |
| Kind | Scenario |
| Tags | @R-29 @required @O-15 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a mock-up linked from a ticket names no scenario |
| When | "/aa-fw-health" probes R-29 |
| Then | R-29 is reported as unmet |
| And | the report lists the mock-up and the ticket |
| And | the remedy is for "/aa-ux-prototype" to regenerate it from the ticket's scenarios or record the scenarios it renders |

## F-065-28 A scenario was written from a picture

| Scenario | F-065-28 |
| --- | --- |
| Name | A scenario was written from a picture |
| Kind | Scenario |
| Tags | @R-29 @required @O-15 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario in the feature files cites a screenshot or design file as its source |
| When | "/aa-fw-health" probes R-29 |
| Then | R-29 is reported as unmet |
| And | the report names the scenario |
| And | the remedy is for "/aa-ba-discover" to write the goals the picture implies and record what it does not show as questions |

## F-065-29 The project has no user interface

| Scenario | F-065-29 |
| --- | --- |
| Name | The project has no user interface |
| Kind | Scenario |
| Tags | @R-29 @required @O-15 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project has no user interface and no mock-ups |
| When | "/aa-fw-health" probes R-29 |
| Then | R-29 is reported as not applicable |

## F-065-30 The repository holds everything needed to build and operate the software

| Scenario | F-065-30 |
| --- | --- |
| Name | The repository holds everything needed to build and operate the software |
| Kind | Scenario |
| Tags | @R-30 @required @O-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a configuration template exists for each environment the infrastructure names |
| And | no template contains a secret value |
| And | the migrations live in the repository and a script in it applies them |
| And | the pipeline, infrastructure, container, and alert definitions are in the repository |
| And | the documents folder holds a runbook for every manual operation |
| And | the development environment configuration names how each secret is obtained |
| When | "/aa-fw-health" probes R-30 |
| Then | R-30 is reported as met |

## F-065-31 An environment has no configuration template

| Scenario | F-065-31 |
| --- | --- |
| Name | An environment has no configuration template |
| Kind | Scenario |
| Tags | @R-30 @required @O-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the infrastructure names an environment that has no configuration template in the repository |
| When | "/aa-fw-health" probes R-30 |
| Then | R-30 is reported as unmet |
| And | the report names the environment |
| And | the remedy is for the user to commit a template with every key named and no secret values |

## F-065-32 Migrations are applied from outside the repository

| Scenario | F-065-32 |
| --- | --- |
| Name | Migrations are applied from outside the repository |
| Kind | Scenario |
| Tags | @R-30 @required @O-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the schema is changed by scripts that are not in the repository |
| When | "/aa-fw-health" probes R-30 |
| Then | R-30 is reported as unmet |
| And | the report says the schema cannot be reproduced from a fresh clone |
| And | the remedy is for the user to commit the migrations and a script that applies them |

## F-065-33 A manual operation has no runbook in the repository

| Scenario | F-065-33 |
| --- | --- |
| Name | A manual operation has no runbook in the repository |
| Kind | Scenario |
| Tags | @R-30 @required @O-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a manual operation is documented only in the knowledge base or nowhere |
| When | "/aa-fw-health" probes R-30 |
| Then | R-30 is reported as unmet |
| And | the report names the operation |
| And | the remedy is for "/aa-ops-setup-infrastructure" to write the runbook in the documents folder |

## F-065-34 A secret value is committed

| Scenario | F-065-34 |
| --- | --- |
| Name | A secret value is committed |
| Kind | Scenario |
| Tags | @R-30 @required @O-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a file in the repository contains a secret value rather than a placeholder |
| When | "/aa-fw-health" probes R-30 |
| Then | R-30 is reported as unmet |
| And | the report names the file but never the value |
| And | the remedy is for "/aa-sec-maintain-security" to rotate the secret and replace it with a placeholder |

## F-065-35 Commits are the user's, one change each

| Scenario | F-065-35 |
| --- | --- |
| Name | Commits are the user's, one change each |
| Kind | Scenario |
| Tags | @R-31 @required @O-17 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no commit on the default branch has an agent identity as author or committer |
| And | no commit carries a trailer or body line attributing it to an agent |
| And | a sample of recent commits each touch one concern and reference one ticket |
| When | "/aa-fw-health" probes R-31 |
| Then | R-31 is reported as met |

## F-065-36 A commit was made under an agent identity

| Scenario | F-065-36 |
| --- | --- |
| Name | A commit was made under an agent identity |
| Kind | Scenario |
| Tags | @R-31 @required @O-17 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit on the default branch has an agent as author or committer |
| When | "/aa-fw-health" probes R-31 |
| Then | R-31 is reported as unmet |
| And | the report lists the commit |
| And | the remedy is for "aa setup" to configure the target to use the user's identity and never commit unasked |

## F-065-37 A commit carries an agent attribution

| Scenario | F-065-37 |
| --- | --- |
| Name | A commit carries an agent attribution |
| Kind | Scenario |
| Tags | @R-31 @required @O-17 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit on the default branch has a trailer or body line naming an agent as author or generator |
| When | "/aa-fw-health" probes R-31 |
| Then | R-31 is reported as unmet |
| And | the report lists the commit |
| And | the remedy names a commit-message hook where the target supports hooks |

## F-065-38 A commit bundles several concerns

| Scenario | F-065-38 |
| --- | --- |
| Name | A commit bundles several concerns |
| Kind | Scenario |
| Tags | @R-31 @required @O-17 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a recent commit touches two unrelated concerns or references two tickets |
| When | "/aa-fw-health" probes R-31 |
| Then | R-31 is reported as unmet |
| And | the report lists the commit and names guidance G-39 |

## F-065-39 Decision records form one numbered, immutable sequence

| Scenario | F-065-39 |
| --- | --- |
| Name | Decision records form one numbered, immutable sequence |
| Kind | Scenario |
| Tags | @R-32 @required @O-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the decision record location the project config names exists |
| And | it holds a contiguous numbered sequence of dated records |
| And | a sample of records each state context, options, decision, and consequences |
| And | history shows no content change to an accepted record other than a superseded-by link |
| When | "/aa-fw-health" probes R-32 |
| Then | R-32 is reported as met |

## F-065-40 No decision record location exists

| Scenario | F-065-40 |
| --- | --- |
| Name | No decision record location exists |
| Kind | Scenario |
| Tags | @R-32 @required @O-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | neither the documents folder nor the project config provides a decision record location |
| When | "/aa-fw-health" probes R-32 |
| Then | R-32 is reported as unmet |
| And | the remedy is for "aa init" to create the folder with a template and record 0001 |

## F-065-41 A record is missing a section or a number

| Scenario | F-065-41 |
| --- | --- |
| Name | A record is missing a section or a number |
| Kind | Scenario |
| Tags | @R-32 @required @O-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a decision record has no options section or no number in the sequence |
| When | "/aa-fw-health" probes R-32 |
| Then | R-32 is reported as unmet |
| And | the report names the record and what it lacks |

## F-065-42 An accepted record was edited

| Scenario | F-065-42 |
| --- | --- |
| Name | An accepted record was edited |
| Kind | Scenario |
| Tags | @R-32 @required @O-18 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | history shows the content of an accepted decision record changed after acceptance |
| And | the change is not a superseded-by link |
| When | "/aa-fw-health" probes R-32 |
| Then | R-32 is reported as unmet |
| And | the report names the record and the change |
| And | the remedy is to restore the record and write a new one that supersedes it |

## F-065-43 Every change traces to its purpose in both directions

| Scenario | F-065-43 |
| --- | --- |
| Name | Every change traces to its purpose in both directions |
| Kind | Scenario |
| Tags | @R-33 @required @O-19 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a sample of recent commits each reference a ticket that resolves in the configured project |
| And | each such ticket links to at least one scenario, decision record, or page |
| And | each linked scenario carries the ticket tag |
| And | each ticket links back to its commits or merge request |
| When | "/aa-fw-health" probes R-33 |
| Then | R-33 is reported as met |

## F-065-44 A commit references no ticket

| Scenario | F-065-44 |
| --- | --- |
| Name | A commit references no ticket |
| Kind | Scenario |
| Tags | @R-33 @required @O-19 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a recent commit on the default branch references no ticket |
| When | "/aa-fw-health" probes R-33 |
| Then | R-33 is reported as unmet |
| And | the report lists the commit |
| And | the remedy is for the user to create or name the ticket, and names a commit-message hook where the target supports hooks |

## F-065-45 A ticket has no purpose behind it

| Scenario | F-065-45 |
| --- | --- |
| Name | A ticket has no purpose behind it |
| Kind | Scenario |
| Tags | @R-33 @required @O-19 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket referenced by recent commits links to no scenario, decision record, or page |
| When | "/aa-fw-health" probes R-33 |
| Then | R-33 is reported as unmet |
| And | the report lists the ticket |
| And | the remedy is for the user to link the scenario it satisfies or write the decision record that explains it |

## F-065-46 The chain is broken on the way back

| Scenario | F-065-46 |
| --- | --- |
| Name | The chain is broken on the way back |
| Kind | Scenario |
| Tags | @R-33 @required @O-19 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario is linked from a ticket but carries no ticket tag |
| When | "/aa-fw-health" probes R-33 |
| Then | R-33 is reported as unmet |
| And | the report names the scenario and cites guidance G-19 |

## F-065-47 Every component in the architecture is required by something

| Scenario | F-065-47 |
| --- | --- |
| Name | Every component in the architecture is required by something |
| Kind | Scenario |
| Tags | @R-34 @required @O-20 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the system architecture document maps each component, boundary, and extension point to a scenario or a decision record |
| And | no entry is unmapped |
| When | "/aa-fw-health" probes R-34 |
| Then | R-34 is reported as met |

## F-065-48 A component serves no scenario

| Scenario | F-065-48 |
| --- | --- |
| Name | A component serves no scenario |
| Kind | Scenario |
| Tags | @R-34 @required @O-20 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the architecture names an extension point that maps to no scenario and no decision record |
| When | "/aa-fw-health" probes R-34 |
| Then | R-34 is reported as unmet |
| And | the report names the entry |
| And | the remedy is for "/aa-ta-architect" to remove it or for "/aa-ta-decide" to record why it stays |

## F-065-49 The architecture has not been written yet

| Scenario | F-065-49 |
| --- | --- |
| Name | The architecture has not been written yet |
| Kind | Scenario |
| Tags | @R-34 @required @O-20 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | "/aa-ta-architect" has not run and no architecture document exists |
| When | "/aa-fw-health" probes R-34 |
| Then | R-34 is reported as not applicable |

## F-065-50 Environment and functional settings are kept apart

| Scenario | F-065-50 |
| --- | --- |
| Name | Environment and functional settings are kept apart |
| Kind | Scenario |
| Tags | @R-39 @required @O-25 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an environment template exists for each named environment and they share one key set |
| And | every environment key differs in value between at least two environments or is a credential placeholder |
| And | the application configuration contains no endpoint, connection string, resource name, or credential key |
| And | no key appears in both places |
| When | "/aa-fw-health" probes R-39 |
| Then | R-39 is reported as met |

## F-065-51 A functional setting is in an environment file

| Scenario | F-065-51 |
| --- | --- |
| Name | A functional setting is in an environment file |
| Kind | Scenario |
| Tags | @R-39 @required @O-25 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a timeout or limit appears in the environment templates with the same value in every environment |
| And | no decision record explains it |
| When | "/aa-fw-health" probes R-39 |
| Then | R-39 is reported as unmet |
| And | the report names the key and says it belongs in the application configuration |
| And | the remedy is for "/aa-dev-setup-environment" to move it |

## F-065-52 An environment setting is in the application configuration

| Scenario | F-065-52 |
| --- | --- |
| Name | An environment setting is in the application configuration |
| Kind | Scenario |
| Tags | @R-39 @required @O-25 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a connection string or endpoint appears in the committed application configuration |
| When | "/aa-fw-health" probes R-39 |
| Then | R-39 is reported as unmet |
| And | the report names the key and says it belongs in the environment file for each environment |
| And | the remedy is to move it to the environment templates as a key with a placeholder |

## F-065-53 A key lives in both places

| Scenario | F-065-53 |
| --- | --- |
| Name | A key lives in both places |
| Kind | Scenario |
| Tags | @R-39 @required @O-25 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the same key appears in the application configuration and in an environment template |
| When | "/aa-fw-health" probes R-39 |
| Then | R-39 is reported as unmet |
| And | the report names the key and asks which kind of setting it is |

## F-065-54 The repository follows the conventional structure

| Scenario | F-065-54 |
| --- | --- |
| Name | The repository follows the conventional structure |
| Kind | Scenario |
| Tags | @R-18 @required @O-05 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the documents, features, scripts, source, and tests folders exist at the root |
| And | the source folder has one subfolder per project |
| When | "/aa-fw-health" probes R-18 |
| Then | R-18 is reported as met |

## F-065-55 The repository maps an existing layout to the convention

| Scenario | F-065-55 |
| --- | --- |
| Name | The repository maps an existing layout to the convention |
| Kind | Scenario |
| Tags | @R-18 @required @O-05 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the repository predates the framework and uses different folder names |
| And | the project config maps each conventional folder to its equivalent |
| When | "/aa-fw-health" probes R-18 |
| Then | R-18 is reported as met |
| And | the report shows the mapping |

## F-065-56 The repository does not follow the conventional structure

| Scenario | F-065-56 |
| --- | --- |
| Name | The repository does not follow the conventional structure |
| Kind | Scenario |
| Tags | @R-18 @required @O-05 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a conventional folder is missing and the project config does not map it |
| When | "/aa-fw-health" probes R-18 |
| Then | R-18 is reported as unmet |
| And | the report names the missing folders |
| And | the remedy is for "aa init" to create them or "/aa-fw-init" to propose a mapping |

## F-065-57 Every scenario is named by a test

| Scenario | F-065-57 |
| --- | --- |
| Name | Every scenario is named by a test |
| Kind | Scenario |
| Tags | @R-40 @recommended @O-01 @O-07 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | every scenario id in the features folder appears in at least one automated test |
| When | "/aa-fw-health" probes R-40 |
| Then | R-40 is reported as met |
| And | the report gives the count of scenarios covered and the total |

## F-065-58 Some scenarios are named by no test

| Scenario | F-065-58 |
| --- | --- |
| Name | Some scenarios are named by no test |
| Kind | Scenario |
| Tags | @R-40 @recommended @O-01 @O-07 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario id in the features folder appears in no automated test |
| When | "/aa-fw-health" probes R-40 |
| Then | R-40 is reported as unmet |
| And | the report lists the uncovered scenario ids with their features |
| And | the remedy is "/aa-qa-generate-tests" with those ids |

## F-065-59 Scenarios proven another way are not counted as gaps

| Scenario | F-065-59 |
| --- | --- |
| Name | Scenarios proven another way are not counted as gaps |
| Kind | Scenario |
| Tags | @R-40 @recommended |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the development environment configuration records that some features are executed directly or reviewed as contracts |
| When | "/aa-fw-health" probes R-40 |
| Then | those scenarios are reported as not applicable, citing the configuration |
| And | the remaining scenarios are counted as usual |

## F-065-60 The ticket kinds and states are mapped to the ticket system

| Scenario | F-065-60 |
| --- | --- |
| Name | The ticket kinds and states are mapped to the ticket system |
| Kind | Scenario |
| Tags | @R-41 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config maps every ticket kind and life-cycle state |
| And | reading the ticket project finds each mapped issue type and workflow state |
| When | "/aa-fw-health" probes R-41 |
| Then | R-41 is reported as met |

## F-065-61 A mapped state does not exist in the ticket system

| Scenario | F-065-61 |
| --- | --- |
| Name | A mapped state does not exist in the ticket system |
| Kind | Scenario |
| Tags | @R-41 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config maps the state In review to a name the ticket project's workflow does not have |
| When | "/aa-fw-health" probes R-41 |
| Then | R-41 is reported as unmet |
| And | the report names the state and the missing name |
| And | the remedy is "/aa-fw-init", which matches the mapping to the ticket system with the user |

## F-065-62 The knowledge base has the six sections

| Scenario | F-065-62 |
| --- | --- |
| Name | The knowledge base has the six sections |
| Kind | Scenario |
| Tags | @R-42 @recommended @O-27 |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | the project's knowledge base space has a top-level page for each section, by its own name or its mapped name |
| When | "/aa-fw-health" probes R-42 |
| Then | R-42 is reported as met |

## F-065-63 A section is missing from the knowledge base

| Scenario | F-065-63 |
| --- | --- |
| Name | A section is missing from the knowledge base |
| Kind | Scenario |
| Tags | @R-42 @recommended @O-27 |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | the project's knowledge base space has no Operations section under any mapped name |
| When | "/aa-fw-health" probes R-42 |
| Then | R-42 is reported as unmet |
| And | the remedy is "/aa-fw-init", which offers to create the missing sections |

## F-065-64 The ticket project can carry the life cycle

| Scenario | F-065-64 |
| --- | --- |
| Name | The ticket project can carry the life cycle |
| Kind | Scenario |
| Tags | @R-43 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config maps every ticket kind and life-cycle state (R-41) |
| And | reading the ticket project's workflow finds seven distinct states for the seven life-cycle states |
| And | the workflow lets a ticket move from each state to the next, and back from In review to In progress |
| And | an epic can be the parent of a story and a story the parent of a task |
| And | where the ticket system shows the project on a board, every mapped state has a place on it |
| When | "/aa-fw-health" probes R-43 |
| Then | R-43 is reported as met |

## F-065-65 Two life-cycle states share one workflow state

| Scenario | F-065-65 |
| --- | --- |
| Name | Two life-cycle states share one workflow state |
| Kind | Scenario |
| Tags | @R-43 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project's workflow has only three states, such as a new board's default |
| And | the project config maps Refined and Planned to the same state |
| When | "/aa-fw-health" probes R-43 |
| Then | R-43 is reported as unmet |
| And | the report names the life-cycle states that share a workflow state |
| And | the remedy is "/aa-fw-init", which proposes the missing states for the ticket project |

## F-065-66 The workflow cannot make a move a step makes

| Scenario | F-065-66 |
| --- | --- |
| Name | The workflow cannot make a move a step makes |
| Kind | Scenario |
| Tags | @R-43 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project's workflow has no way to move a ticket from Planned to In progress |
| When | "/aa-fw-health" probes R-43 |
| Then | R-43 is reported as unmet |
| And | the report names the move and the step that makes it |
| And | the remedy is "/aa-fw-init" |

## F-065-67 A ticket kind cannot hold its children

| Scenario | F-065-67 |
| --- | --- |
| Name | A ticket kind cannot hold its children |
| Kind | Scenario |
| Tags | @R-43 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project cannot make a story the child of an epic |
| When | "/aa-fw-health" probes R-43 |
| Then | R-43 is reported as unmet |
| And | the report names the kinds and the missing parent link |

## F-065-68 The board hides a state

| Scenario | F-065-68 |
| --- | --- |
| Name | The board hides a state |
| Kind | Scenario |
| Tags | @R-43 @required @O-26 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project's board has no place for the state In review is mapped to |
| When | "/aa-fw-health" probes R-43 |
| Then | R-43 is reported as unmet |
| And | the report names the state a ticket would disappear into |

## F-065-69 The configuration can be read but not changed by this user

| Scenario | F-065-69 |
| --- | --- |
| Name | The configuration can be read but not changed by this user |
| Kind | Scenario |
| Tags | @R-43 @required @O-26 @T-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project is misconfigured and the user cannot administer it |
| When | "/aa-fw-health" probes R-43 |
| Then | R-43 is reported as unmet |
| And | the remedy lists each change for the ticket project's administrator to make |

## F-065-70 The project names a tool for every category it needs

| Scenario | F-065-70 |
| --- | --- |
| Name | The project names a tool for every category it needs |
| Kind | Scenario |
| Tags | @R-44 @required @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config lists its tools, each with a category, a minimum version, and a command that checks it |
| And | there is a shell for the root scripts, a source control client, and a connector for the ticket system and the knowledge base |
| And | for each language in the project there is a build toolchain, a package manager, a formatter, and a static analyser |
| And | there is a tool that runs the feature files |
| When | "/aa-fw-health" probes R-44 |
| Then | R-44 is reported as met |

## F-065-71 A category has no tool

| Scenario | F-065-71 |
| --- | --- |
| Name | A category has no tool |
| Kind | Scenario |
| Tags | @R-44 @required @O-21 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project has C# code and the project config lists no formatter for C# |
| When | "/aa-fw-health" probes R-44 |
| Then | R-44 is reported as unmet |
| And | the report names the language and the category |
| And | the remedy is "/aa-fw-init", which proposes tools for the user to choose from |

## F-065-72 The project's root page has the six sections

| Scenario | F-065-72 |
| --- | --- |
| Name | The project's root page has the six sections |
| Kind | Scenario |
| Tags | @R-42 @recommended @O-27 @T-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config names the project's root page in the knowledge base |
| And | each of the six sections is a page under it, by its own name or its mapped name |
| When | "/aa-fw-health" probes R-42 |
| Then | R-42 is reported as met |
| And | no page outside the project's root is read |

## F-065-73 A section is missing under the project's root

| Scenario | F-065-73 |
| --- | --- |
| Name | A section is missing under the project's root |
| Kind | Scenario |
| Tags | @R-42 @recommended @O-27 @T-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project's root page has no Operations section under any mapped name |
| When | "/aa-fw-health" probes R-42 |
| Then | R-42 is reported as unmet |
| And | the remedy is "/aa-fw-init", which offers to create the missing sections under the project's root and never restructures a shared space |

## F-065-74 Every feature file was pulled from its page

| Scenario | F-065-74 |
| --- | --- |
| Name | Every feature file was pulled from its page |
| Kind | Scenario |
| Tags | @R-46 @required @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | every feature file carries a provenance header, matches its checksum, and is generated by a page |
| When | "/aa-fw-health" probes R-46 |
| Then | R-46 is reported as met |

## F-065-75 A feature file was edited in the repository

| Scenario | F-065-75 |
| --- | --- |
| Name | A feature file was edited in the repository |
| Kind | Scenario |
| Tags | @R-46 @required @T-12 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a feature file whose body no longer matches its checksum, or that has no provenance header |
| When | "/aa-fw-health" probes R-46 |
| Then | R-46 is reported as unmet |
| And | the report names each file |
| And | the remedy is to change the page and pull it, or to seed pages from feature files that predate the knowledge base |

## F-065-76 A shared ticket workflow is changed only by its owner

| Scenario | F-065-76 |
| --- | --- |
| Name | A shared ticket workflow is changed only by its owner |
| Kind | Scenario |
| Tags | @R-43 @required @T-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project's workflow is shared with other projects |
| And | it cannot carry the life cycle |
| When | "/aa-fw-init" continues |
| Then | it names each change for the workflow's owner and makes none of them itself unless the owner has consented |

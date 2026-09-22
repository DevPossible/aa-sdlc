@requirements @project
Feature: Project requirements
  What the repository must contain. aa init lays most of these down; /aa-fw-health reports them.

  Background:
    Given I am in a project directory

  @R-05 @required
  Scenario: The project is under source control with a remote
    Given a repository is initialised at the project root
    And it has at least one remote
    When "/aa-fw-health" probes R-05
    Then R-05 is reported as met

  @R-05 @required
  Scenario: The project is not under source control
    Given no repository is initialised at the project root
    When "/aa-fw-health" probes R-05
    Then R-05 is reported as unmet
    And the remedy is for "aa init" or "/aa-fw-init" to initialise a repository with consent
    And the user supplies the remote

  @R-06 @required
  Scenario: A documents folder exists
    Given a documents folder exists at the conventional location or the project config names one
    When "/aa-fw-health" probes R-06
    Then R-06 is reported as met

  @R-06 @required
  Scenario: No documents folder exists
    Given no documents folder exists
    When "/aa-fw-health" probes R-06
    Then R-06 is reported as unmet
    And the remedy is for "aa init" or "/aa-fw-init" to create it

  @R-07 @required
  Scenario: A project config exists
    Given the config file exists at the project root and parses
    When "/aa-fw-health" probes R-07
    Then R-07 is reported as met

  @R-07 @required
  Scenario: No project config exists
    Given no config file exists at the project root
    When "/aa-fw-health" probes R-07
    Then R-07 is reported as unmet
    And the remedy is for "aa init" to create it from the merged scopes

  @R-08 @recommended
  Scenario: Ticket reference conventions are defined
    Given the project config or the ticket system defines a ticket reference pattern
    When "/aa-fw-health" probes R-08
    Then R-08 is reported as met

  @R-08 @recommended
  Scenario: No ticket reference convention is defined
    Given neither the project config nor the ticket system defines a pattern
    When "/aa-fw-health" probes R-08
    Then R-08 is reported as unmet
    And the remedy is for "aa init" to write a default pattern into the project config

  @R-16 @required @T-12
  Scenario: A features folder exists
    Given a features folder exists at the conventional location or the project config names one
    When "/aa-fw-health" probes R-16
    Then R-16 is reported as met

  @R-16 @required @T-12
  Scenario: No features folder exists
    Given no features folder exists
    When "/aa-fw-health" probes R-16
    Then R-16 is reported as unmet
    And the report says requirements cannot be captured as the source of truth until it exists
    And the remedy is for "aa init" or "/aa-fw-init" to create it

  @R-22 @required @O-09
  Scenario: The repository maps to one ticket project
    Given the merged config names exactly one ticket project
    And the tickets referenced in recent branches and commits resolve within it
    When "/aa-fw-health" probes R-22
    Then R-22 is reported as met

  @R-22 @required @O-09
  Scenario: The repository names no ticket project
    Given the merged config has no ticket project
    When "/aa-fw-health" probes R-22
    Then R-22 is reported as unmet
    And the remedy is for "aa init" to ask for the project and write it

  @R-22 @required @O-09
  Scenario: The repository references tickets in more than one project
    Given the config names one ticket project
    And branches or commits reference tickets in a different project
    When "/aa-fw-health" probes R-22
    Then R-22 is reported as unmet
    And the report lists the foreign references
    And the remedy is for "/aa-fw-init" to help relink them to tickets in the configured project

  @R-23 @required @O-10
  Scenario: Every sized ticket carries the thinking behind its size
    Given a sample of sized tickets in the configured project
    And each has written implementation thinking on the ticket at a depth that matches its stakes
    And each size cites that reasoning as its basis
    When "/aa-fw-health" probes R-23
    Then R-23 is reported as met

  @R-23 @required @O-10
  Scenario: A ticket carries a size but no implementation thinking
    Given a sized ticket in the configured project has no written thought about how it will be built
    When "/aa-fw-health" probes R-23
    Then R-23 is reported as unmet
    And the report lists the ticket
    And the remedy is for the user to write down how it will be built and re-size it, or clear the size

  @R-23 @required @O-10
  Scenario: A size does not cite its reasoning
    Given a sized ticket in the configured project has implementation thinking on it
    But the size does not cite it
    When "/aa-fw-health" probes R-23
    Then R-23 is reported as unmet
    And the report says the size is not linked to its basis
    And the remedy is for the user to cite the reasoning from the size, or re-size from it

  @R-26 @recommended @O-12
  Scenario: The local end-to-end environment is defined as code
    Given a container definition or composition for the system and its dependencies exists in the repository
    And "test" with the e2e tier starts it
    And the development environment configuration names any dependency reached outside it
    When "/aa-fw-health" probes R-26
    Then R-26 is reported as met

  @R-26 @recommended @O-12
  Scenario: No local end-to-end environment is defined
    Given no container definition for the system and its dependencies exists in the repository
    When "/aa-fw-health" probes R-26
    Then R-26 is reported as unmet
    And the report says the e2e tier depends on an environment the repository does not describe
    And the remedy is for "/aa-dev-setup-environment" to write one

  @R-26 @recommended @O-12
  Scenario: A dependency is reached outside the containers without being recorded
    Given the e2e tier reaches a dependency that is not in the container definitions
    And the development environment configuration does not name it
    When "/aa-fw-health" probes R-26
    Then R-26 is reported as unmet
    And the report names the dependency
    And the remedy is for the user to containerise it or record it as reached in a shared environment

  @R-27 @required @O-13
  Scenario: Refined tickets record their revision and started tickets record their check
    Given a sample of ready tickets in the configured project each record a repository revision
    And a sample of in-progress tickets each record a currency check made at or after work started
    And each check names what changed and whether the scenarios and plan still hold
    When "/aa-fw-health" probes R-27
    Then R-27 is reported as met

  @R-27 @required @O-13
  Scenario: A ready ticket records no revision
    Given a ready ticket in the configured project records no repository revision
    When "/aa-fw-health" probes R-27
    Then R-27 is reported as unmet
    And the report lists the ticket
    And the remedy is for "/aa-rf-refine-ticket" or "/aa-ip-plan-implementation" to record the revision the next time it runs

  @R-27 @required @O-13
  Scenario: Work started on a ticket with no currency check
    Given an in-progress ticket in the configured project records a revision
    But it records no check of that revision against the head at the time work started
    When "/aa-fw-health" probes R-27
    Then R-27 is reported as unmet
    And the report says the ticket may be building against a repository that has moved
    And the remedy is for the user to run the check now and record it

  @R-28 @required @O-14
  Scenario: Commits follow the configured Conventional Commits format
    Given the merged config has a commit pattern and a list of allowed types
    And a sample of recent commits on the default branch parse against them
    When "/aa-fw-health" probes R-28
    Then R-28 is reported as met

  @R-28 @required @O-14
  Scenario: The config names no commit format
    Given the merged config has no commit pattern or no list of types
    When "/aa-fw-health" probes R-28
    Then R-28 is reported as unmet
    And the remedy is for "aa init" to write the default pattern and types

  @R-28 @required @O-14
  Scenario: Commits on the default branch do not conform
    Given the merged config names the commit format
    And recent commits on the default branch do not parse against it
    When "/aa-fw-health" probes R-28
    Then R-28 is reported as unmet
    And the report lists the non-conforming commits
    And the report says prepare-release cannot derive notes or a version from them
    And the remedy names a commit-message hook where the target supports hooks

  @R-29 @required @O-15
  Scenario: Every mock-up names the scenarios it renders
    Given a sample of mock-ups linked from tickets and pages each name the scenarios they render
    And those scenarios exist in the features folder
    And no scenario in the feature files cites an image or design file as its source
    When "/aa-fw-health" probes R-29
    Then R-29 is reported as met

  @R-29 @required @O-15
  Scenario: A mock-up names no scenario
    Given a mock-up linked from a ticket names no scenario
    When "/aa-fw-health" probes R-29
    Then R-29 is reported as unmet
    And the report lists the mock-up and the ticket
    And the remedy is for "/aa-ux-prototype" to regenerate it from the ticket's scenarios or record the scenarios it renders

  @R-29 @required @O-15
  Scenario: A scenario was written from a picture
    Given a scenario in the feature files cites a screenshot or design file as its source
    When "/aa-fw-health" probes R-29
    Then R-29 is reported as unmet
    And the report names the scenario
    And the remedy is for "/aa-ba-discover" to write the goals the picture implies and record what it does not show as questions

  @R-29 @required @O-15
  Scenario: The project has no user interface
    Given the project has no user interface and no mock-ups
    When "/aa-fw-health" probes R-29
    Then R-29 is reported as not applicable

  @R-30 @required @O-16
  Scenario: The repository holds everything needed to build and operate the software
    Given a configuration template exists for each environment the infrastructure names
    And no template contains a secret value
    And the migrations live in the repository and a script in it applies them
    And the pipeline, infrastructure, container, and alert definitions are in the repository
    And the documents folder holds a runbook for every manual operation
    And the development environment configuration names how each secret is obtained
    When "/aa-fw-health" probes R-30
    Then R-30 is reported as met

  @R-30 @required @O-16
  Scenario: An environment has no configuration template
    Given the infrastructure names an environment that has no configuration template in the repository
    When "/aa-fw-health" probes R-30
    Then R-30 is reported as unmet
    And the report names the environment
    And the remedy is for the user to commit a template with every key named and no secret values

  @R-30 @required @O-16
  Scenario: Migrations are applied from outside the repository
    Given the schema is changed by scripts that are not in the repository
    When "/aa-fw-health" probes R-30
    Then R-30 is reported as unmet
    And the report says the schema cannot be reproduced from a fresh clone
    And the remedy is for the user to commit the migrations and a script that applies them

  @R-30 @required @O-16
  Scenario: A manual operation has no runbook in the repository
    Given a manual operation is documented only in the knowledge base or nowhere
    When "/aa-fw-health" probes R-30
    Then R-30 is reported as unmet
    And the report names the operation
    And the remedy is for "/aa-ops-setup-infrastructure" to write the runbook in the documents folder

  @R-30 @required @O-16
  Scenario: A secret value is committed
    Given a file in the repository contains a secret value rather than a placeholder
    When "/aa-fw-health" probes R-30
    Then R-30 is reported as unmet
    And the report names the file but never the value
    And the remedy is for "/aa-sec-maintain-security" to rotate the secret and replace it with a placeholder

  @R-31 @required @O-17
  Scenario: Commits are the user's, one change each
    Given no commit on the default branch has an agent identity as author or committer
    And no commit carries a trailer or body line attributing it to an agent
    And a sample of recent commits each touch one concern and reference one ticket
    When "/aa-fw-health" probes R-31
    Then R-31 is reported as met

  @R-31 @required @O-17
  Scenario: A commit was made under an agent identity
    Given a commit on the default branch has an agent as author or committer
    When "/aa-fw-health" probes R-31
    Then R-31 is reported as unmet
    And the report lists the commit
    And the remedy is for "aa setup" to configure the target to use the user's identity and never commit unasked

  @R-31 @required @O-17
  Scenario: A commit carries an agent attribution
    Given a commit on the default branch has a trailer or body line naming an agent as author or generator
    When "/aa-fw-health" probes R-31
    Then R-31 is reported as unmet
    And the report lists the commit
    And the remedy names a commit-message hook where the target supports hooks

  @R-31 @required @O-17
  Scenario: A commit bundles several concerns
    Given a recent commit touches two unrelated concerns or references two tickets
    When "/aa-fw-health" probes R-31
    Then R-31 is reported as unmet
    And the report lists the commit and names guidance G-39

  @R-32 @required @O-18
  Scenario: Decision records form one numbered, immutable sequence
    Given the decision record location the project config names exists
    And it holds a contiguous numbered sequence of dated records
    And a sample of records each state context, options, decision, and consequences
    And history shows no content change to an accepted record other than a superseded-by link
    When "/aa-fw-health" probes R-32
    Then R-32 is reported as met

  @R-32 @required @O-18
  Scenario: No decision record location exists
    Given neither the documents folder nor the project config provides a decision record location
    When "/aa-fw-health" probes R-32
    Then R-32 is reported as unmet
    And the remedy is for "aa init" to create the folder with a template and record 0001

  @R-32 @required @O-18
  Scenario: A record is missing a section or a number
    Given a decision record has no options section or no number in the sequence
    When "/aa-fw-health" probes R-32
    Then R-32 is reported as unmet
    And the report names the record and what it lacks

  @R-32 @required @O-18
  Scenario: An accepted record was edited
    Given history shows the content of an accepted decision record changed after acceptance
    And the change is not a superseded-by link
    When "/aa-fw-health" probes R-32
    Then R-32 is reported as unmet
    And the report names the record and the change
    And the remedy is to restore the record and write a new one that supersedes it

  @R-33 @required @O-19
  Scenario: Every change traces to its purpose in both directions
    Given a sample of recent commits each reference a ticket that resolves in the configured project
    And each such ticket links to at least one scenario, decision record, or page
    And each linked scenario carries the ticket tag
    And each ticket links back to its commits or merge request
    When "/aa-fw-health" probes R-33
    Then R-33 is reported as met

  @R-33 @required @O-19
  Scenario: A commit references no ticket
    Given a recent commit on the default branch references no ticket
    When "/aa-fw-health" probes R-33
    Then R-33 is reported as unmet
    And the report lists the commit
    And the remedy is for the user to create or name the ticket, and names a commit-message hook where the target supports hooks

  @R-33 @required @O-19
  Scenario: A ticket has no purpose behind it
    Given a ticket referenced by recent commits links to no scenario, decision record, or page
    When "/aa-fw-health" probes R-33
    Then R-33 is reported as unmet
    And the report lists the ticket
    And the remedy is for the user to link the scenario it satisfies or write the decision record that explains it

  @R-33 @required @O-19
  Scenario: The chain is broken on the way back
    Given a scenario is linked from a ticket but carries no ticket tag
    When "/aa-fw-health" probes R-33
    Then R-33 is reported as unmet
    And the report names the scenario and cites guidance G-19

  @R-34 @required @O-20
  Scenario: Every component in the architecture is required by something
    Given the system architecture document maps each component, boundary, and extension point to a scenario or a decision record
    And no entry is unmapped
    When "/aa-fw-health" probes R-34
    Then R-34 is reported as met

  @R-34 @required @O-20
  Scenario: A component serves no scenario
    Given the architecture names an extension point that maps to no scenario and no decision record
    When "/aa-fw-health" probes R-34
    Then R-34 is reported as unmet
    And the report names the entry
    And the remedy is for "/aa-ta-architect" to remove it or for "/aa-ta-decide" to record why it stays

  @R-34 @required @O-20
  Scenario: The architecture has not been written yet
    Given "/aa-ta-architect" has not run and no architecture document exists
    When "/aa-fw-health" probes R-34
    Then R-34 is reported as not applicable

  @R-39 @required @O-25
  Scenario: Environment and functional settings are kept apart
    Given an environment template exists for each named environment and they share one key set
    And every environment key differs in value between at least two environments or is a credential placeholder
    And the application configuration contains no endpoint, connection string, resource name, or credential key
    And no key appears in both places
    When "/aa-fw-health" probes R-39
    Then R-39 is reported as met

  @R-39 @required @O-25
  Scenario: A functional setting is in an environment file
    Given a timeout or limit appears in the environment templates with the same value in every environment
    And no decision record explains it
    When "/aa-fw-health" probes R-39
    Then R-39 is reported as unmet
    And the report names the key and says it belongs in the application configuration
    And the remedy is for "/aa-dev-setup-environment" to move it

  @R-39 @required @O-25
  Scenario: An environment setting is in the application configuration
    Given a connection string or endpoint appears in the committed application configuration
    When "/aa-fw-health" probes R-39
    Then R-39 is reported as unmet
    And the report names the key and says it belongs in the environment file for each environment
    And the remedy is to move it to the environment templates as a key with a placeholder

  @R-39 @required @O-25
  Scenario: A key lives in both places
    Given the same key appears in the application configuration and in an environment template
    When "/aa-fw-health" probes R-39
    Then R-39 is reported as unmet
    And the report names the key and asks which kind of setting it is

  @R-18 @required @O-05
  Scenario: The repository follows the conventional structure
    Given the documents, features, scripts, source, and tests folders exist at the root
    And the source folder has one subfolder per project
    When "/aa-fw-health" probes R-18
    Then R-18 is reported as met

  @R-18 @required @O-05
  Scenario: The repository maps an existing layout to the convention
    Given the repository predates the framework and uses different folder names
    And the project config maps each conventional folder to its equivalent
    When "/aa-fw-health" probes R-18
    Then R-18 is reported as met
    And the report shows the mapping

  @R-18 @required @O-05
  Scenario: The repository does not follow the conventional structure
    Given a conventional folder is missing and the project config does not map it
    When "/aa-fw-health" probes R-18
    Then R-18 is reported as unmet
    And the report names the missing folders
    And the remedy is for "aa init" to create them or "/aa-fw-init" to propose a mapping

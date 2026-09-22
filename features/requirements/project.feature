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

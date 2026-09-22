@requirements @project
Feature: Project requirements
  What the repository must contain. aa init lays most of these down; /aa-health reports them.

  Background:
    Given I am in a project directory

  @R-05 @required
  Scenario: The project is under source control with a remote
    Given a repository is initialised at the project root
    And it has at least one remote
    When "/aa-health" probes R-05
    Then R-05 is reported as met

  @R-05 @required
  Scenario: The project is not under source control
    Given no repository is initialised at the project root
    When "/aa-health" probes R-05
    Then R-05 is reported as unmet
    And the remedy is for "aa init" or "/aa-init" to initialise a repository with consent
    And the user supplies the remote

  @R-06 @required
  Scenario: A documents folder exists
    Given a documents folder exists at the conventional location or the project config names one
    When "/aa-health" probes R-06
    Then R-06 is reported as met

  @R-06 @required
  Scenario: No documents folder exists
    Given no documents folder exists
    When "/aa-health" probes R-06
    Then R-06 is reported as unmet
    And the remedy is for "aa init" or "/aa-init" to create it

  @R-07 @required
  Scenario: A project config exists
    Given the config file exists at the project root and parses
    When "/aa-health" probes R-07
    Then R-07 is reported as met

  @R-07 @required
  Scenario: No project config exists
    Given no config file exists at the project root
    When "/aa-health" probes R-07
    Then R-07 is reported as unmet
    And the remedy is for "aa init" to create it from the merged scopes

  @R-08 @recommended
  Scenario: Ticket reference conventions are defined
    Given the project config or the ticket system defines a ticket reference pattern
    When "/aa-health" probes R-08
    Then R-08 is reported as met

  @R-08 @recommended
  Scenario: No ticket reference convention is defined
    Given neither the project config nor the ticket system defines a pattern
    When "/aa-health" probes R-08
    Then R-08 is reported as unmet
    And the remedy is for "aa init" to write a default pattern into the project config

  @R-16 @required @T-12
  Scenario: A features folder exists
    Given a features folder exists at the conventional location or the project config names one
    When "/aa-health" probes R-16
    Then R-16 is reported as met

  @R-16 @required @T-12
  Scenario: No features folder exists
    Given no features folder exists
    When "/aa-health" probes R-16
    Then R-16 is reported as unmet
    And the report says requirements cannot be captured as the source of truth until it exists
    And the remedy is for "aa init" or "/aa-init" to create it

  @R-18 @required @O-05
  Scenario: The repository follows the conventional structure
    Given the documents, features, scripts, source, and tests folders exist at the root
    And the source folder has one subfolder per project
    When "/aa-health" probes R-18
    Then R-18 is reported as met

  @R-18 @required @O-05
  Scenario: The repository maps an existing layout to the convention
    Given the repository predates the framework and uses different folder names
    And the project config maps each conventional folder to its equivalent
    When "/aa-health" probes R-18
    Then R-18 is reported as met
    And the report shows the mapping

  @R-18 @required @O-05
  Scenario: The repository does not follow the conventional structure
    Given a conventional folder is missing and the project config does not map it
    When "/aa-health" probes R-18
    Then R-18 is reported as unmet
    And the report names the missing folders
    And the remedy is for "aa init" to create them or "/aa-init" to propose a mapping

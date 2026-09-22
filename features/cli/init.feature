@cli @T-11 @R-05 @R-06 @R-07 @R-08 @R-16
Feature: aa init bootstraps a repository
  Lays down what a repository needs before an agent is involved: the project config, the
  documents folder, the features folder, and project-scope skills and commands. Then hands off
  to the agent for the checks and fixes that need judgement.

  Background:
    Given "aa setup" has been run on this machine

  Scenario: Initialise the current directory
    Given I am in a project directory
    When I run "aa init"
    Then a project config exists at the project root
    And a documents folder exists
    And a features folder exists
    And project-scope skills and commands are installed for each detected target

  Scenario: Initialise a directory by path
    When I run "aa init -path <dir>"
    Then <dir> is initialised exactly as the current directory would have been

  Scenario: Project not under source control
    Given the directory is not a repository
    When I run "aa init"
    Then it offers to initialise a repository
    And it proceeds only with consent

  Scenario: Layer the scopes into the project config
    Given user, team, and enterprise configs exist
    When I run "aa init"
    Then the project config is created from the merged scopes
    And project settings take precedence over team, team over enterprise

  Scenario: Set default conventions
    When I run "aa init"
    Then the project config records a default pattern for referencing the anchor ticket
    And the pattern can be changed in the project config

  @O-21 @R-35
  Scenario: Add a lint stub to the build script
    When I run "aa init"
    Then the "build" script stub accepts a lint switch
    And the stub names what it must do: run the formatter in check mode and each configured linter
    And it says which languages were detected with no known linter, if any

  @O-18 @R-32
  Scenario: Create the decision record sequence
    When I run "aa init"
    Then the decision record folder exists at the location the project config names
    And it holds a template with context, options, decision, and consequences
    And record 0001 records the adoption of the framework, dated today
    And the location can be changed in the project config to a knowledge base page

  @O-14 @R-28
  Scenario: Record the commit message format
    When I run "aa init"
    Then the project config records the Conventional Commits pattern
    And it records the default list of commit types
    And the types and scopes can be changed in the project config

  @O-09 @R-22
  Scenario: Record the one ticket project
    When I run "aa init"
    Then it asks which ticket system project or group this repository maps to
    And the project config records exactly one
    And a second repository may record the same project

  Scenario: Re-running is safe
    Given "aa init" has already been run here
    When I run "aa init" again
    Then existing config, folders, and feature files are left as they are
    And missing pieces are added

  Scenario: Hand off to the agent
    When "aa init" completes
    Then it tells the user to run "/aa-fw-health" and "/aa-fw-init" in their agent

  Scenario: Health is not a CLI verb
    When I run "aa health"
    Then the CLI explains that health is an agent command
    And it names "/aa-fw-health"

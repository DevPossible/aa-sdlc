@cli
Feature: aa update brings the install up to the package version
  Everything setup and init installed is updated together, so the CLI and the skills it
  installed never drift apart.

  Background:
    Given "aa setup" has been run on this machine

  Scenario: Update user scope
    Given a newer aa-sdlc package is installed globally
    When I run "aa update"
    Then the skills and commands at user scope match the package version
    And the user config records the new version

  Scenario: Update project scope from inside a repository
    Given I am in a repository initialised with "aa init"
    When I run "aa update"
    Then the project-scope skills and commands match the package version
    And project config, documents, and feature files are left as they are

  Scenario: Report what changed
    When "aa update" completes
    Then it lists the skills and commands that were added, changed, or removed

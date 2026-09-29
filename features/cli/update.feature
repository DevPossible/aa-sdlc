# Generated from the knowledge base page Requirements/cli/update. Do not edit: change the page, then pull it.
# Checksum: sha256:19f49ad038632a24bd6d08764868743095ac13bae6ffb4897e7dac18a3fdc085
@cli @F-009
Feature: aa update brings the install up to the package version
  Everything setup and init installed is updated together, so the CLI and the skills it
  installed never drift apart.

  Background:
    Given "aa setup" has been run on this machine

  @F-009-01
  Scenario: Update user scope
    Given a newer aa-sdlc package is installed globally
    When I run "aa update"
    Then the skills and commands at user scope match the package version
    And the user config records the new version

  @F-009-02
  Scenario: Update project scope from inside a repository
    Given I am in a repository initialised with "aa init"
    When I run "aa update"
    Then the project-scope skills and commands match the package version
    And project config, documents, and feature files are left as they are

  @F-009-03
  Scenario: Report what changed
    When "aa update" completes
    Then it names each root folder it installs into at each scope, such as USER .claude, with its number of files
    And it counts the files added, changed, and removed in each, without listing them one by one

  @F-009-04
  Scenario: Update the plugins installed at each scope
    Given a plugin is installed at a scope
    When I run "aa update"
    Then the plugin is reinstalled from the source the config records for it
    And the plugin's files are not reported as stale core files

  @F-009-05
  Scenario: A repository keeps its own harnesses
    Given the project config names no targets
    And "aa setup" installed into more harnesses on this machine than the repository has folders for
    When I run "aa update" inside the repository
    Then project scope is refreshed only for the harnesses the repository already has folders for

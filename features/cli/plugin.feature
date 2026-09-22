@cli @T-02
Feature: aa plugin manages plugins at a scope
  Plugins supply the specifics the core deliberately leaves out: tech-stack packs and process
  packs. They add skills, steps, guidance, and requirements without changing core.

  Background:
    Given "aa setup" has been run on this machine

  Scenario: Add a plugin at project scope
    Given I am in a repository initialised with "aa init"
    When I run "aa plugin add <plugin>"
    Then the plugin's skills and commands are installed at project scope
    And the project config records the plugin

  Scenario: Add a plugin at user scope
    When I run "aa plugin add <plugin> --scope user"
    Then the plugin's skills and commands are installed at user scope
    And the user config records the plugin

  Scenario: Remove a plugin
    Given a plugin is installed at a scope
    When I run "aa plugin remove <plugin>"
    Then its skills and commands are removed from that scope
    And core skills are untouched

  Scenario: List plugins
    When I run "aa plugin list"
    Then it lists installed plugins by scope
    And it lists the plugins available from the organisation config repository, if one is set

  Scenario: A plugin cannot change core
    Given a plugin that redefines a core skill
    When I run "aa plugin add <plugin>"
    Then the plugin is refused
    And the reason names the core skill it tried to change

@cli @T-11
Feature: aa setup bootstraps the machine
  The main CLI verb. Run once per machine after installing the package globally. It prepares
  every agent target on the machine so that any repository can then be initialised with aa init.

  Background:
    Given the aa-sdlc package is installed globally

  Scenario: Detect installed agent targets
    When I run "aa setup"
    Then it lists every supported agent target found on the machine
    And it installs the skills and commands for each at user scope

  Scenario: Write the user config
    When I run "aa setup"
    Then a user-scope config exists
    And it records the targets installed and the package version

  Scenario: Connect to an organisation config repository
    When I run "aa setup" with an organisation config repository
    Then the enterprise and team plugins and settings from that repository are layered over core
    And the user config records the repository

  Scenario: Re-running is safe
    Given "aa setup" has already been run
    When I run "aa setup" again
    Then nothing is duplicated
    And any newly installed agent targets are picked up

  Scenario: No supported target found
    Given no supported agent target is installed
    When I run "aa setup"
    Then it names the targets it supports
    And it still writes the user config

  Scenario: Tell the user what to do next
    When "aa setup" completes
    Then it tells the user to run "aa init" in a repository

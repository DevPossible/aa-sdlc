@agent @development @O-05 @O-06 @O-07 @O-11 @O-12 @O-16 @O-21 @O-25
Feature: /aa-dev-setup-environment makes a fresh clone buildable and testable
  Fill in the root scripts, configure the tools the stack needs, split the configuration, define
  the end-to-end environment, and record anything a new developer must do by hand. Proven on a
  clean clone.

  Background:
    Given a project bootstrapped with "aa init"
    And a technology stack document and the stub root scripts

  Scenario: The root scripts are filled in and proven on a clean clone
    When "/aa-dev-setup-environment" runs
    Then initialize, build, test, and pack each run to completion on a fresh clone
    And build accepts a lint switch and test accepts a tier
    And the output of the clean-clone run is quoted

  Scenario: Existing equivalents are mapped, not duplicated
    Given the repository already keeps its documents in a folder with another name
    When "/aa-dev-setup-environment" runs
    Then the project config maps that folder as the documents folder
    And no second documents folder is created

  Scenario: Tools are configured, never chosen for the project
    Given a language in the stack has no formatter configured
    When "/aa-dev-setup-environment" reaches it
    Then it lists what is available in the project's scope or as a plugin
    And the user chooses
    And a language with no known linter is recorded in the development environment configuration

  Scenario: Configuration is split by what varies
    When "/aa-dev-setup-environment" writes the configuration
    Then one environment template per environment holds the settings that differ, with placeholders for secrets
    And the application configuration holds the functional settings once
    And the development environment configuration says where each secret comes from

  Scenario: The end-to-end environment is code
    Given the stack can run in containers
    When "/aa-dev-setup-environment" runs
    Then container definitions for the system and its dependencies are committed
    And test with the e2e tier starts them

  Scenario: A manual step is a bug until proven otherwise
    Given a setup step could not be automated
    When "/aa-dev-setup-environment" documents it
    Then the development environment configuration records the step and the reason it is manual

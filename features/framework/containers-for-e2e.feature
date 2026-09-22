@framework @O-12 @O-07 @O-11 @T-07
Feature: End-to-end tests run against containers
  The end-to-end tier starts the system and its dependencies in containers, from definitions
  committed to the repository, wherever the stack allows. The same definitions serve any
  machine and the pipeline, so the e2e tier is one command everywhere and its environment is
  part of the repository.

  Background:
    Given a project bootstrapped with "aa init"
    And a container runtime is available

  @G-30
  Scenario: The e2e tier starts its own environment
    Given container definitions for the system and its dependencies exist in the repository
    When "test" is run with the e2e tier
    Then the containers are started from those definitions
    And the end-to-end tests run against them
    And the containers are stopped and removed when the run ends

  @G-30
  Scenario: Setting up the environment writes the container definitions
    Given the stack can run in containers
    When "/aa-dev-setup-environment" fills in the root scripts
    Then container definitions for the system and its dependencies are committed to the repository
    And "test" with the e2e tier uses them
    And the same definitions are what the pipeline uses

  @G-30
  Scenario: The same command runs the same way in the pipeline
    Given the pipeline's e2e stage calls "test" with the e2e tier
    When the stage runs
    Then it starts the same containers from the same definitions as a local run
    And a failure in the stage can be reproduced locally with the same command

  @G-30
  Scenario: A dependency that cannot be containerised is recorded
    Given a dependency has no container image and no faithful stand-in
    When "/aa-dev-setup-environment" or "/aa-qa-e2e-tests" reaches it in a shared environment
    Then the development environment configuration names the dependency and why
    And the tests that depend on it are marked
    And every other dependency still runs in containers

  Scenario: No container runtime degrades, never blocks
    Given no container runtime is available
    When "test" is run with the e2e tier
    Then it runs against whatever it can reach
    And it says that R-25 is unmet and what that means for the results

  @R-26
  Scenario: Health reports a repository whose e2e environment is undefined
    Given no container definitions for the system exist in the repository
    When "/aa-fw-health" runs
    Then R-26 is reported as unmet
    And the remedy names "/aa-dev-setup-environment"

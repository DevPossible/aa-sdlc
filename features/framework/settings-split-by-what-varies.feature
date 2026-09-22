@framework @O-25 @O-16 @O-24 @T-01
Feature: Environment settings and functional settings live apart
  Configuration is split by what varies. Settings that differ between deployed environments,
  such as connection strings, endpoints, resource names, and credentials, live in an
  environment file or the platform's equivalent, one per environment, supplied at deploy time.
  Settings that are the same everywhere, such as timeouts, limits, and behaviour, live in the
  application configuration committed once. No key appears in both.

  Background:
    Given a project bootstrapped with "aa init"
    And environments named by the infrastructure code

  @G-48
  Scenario: Setting up the environment splits the two kinds
    When "/aa-dev-setup-environment" writes the configuration
    Then an environment template exists per environment with endpoints, connection strings, resource names, and credential placeholders
    And the application configuration holds the timeouts, limits, and behaviour settings once
    And no key appears in both

  @G-48
  Scenario: A new endpoint goes in the environment file
    Given a ticket that adds a call to a new external service
    When "/aa-dev-implement" adds the service URL
    Then the key is added to every environment template with that environment's value or a placeholder
    And it is not added to the application configuration

  @G-48
  Scenario: A new timeout goes in the application configuration
    Given a ticket that adds a request timeout
    When "/aa-dev-implement" adds the setting
    Then the key is added to the application configuration once
    And it is not added to any environment template

  @G-48
  Scenario: An agent asked where a setting goes asks which kind it is
    Given a setting whose kind is not obvious from its name
    When "/aa-dev-implement" decides where to put it
    Then it asks whether the value differs between environments
    And it puts the key in exactly one of the two places accordingly

  @G-48
  Scenario: A functional override for one environment is a recorded decision
    Given a performance environment that needs a longer timeout than every other environment
    When the override is made
    Then a decision record explains why that environment differs
    And the override is a single key in that environment's file citing the record
    And the application configuration still holds the default

  @G-48
  Scenario: The diff between environments is short
    Given the environment templates for two environments
    When they are compared
    Then the differences are endpoints, connection strings, resource names, and credentials only
    And no functional setting appears in the diff

  @G-48
  Scenario: Review catches a setting in the wrong place
    Given a merge request that adds a connection string to the application configuration
    When "/aa-dev-review" reviews it
    Then a finding says the key varies by environment and belongs in the environment templates
    And the finding cites O-25

  Scenario: Environment files are templated, never secret-bearing
    Given an environment file holds a credential
    When it is committed
    Then only the template with a placeholder is committed
    And the development environment configuration says where the value comes from

  @R-39
  Scenario: Health reports a timeout in every environment file
    Given a timeout appears in every environment template with the same value and no decision record
    When "/aa-fw-health" runs
    Then R-39 is reported as unmet with the key named

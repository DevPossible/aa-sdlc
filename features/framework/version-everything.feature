# Generated from the knowledge base page Requirements/framework/version-everything. Do not edit: change the page, then pull it.
# Checksum: sha256:21621933f0d2b722e8434c7df5612380a6c64f8ffe55cbc30ed1efae6bb35820
@framework @agent @O-16 @O-02 @T-07 @F-044
Feature: Version everything needed to build and operate the software
  The repository holds everything required to build, deploy, and run the system: the code,
  configuration templates with no secret values, migrations, automation, and the documentation
  that operates it. The test is a fresh clone plus the documented secrets. Secrets are never
  committed; their templates always are.

  Background:
    Given a project bootstrapped with "aa init"
    And the project is under source control with a remote

  @G-37 @F-044-01
  Scenario: A fresh clone can build, deploy, and run the system
    Given a fresh clone of the repository
    And the secrets the development environment configuration names
    When initialize, build, test, and pack are run
    And the deployment is run from the repository's pipeline and infrastructure definitions
    Then the system builds, deploys, and runs
    And nothing was fetched from a machine, a wiki page, or a person outside the repository

  @G-37 @F-044-02
  Scenario: A change ships with the migration and the config it needs
    Given a ticket that adds a database column and a new configuration key
    When "/aa-dev-implement" commits the change
    Then the migration is committed with the code that needs it
    And every environment's configuration template gains the new key
    And the development environment configuration says where the key's value comes from

  @G-37 @F-044-03
  Scenario: Infrastructure and alerts are committed as code
    When "/aa-ops-setup-infrastructure" and "/aa-ops-observability" run
    Then the infrastructure definitions and alert configuration are in the repository
    And every manual operation has a runbook in the documents folder
    And each runbook is versioned with the scripts it describes

  @G-38 @F-044-04
  Scenario: A secret is templated, never committed
    Given the system needs a database password
    When "/aa-dev-setup-environment" writes the configuration templates
    Then each template names the password key with a placeholder
    And the development environment configuration says how a fresh clone obtains the value
    And no committed file contains the value

  @G-38 @F-044-05
  Scenario: A committed secret is rotated and replaced
    Given a secret value is found in a committed file
    When "/aa-sec-maintain-security" handles it
    Then the secret is rotated
    And the value is replaced with a placeholder
    And the report names the file and never the value

  @F-044-06
  Scenario: The knowledge base still holds why
    Given a decision about how the system is deployed
    When it is recorded
    Then the decision and its rationale go to the knowledge base
    And the runbook and the automation that carry it out go to the repository
    And each links to the other

  @R-30 @F-044-07
  Scenario: Health reports what a fresh clone could not do
    Given an environment has no configuration template in the repository
    And a manual operation has no runbook in the documents folder
    When "/aa-fw-health" runs
    Then R-30 is reported as unmet
    And the report names the missing template and the missing runbook

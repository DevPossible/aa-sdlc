@agent @operations @O-16 @O-17 @O-18 @O-25
Feature: /aa-ops-setup-infrastructure defines the environments as code
  Every environment the system runs in is reproducible from code in the repository, with one
  configuration template per environment and no secret values, the security controls from the
  threat model implemented or ticketed, and a runbook for every operation that stays manual.

  Background:
    Given a project bootstrapped with "aa init"
    And an architecture with technical constraints and a threat model

  Scenario: Every environment is reproducible from the code
    When "/aa-ops-setup-infrastructure" runs
    Then infrastructure code exists in the source folder as its own project on a branch that references the ticket
    And each environment can be created from that code with no manual step beyond the runbook
    And the output of applying it is quoted

  Scenario: One template per environment, no secret values
    When "/aa-ops-setup-infrastructure" writes the configuration
    Then one template per environment names every key with a placeholder for each secret
    And the templates hold only the settings that differ between environments
    And no key appears in both a template and the application configuration

  Scenario: Nothing that costs money is created without asking
    Given applying the code would create a resource that costs money or is hard to delete
    When "/aa-ops-setup-infrastructure" reaches it
    Then it presents what would be created, where, and what it costs
    And it applies the code only after the user consents

  Scenario: Widening a privilege is a decision record
    Given a role or network path must be wider than the narrowest that works
    When "/aa-ops-setup-infrastructure" defines it
    Then a decision record states why, numbered next in the repository's sequence
    And the record is linked from the ticket

  Scenario: Security controls are implemented or ticketed
    Given the threat model names a control the infrastructure must provide
    When "/aa-ops-setup-infrastructure" runs
    Then the control is implemented in the code or has a linked ticket with the reason it is not yet done
    And no control is dropped silently

  Scenario: Every manual operation has a runbook
    Given an operation could not be automated
    When "/aa-ops-setup-infrastructure" documents it
    Then a runbook in the documents folder gives its preconditions, steps, verification, and rollback
    And the runbook says why the operation is manual

  Scenario: The change is staged, not committed
    When "/aa-ops-setup-infrastructure" finishes
    Then the infrastructure code, templates, runbooks, and decision records are staged as one change set with a Conventional Commit message
    And no commit is made unless the user asked for it
    And the ticket records what was produced, what was applied, and what remains

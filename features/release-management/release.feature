@agent @release-management @O-24
Feature: /aa-rel-release deploys a prepared release to production and proves it
  The deployment goes through the pipeline with the artifact identity the release names, never
  rebuilt and never by hand; the user is asked before the irreversible step every time; the
  release is done when the checks pass in production, and a failure rolls back by default.

  Background:
    Given a project bootstrapped with "aa init"
    And a prepared release with a go decision, an artifact identity, verification checks, and a deployment runbook

  Scenario: No go decision, no deployment
    Given the release ticket records no go decision
    When "/aa-rel-release" runs
    Then it stops before any deployment
    And it says on the release ticket what is missing

  Scenario: The user is asked before every production deployment
    When "/aa-rel-release" is ready to deploy
    Then it presents the identity, the target, the pipeline run, the strategy, and what rollback would return to
    And it deploys only when the user grants this deployment
    And a permission granted for an earlier release does not carry over

  Scenario: The same identity is deployed, through the pipeline
    Given the user grants the deployment
    When "/aa-rel-release" deploys
    Then the pipeline deploys the identity the release names
    And nothing is rebuilt for production
    And no deployment step is performed by hand

  Scenario: A blocking gate is never bypassed
    Given a pipeline gate or check blocks the run
    When "/aa-rel-release" reaches it
    Then no bypass flag is used
    And it fixes the cause or tells the user

  Scenario: Verification happens before anything is announced
    Given the pipeline run is green
    When "/aa-rel-release" verifies
    Then every verification check on the release has a result with evidence
    And the identity running in production is confirmed to be the one deployed
    And the release is reported done only when the checks pass

  Scenario: A failed check rolls back by default
    Given a verification check fails in production
    When "/aa-rel-release" handles it
    Then it returns to the previous known-good identity through the pipeline, or raises an incident where the runbook says rollback is unsafe
    And which was done and why is recorded on the release ticket

  Scenario: The deployment is recorded
    When "/aa-rel-release" finishes
    Then the release ticket and the knowledge base record what was deployed by identity, when, by whom, and with which pipeline run
    And the verification report on the release ticket has every check's result

@agent @operations @O-06 @O-11 @O-16 @O-17 @O-21 @O-24 @O-25
Feature: /aa-ops-setup-pipeline builds the path from a merged change to production
  The pipeline calls the root scripts and holds no logic of its own, runs every test tier and the
  lint stage, builds one artifact with an immutable identity and deploys that identity to every
  environment with the environment's settings supplied at deploy time, and documents the
  deployment strategy and how rollback works for it.

  Background:
    Given a project bootstrapped with "aa init"
    And working root scripts and infrastructure code with one configuration template per environment

  Scenario: Every stage is a root script call that ran locally first
    When "/aa-ops-setup-pipeline" runs
    Then each stage calls a script or command in the repository with the same arguments it takes locally
    And each of those calls was run locally and its output quoted before the configuration was written
    And no logic lives in the pipeline configuration

  Scenario: Every test tier runs and any failure fails the run
    When "/aa-ops-setup-pipeline" writes the test stages
    Then there is a stage for the unit, integration, and end-to-end tiers
    And a failure in any tier fails the run
    And a stage that is skipped carries a recorded reason

  Scenario: The lint stage is the root build with the lint switch
    When "/aa-ops-setup-pipeline" writes the lint stage
    Then the stage runs the root build with the lint switch
    And a finding fails the run rather than being suppressed

  Scenario: One artifact is built once and promoted
    When "/aa-ops-setup-pipeline" writes the deploy stages
    Then the pack stage runs once per commit and gives the artifact an immutable identity
    And every deploy stage deploys that identity
    And no deploy stage builds

  Scenario: Environment settings are supplied at deploy time
    When "/aa-ops-setup-pipeline" writes the deploy stages
    Then each deploy stage supplies the environment's settings from its committed template
    And secrets come from the pipeline's secret store and none is committed

  Scenario: The branches the pipeline deploys from are protected
    When "/aa-ops-setup-pipeline" configures branch protection
    Then a deploy cannot start from an unreviewed change
    And no bypass flag is used on the protection
    And any protection the source control tool cannot express is recorded in the strategy document

  Scenario: The deployment strategy is documented with its rollback
    When "/aa-ops-setup-pipeline" finishes
    Then a document in the documents folder states the deployment strategy
    And it says how rollback returns to a previous artifact identity rather than a rebuilt tag

  Scenario: A failing stage is reproduced locally before anything changes
    Given a stage fails on the first pipeline run
    When "/aa-ops-setup-pipeline" handles it
    Then the same script is run locally with the same arguments before anything is changed
    And nothing is suppressed to reach green

  Scenario: The change is staged, not committed
    When "/aa-ops-setup-pipeline" finishes
    Then the pipeline configuration, the strategy document, and any script changes are staged as one change set with a Conventional Commit message
    And no commit is made unless the user asked for it
    And the ticket records what was produced, the run that proved it, and what remains

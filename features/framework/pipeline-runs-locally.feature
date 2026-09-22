@framework @agent @O-11 @O-06 @T-07 @T-13
Feature: Every pipeline step runs locally, exactly
  Every step the delivery pipeline performs can be reproduced exactly on any machine, from the
  command line or a local tool, with the same script, the same arguments, and the same inputs.
  The pipeline calls scripts that live in the repository and holds no logic of its own. A step
  that exists only in the pipeline is a defect.

  Background:
    Given a project bootstrapped with "aa init"
    And root scripts for initialize, build, test, and pack

  @G-29
  Scenario: The pipeline calls the root scripts
    When "/aa-ops-setup-pipeline" writes the pipeline configuration
    Then every stage calls a root script or a command committed to the repository
    And each call uses the same arguments a person would use locally
    And no stage contains logic beyond the call

  @G-29
  Scenario: A pipeline failure is reproduced locally before it is fixed
    Given a pipeline stage has failed
    When "/aa-dev-fix-bug" or "/aa-dev-finish-branch" addresses the failure
    Then the same script is run locally with the same arguments
    And the local run shows the same failure
    And the fix is proven by the local run before anything is pushed

  @G-29
  Scenario: Logic found only in the pipeline is moved out
    Given a stage in the pipeline configuration contains logic that exists nowhere else
    When "/aa-ops-setup-pipeline" or "/aa-dev-setup-environment" reviews the pipeline
    Then the logic is moved into a script in the repository
    And the stage is changed to call that script
    And the script is run locally and its output quoted

  Scenario: A step that truly cannot run locally is recorded, with a stand-in
    Given a stage depends on a signing key held only by the pipeline
    When "/aa-ops-setup-pipeline" writes the configuration
    Then the stage is recorded as pipeline-only with the reason
    And a local stand-in exercises everything up to the point of difference
    And the deployment strategy documentation names the stand-in

  @R-24
  Scenario: Health reports steps that exist only in the pipeline
    Given a stage in the pipeline configuration holds logic of its own
    When "/aa-fw-health" runs
    Then R-24 is reported as unmet with the stage named

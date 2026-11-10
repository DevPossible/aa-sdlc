# Generated from the knowledge base page Requirements/framework/checkpoint-full-suite. Do not edit: change the page, then pull it.
# Checksum: sha256:2f913ad9179d8a24ed1305d1878fad9d0eb388f8055f4d72940d1f7d59d670c4
@framework @agent @O-29 @G-04 @G-59 @AP-413 @F-094
Feature: Checkpoint full-suite policy
  The default is a full suite at every branch finish. A project may explicitly choose scoped
  merge gates with full-suite checkpoints on its integration branch. A checkpoint changes when
  the full run is owed; it does not change what full means or replace release and exposure gates.

  @F-094-01
  Scenario: Default branch finish keeps the full suite
    Given testing.fullSuite is absent, its mode is absent, or its mode is per-branch
    When "/aa-dev-finish-branch" verifies the branch as it will be merged
    Then full build, lint, provenance and every test tier are required

  @F-094-02
  Scenario: Checkpoint branch finish proves the scoped merge gate
    Given testing.fullSuite selects checkpoint with an integration branch, perMerge gates and checkpointBefore events
    When "/aa-dev-finish-branch" verifies a merge into that integration branch
    Then it runs build, lint, smoke and the changed components' suites on the candidate as it will be merged
    And it also runs the suites pinning every changed public API, schema or shared kernel
    And the feature-file provenance check still passes before the merge
    And the ticket or linked durable record names the scoped results, integration branch and full run owed at the next checkpoint

  @F-094-03
  Scenario: Each configured event requires a full integration-branch checkpoint
    Given checkpointBefore lists release, exposure and demonstration
    When any listed event is about to occur
    Then full build, lint, provenance and every test tier must pass on the integration-branch candidate for that event
    And changed relevant inputs invalidate earlier proof under G-59
    And the event waits for the full checkpoint and its evidence

  @F-094-04
  Scenario: A backstop bounds the time and merges between full runs
    Given checkpoint mode has a backstop with merges 10 and days 3
    When either bound since the last successful full checkpoint is reached
    Then a full integration-branch checkpoint is due before another merge
    And if no successful full checkpoint is recorded, one is due before the next merge
    And a failed or partial run does not reset either bound

  @O-23 @F-094-05
  Scenario: A failed checkpoint is fixed forward
    Given a full integration-branch checkpoint fails
    When work continues
    Then the failure and affected claims remain recorded and the event remains unproven
    And the cause is fixed forward on the integration branch and the affected proof is rerun
    And a flaky test gets a defect ticket and distinguishing experiment, never retry-to-green

  @F-094-06
  Scenario: Scoped success is never called a full run
    Given only the scoped merge gate passed under checkpoint mode
    When the evidence is reported
    Then it names the candidate, what actually ran, actual results and the outstanding full checkpoint
    And it never labels the partial run full or claims release or installed exposure acceptance

  @F-094-07
  Scenario: Configuration cannot weaken the mandatory merge gate
    Given a checkpoint config omits build, lint, smoke or changed-components from perMerge
    When it is validated against the config schema
    Then validation fails and names the invalid configuration
    And unknown modes, empty event lists and nonpositive backstop bounds also fail

  @F-094-08
  Scenario: Policy survives config loading writing and scope merging
    Given an enterprise config selects checkpoint and a project config selects per-branch
    When the CLI loads, merges and writes the config
    Then the later scope replaces the entire testing.fullSuite policy
    And unrelated config writes preserve every configured policy field
    And an absent policy leaves the per-branch default in force

  @F-094-09
  Scenario: Release and exposure retain their existing gates
    Given a project opts into checkpoint mode
    When it prepares a release or exposes an installed artifact
    Then existing full-suite, artifact identity, independent acceptance and authorization gates still apply
    And omitting release or exposure from checkpointBefore does not waive those gates

  @F-094-10
  Scenario: A merge outside the integration branch retains the default gate
    Given checkpoint mode names develop as the integration branch
    When "/aa-dev-finish-branch" verifies a merge targeting a different branch
    Then full build, lint, provenance and every test tier remain required
    And a missing or malformed checkpoint policy cannot justify deferred proof

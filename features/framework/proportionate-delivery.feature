# Generated from the knowledge base page Requirements/framework/proportionate-delivery. Do not edit: change the page, then pull it.
# Checksum: sha256:c45d09d3bb6c8e1b422f803384b9baff3cbf9b01a4c7bf210ce7d1bb4d669a8e
@framework @agent @O-08 @O-13 @O-17 @O-23 @O-26 @T-07 @F-092
Feature: Proportionate delivery and early integration
  One approved boundary supports autonomous implementation, early real integration and
  reviewable evidence. These practices shorten handoffs while retaining promised
  acceptance, independent review where required and full branch-finish/release gates.

  @F-092-01
  Scenario: One approval covers routine implementation
    Given a confirmed brief names the scenarios, boundaries, invariants, owned paths and proof
    When the worker repairs a fixture or changes a private helper within that brief
    Then it records the adjustment and continues without another implementation approval
    And requirements, public contracts, schema, dependencies and authority changes require renewed approval before dependent work

  @F-092-02
  Scenario: Task-scoped commit authorization persists
    Given explicit local commit permission for the active task
    When a coherent task-owned checkpoint passes its required checks
    Then the worker may commit it without another permission round
    And a request to implement alone grants no commit permission
    And a revoked or expired permission no longer authorizes commits

  @F-092-03
  Scenario: Local commit permission grants no external authority
    Given permission for local task commits only
    When a remote write, protected merge, delegation or release is needed
    Then the worker checks separate explicit authorization for that action
    And a local checkpoint is not stakeholder acceptance

  @F-092-04
  Scenario: Real integration precedes broad private matrices
    Given the first focused behavior works and the brief names its real collaborator
    When implementation continues
    Then the real collaborator is exercised before broad private or unit matrix expansion
    And remaining negative, security, coverage and independent acceptance checks stay required
    And an unavailable collaborator is recorded as a missing join rather than claimed as tested

  @F-092-05
  Scenario: Public compatibility retains independent proof
    Given a change affects a persisted or public wire contract
    When the tests are planned
    Then independent literals or goldens and applicable malformed-data, clock, race and cleanup cases prove compatibility
    And private implementation shape is not universally frozen before coding

  @F-092-06
  Scenario: One independent gate may serve reviewer and integrator
    Given an independent run identifies the combined candidate, dependencies, requirements, environment, commands, results, coverage and cleanup
    When reviewer and integrator accept the same scope
    Then they reference that run without repeating it merely to change the operator
    And they still perform the review and record their acceptance decision

  @F-092-07
  Scenario: Changed relevant inputs invalidate predecessor proof
    Given an earlier independent gate passed
    When relevant source, dependencies, requirements, environment or evidence validity changes
    Then the affected proof is rerun for the changed candidate
    And unchanged predecessor proof may be referenced only for its still-valid scope

  @F-092-08
  Scenario: Scoped integration is distinct from branch finish
    Given affected component and real-collaborator checks pass on a work-in-progress candidate
    When the candidate is locally integrated
    Then the record states the limited integrated scope
    And full build, lint, provenance and every tier remain required at actual branch finish
    And release and activation retain their own artifact and authorization checks

  @F-092-09
  Scenario: Failures do not disappear behind narrower green runs
    Given a run has an unresolved failure
    When a narrower run passes or unrelated development continues
    Then the original failure, affected claim and distinguishing next experiment remain recorded
    And the affected acceptance is not made green by retry, quarantine or omission

  @F-092-10
  Scenario: Resource waits follow actual constraints
    Given one worker owns a named shared resource with a release condition
    When another bounded workload requests capacity
    Then actual resource and relevant service capacity are checked before extending the wait
    And independent work may proceed when isolation and capacity permit

  @F-092-11
  Scenario: Existing resource ownership covers routine setup repairs
    Given an exclusive scoped resource grant and a setup failure
    When its owner repairs the changed cause within the same boundary
    Then it proceeds without another start permission and reports actual handles, terminal results and cleanup
    And a new owner or material boundary change requires coordination

  @F-092-12
  Scenario: Expensive cohorts use actual fixture and artifact inputs
    Given a final run requires state transitions, accounting or built dependencies
    When the owner prepares the run
    Then it checks actual versions and accounting semantics, tested dependency identity and usable artifact paths
    And recurring setup mistakes are fixed in maintained invocation tooling

  @F-092-13
  Scenario: Authorized review follow-ups activate their owner
    Given delegation and the bounded fix are already authorized
    When a review finding is routed to an idle worker
    Then the coordinator makes the finding actionable and verifies the worker starts
    And a queued notification alone is not treated as running work

  @F-092-14
  Scenario: A local candidate can be ready for review
    Given development verification passes and remote review is outside the authorized scope
    When implementation produces a linked local candidate and review evidence
    Then the ticket moves to the configured In Review state
    And author verification, independent review, integration, stakeholder acceptance and release are distinguished

  @F-092-15
  Scenario: Unchanged requirements are not repeatedly repulled
    Given approved feature files have valid provenance and their recorded page versions are checked current
    When another step continues the same bounded work
    Then it reuses that requirement snapshot without another unchanged pull
    And changed or unknown requirement currency requires refreshing before dependent work

  @F-092-16
  Scenario: Coordination protects the next runnable outcome
    Given the current outcome has a named missing user operation
    When work is coordinated
    Then a continuous integration lane owns that operation and supporting work names its current blocker
    And an active bounded checkpoint is completed before redirecting noncritical work
    And progress reports name first behavior, first real join, setup-invalidated runs and the age of the integration failure rather than using ticket or test counts as delivery

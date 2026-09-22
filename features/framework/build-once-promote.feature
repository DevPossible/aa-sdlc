@framework @agent @O-24 @O-06 @O-11 @T-07
Feature: Build once; promote the same artifact
  A release artifact is built once, from one commit, and given an immutable identity. That
  same identity is what every successive environment deploys. Nothing is rebuilt for a later
  environment; environment configuration is supplied at deploy time from committed templates.
  The release records the identity and validation confirms it is what is running.

  Background:
    Given a project bootstrapped with "aa init"
    And a pipeline written by "/aa-ops-setup-pipeline"

  @G-47
  Scenario: The pipeline builds once and promotes
    When a commit is merged to the default branch
    Then the pipeline runs the root pack script once
    And the artifact is given an immutable identity tied to the commit
    And each deploy stage deploys that identity
    And no deploy stage runs a build

  @G-47
  Scenario: Configuration is supplied at deploy time
    Given the artifact has been deployed to a test environment
    When the same artifact is deployed to production
    Then the production configuration comes from the committed template for that environment
    And the artifact's identity is unchanged
    And no environment value is baked into the artifact

  @G-47
  Scenario: The release records the identity
    When "/aa-rel-prepare-release" assembles the release
    Then the release names the artifact identity that was tested
    And "/aa-rel-release" deploys that identity and records it
    And the deployment record names the identity, not a tag that could be rebuilt

  @G-47
  Scenario: Validation confirms what is running
    When "/aa-ops-validate-production" runs after a release
    Then it reads the identity of the running artifact
    And it confirms the identity matches the one the release named
    And a mismatch is an incident, not a note

  @G-47
  Scenario: Rollback returns to a previous identity
    Given a release that failed verification in production
    When "/aa-rel-rollback" runs
    Then it deploys the previous known-good identity
    And it does not rebuild the previous tag
    And the rollback record names the identity restored

  Scenario: A pipeline that rebuilds per environment is corrected
    Given a pipeline with a build stage for each environment
    When "/aa-ops-setup-pipeline" reviews it
    Then it restructures the pipeline to one build stage and promoting deploy stages
    And the deployment strategy documentation explains the change

  Scenario: A platform that forces a rebuild is a recorded exception
    Given a deployment platform that can only deploy from a build it performs
    When "/aa-ops-setup-pipeline" configures it
    Then a decision record explains the constraint and how the built output is verified to match
    And the exception is limited to that platform

  @R-38
  Scenario: Health reports a rebuild in the promotion path
    Given a deploy stage for a later environment runs a build
    When "/aa-fw-health" runs
    Then R-38 is reported as unmet with the stage named

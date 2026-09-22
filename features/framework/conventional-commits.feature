@framework @O-14 @O-02 @T-07
Feature: Commit messages are Conventional Commits
  Every commit in a source code repository has a type from the project's list, an optional
  scope, an imperative subject, a body that says why, and a footer with the ticket reference
  and any breaking change. The history becomes data: release notes and the version bump are
  derived from it.

  Background:
    Given a project bootstrapped with "aa init"
    And the project config names the commit pattern and the allowed types

  @G-33
  Scenario: A commit made by a step conforms
    Given a ticket being implemented on a branch
    When "/aa-dev-implement" commits a change
    Then the subject starts with a type from the configured list
    And the subject is imperative and has no trailing period
    And the footer references the anchor ticket
    And the body says why the change was made

  @G-33 @G-08
  Scenario: A change that cannot name one type is split
    Given a working tree that contains a fix and an unrelated refactor
    When "/aa-dev-implement" commits
    Then two commits are made, one typed fix and one typed refactor
    And neither message describes the other's change

  @G-33
  Scenario: A breaking change is declared where it happens
    Given a change that removes a public behaviour a consumer relies on
    When "/aa-dev-implement" commits it
    Then the subject carries the breaking marker
    And the footer has a breaking-change entry that says what breaks and what to do

  @G-33
  Scenario: Review flags a message that does not conform
    Given a merge request with a commit whose message has no type
    When "/aa-dev-review" reviews it
    Then a non-blocking finding names the commit and the configured pattern
    And the review says the release notes will not pick the change up as written

  @G-34
  Scenario: The release is derived from the history
    Given commits since the last release tag typed feat, fix, and one with a breaking marker
    When "/aa-rel-prepare-release" runs
    Then the proposed version bump is major because of the breaking change
    And the release notes group the commits by type and ticket
    And the notes are then edited for the reader, not left as raw subjects

  @G-34
  Scenario: A commit that does not parse is a finding, not a workaround
    Given a commit since the last release tag that does not match the configured pattern
    When "/aa-rel-prepare-release" runs
    Then the commit is listed as a finding on the release ticket
    And the release is not marked ready until the finding is resolved or accepted with a reason

  Scenario: Enforced locally where the target allows
    Given the target supports hooks
    When "aa setup" installs the framework
    Then a commit-message hook checks each message against the configured pattern before the commit is made
    And a failure is reported to the user with the pattern, never bypassed

  @R-28
  Scenario: Health reports a history the tooling cannot read
    Given recent commits on the default branch do not match the configured pattern
    When "/aa-fw-health" runs
    Then R-28 is reported as unmet with the commits listed

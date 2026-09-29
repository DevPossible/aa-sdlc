# Generated from the knowledge base page Requirements/development/finish-branch. Do not edit: change the page, then pull it.
# Checksum: sha256:3688e5bb121efc9a61bcaf31110a97b6eafec700a1123a1b6ae6ef2e1b22c1d1
@agent @development @O-14 @O-17 @O-21 @F-010
Feature: /aa-dev-finish-branch takes a branch from green to merged
  Format changed files, bring the branch up to date, run the full suite, open or update the
  merge request linked to the ticket, and transition the ticket. The user's commits stay the
  user's; gates are never bypassed.

  Background:
    Given a project bootstrapped with "aa init"
    And a branch for a ticket whose tests pass

  @F-010-01
  Scenario: The whole suite runs, not just the tier worked in
    When "/aa-dev-finish-branch" runs
    Then the branch is brought up to date with the target branch
    And the root build with the lint switch and every test tier are run
    And their output is quoted in the report

  @F-010-02
  Scenario: Only changed files are formatted
    When "/aa-dev-finish-branch" formats
    Then the files the branch changed are formatted
    And no other file is touched

  @F-010-03
  Scenario: Uncommitted changes wait for the user
    Given the working tree has uncommitted changes
    When "/aa-dev-finish-branch" runs
    Then the changes are staged and presented with a message
    And the report says the branch waits on the user's commit
    And no commit is made

  @F-010-04
  Scenario: A non-conforming commit is named, not rewritten
    Given a commit on the branch has no type or no ticket footer
    When "/aa-dev-finish-branch" checks the history
    Then it names the commit and says how to reword or split it
    And it does not rewrite history unasked

  @F-010-05
  Scenario: The merge request links both ways
    When "/aa-dev-finish-branch" opens the merge request
    Then its title and description reference the ticket and summarise the change and its tests
    And the ticket links to the request and the request to the ticket

  @F-010-06
  Scenario: Gates are respected
    Given a hook or protected-branch rule blocks the merge
    When "/aa-dev-finish-branch" reaches it
    Then it does not use a bypass flag
    And it fixes the cause or tells the user, and stops at the open request

  @G-56 @R-46 @F-010-07
  Scenario: A feature file not pulled from its page blocks the merge
    Given the branch has a feature file with no provenance header, a checksum that does not match, or no page that generates it
    When "/aa-dev-finish-branch" runs the feature-file check
    Then it quotes the check's output and reports the feature file as blocking the merge
    And it says to change the page and pull it, never to edit the file

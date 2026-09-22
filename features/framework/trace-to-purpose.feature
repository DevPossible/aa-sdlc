@framework @O-19 @O-03 @T-12
Feature: Every change traces back to its purpose
  Every change to the repository can be followed back to why it was made. The commit names a
  ticket, the ticket links to the scenarios it satisfies or to the decision record or page that
  explains it, and the scenario is tagged with the ticket. The chain runs in both directions.
  A change that cannot name its purpose is a ticket to create first or work not to do.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket linked to scenarios in a feature file

  @G-42
  Scenario: A change carries its purpose with it
    When "/aa-dev-implement" makes a change for the ticket
    Then the branch name references the ticket
    And every commit message footer references the ticket
    And the merge request references the ticket
    And the ticket links back to the merge request

  @G-42
  Scenario: From a line of code to the requirement and back
    Given a merged change for the ticket
    When someone follows the chain from a changed line
    Then the commit names the ticket
    And the ticket names the scenario the change satisfies
    And the scenario carries the ticket tag
    And from the scenario the same commit can be reached

  @G-42
  Scenario: A change with no purpose is stopped before it is made
    Given the agent notices unrelated code it would like to tidy while implementing the ticket
    When it considers making the change
    Then it does not make it on this branch
    And it raises a ticket for the tidy-up, or leaves it
    And the ticket's change stays within its own purpose

  @G-42
  Scenario: Work with no scenario names a documented explanation
    Given a change that no scenario states, such as a dependency upgrade
    When "/aa-dev-implement" makes it
    Then the ticket links to the decision record or page that explains why
    And the commit references the ticket

  @G-42
  Scenario: Review finds a hunk that traces to nothing
    Given a merge request whose diff includes a change unrelated to the ticket's scenarios or stated reason
    When "/aa-dev-review" reviews it
    Then a finding names the hunk and says what purpose it lacks
    And the finding asks for a ticket or for the hunk to be removed

  @G-42
  Scenario: An incident fix is traced like any other change
    Given a change made during an incident to restore service
    When "/aa-sup-respond-incident" records the mitigation
    Then the change references the incident ticket
    And the incident ticket links to the change
    And the post-incident review links the permanent fix to its own ticket

  Scenario: A release with an untraced commit is not ready
    Given a commit since the last release tag references no ticket
    When "/aa-rel-prepare-release" runs
    Then the commit is a finding on the release ticket
    And the release is not marked ready until it traces to a ticket or gets one

  @R-33
  Scenario: Health reports a broken chain
    Given a recent commit references no ticket
    And a ticket referenced by recent commits links to no scenario, record, or page
    When "/aa-fw-health" runs
    Then R-33 is reported as unmet
    And the report lists the commit and the ticket

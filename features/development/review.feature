@agent @development @O-19 @O-20 @O-23 @T-07 @F-014
Feature: /aa-dev-review reviews a merge request against its purpose
  Review a merge request against its ticket, scenarios, plan, and the project's conventions,
  run it yourself, and record findings where the author will see them.

  Background:
    Given a project bootstrapped with "aa init"
    And a merge request for a ticket with scenarios and a plan

  @F-014-01
  Scenario: Purpose before diff, and the branch is run
    When "/aa-dev-review" starts
    Then it reads the ticket, scenarios, and plan before the diff
    And it builds and tests the branch itself and keeps the output

  @F-014-02
  Scenario: A hunk that serves no scenario is a finding
    Given the diff contains a change unrelated to the ticket's scenarios or a stated reason
    When "/aa-dev-review" reviews it
    Then a finding names the hunk and asks what it is for

  @F-014-03
  Scenario: Speculative structure is a finding
    Given the diff introduces an interface with a single implementation and no scenario needing another
    When "/aa-dev-review" reviews it
    Then a finding names the interface and cites the simplest-design opinion

  @F-014-04
  Scenario: A non-deterministic test is blocking
    Given the diff adds a test that sleeps or calls a live service
    When "/aa-dev-review" reviews it
    Then a blocking finding names the test and the source of variance

  @F-014-05
  Scenario: Style is never a review comment
    Given the only issue is one the formatter would fix
    When "/aa-dev-review" reviews it
    Then no style comment is made
    And the finding, if any, is that the tools did not run

  @F-014-06
  Scenario: Findings are recorded where the author sees them
    When "/aa-dev-review" finishes
    Then each finding is on the merge request with file, line, reason, and blocking or not
    And a summary is on the ticket
    And the review says what it did not check

  @F-014-07
  Scenario: Approval means the tests were seen to pass
    When "/aa-dev-review" approves
    Then every scenario had a passing test that the reviewer saw run

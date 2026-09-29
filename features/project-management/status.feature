# Generated from the knowledge base page Requirements/project-management/status. Do not edit: change the page, then pull it.
# Checksum: sha256:238024a76e1ca6e4599412722c3d129474afcbb12553342c78085589021b24a9
@agent @project-management @O-03 @T-04 @T-07 @F-057
Feature: /aa-pm-status reports status from the record, not from memory
  Produce a status report for an iteration, epic, or release from the ticket system and source
  control: done, in progress, blocked, at risk, and why. Every claim traces to a ticket or a
  merge request, blockers come first, and what could not be seen is said.

  Background:
    Given a project bootstrapped with "aa init"
    And an iteration in the ticket system with committed tickets and branches referencing them

  @F-057-01
  Scenario: Counts come from a tool and are quoted
    When "/aa-pm-status" reports on the iteration
    Then the tickets in scope are counted by state with a tool
    And the report quotes the counts, such as how many of the committed tickets are done, in review, and blocked
    And no state is described with a word like "most"

  @F-057-02
  Scenario: Every claim traces to a ticket or a merge request
    When "/aa-pm-status" produces the report
    Then each item in the report links to the ticket or merge request that evidences it

  @F-057-03
  Scenario: Source control can contradict the ticket
    Given a ticket marked done whose branch is not merged
    When "/aa-pm-status" reads source control for the scope
    Then the ticket is reported as at risk
    And the report names the unmerged branch as the reason

  @F-057-04
  Scenario: Blocked items come first and name an owner
    Given two tickets are blocked
    When "/aa-pm-status" assembles the report
    Then the blocked and at-risk items appear before the finished ones
    And each names its blocker and who owns unblocking it

  @F-057-05
  Scenario: The report says what changed
    Given a previous status report exists
    When "/aa-pm-status" produces the new report
    Then it lists the items that changed state, the blockers raised or cleared, and the scope added or removed since the previous report

  @F-057-06
  Scenario: An unreachable system is reported, not omitted
    Given source control cannot be reached
    When "/aa-pm-status" produces the report
    Then the report says source control was unreachable and what it would have covered

  @F-057-07
  Scenario: The report is returned and posted only if asked
    When "/aa-pm-status" finishes
    Then the report is returned to the user
    And it is posted to the knowledge base or the iteration ticket only when the user asked for that

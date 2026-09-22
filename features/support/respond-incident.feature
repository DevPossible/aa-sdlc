@agent @support @O-19 @T-06 @T-07
Feature: /aa-sup-respond-incident contains an incident and keeps the record as it happens
  Coordinate an active incident: keep a timeline on the incident ticket, contain the impact
  before diagnosing it, communicate at a stated cadence, and close the incident only when
  restoration is verified with evidence and a post-incident review is scheduled.

  Background:
    Given a project bootstrapped with "aa init"
    And an incident ticket with a severity and a current impact

  Scenario: The timeline is written as it happens
    When "/aa-sup-respond-incident" takes an action or makes an observation
    Then it is recorded on the incident ticket with a timestamp at the time it happens
    And nothing is added to the timeline from memory afterwards

  Scenario: Containment comes before diagnosis
    Given a rollback option exists for the last release
    When "/aa-sup-respond-incident" begins
    Then containment such as rollback, turning the feature off, or scaling is chosen before the cause is sought

  Scenario: Irreversible actions wait for the user
    Given the user has not granted rollback in advance
    When "/aa-sup-respond-incident" decides to roll back
    Then it stops and asks before doing so
    And the ask and the answer are recorded on the timeline

  Scenario: Status goes out at a stated cadence
    When "/aa-sup-respond-incident" confirms the incident
    Then a status is sent saying what is known, what is not, what is being done, and who is affected
    And it says when the next status will come
    And each communication is recorded on the ticket with its audience

  Scenario: Every change made during the incident names the incident
    Given a fix is made while the incident is open
    When the change is prepared
    Then the branch, the commit message footer, and the merge request name the incident ticket

  Scenario: Restoration is verified with evidence
    When "/aa-sup-respond-incident" declares service restored
    Then the dashboards, the cleared alerts, and where possible the broken scenario passing are quoted on the ticket
    And the time to restore is computed from the timeline with a tool

  Scenario: Closing the incident schedules the review
    When "/aa-sup-respond-incident" closes the incident
    Then the ticket records the mitigation with links to any rollback or change
    And a post-incident review is scheduled and linked from the incident
    And any change staged during the incident is presented, not committed

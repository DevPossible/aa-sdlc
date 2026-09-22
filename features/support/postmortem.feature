@agent @support @O-18 @T-07
Feature: /aa-sup-postmortem finds contributing causes from the timeline and raises the tickets that prevent recurrence
  After an incident is closed, review what happened using the timeline and the evidence, find
  the contributing causes without blame, record each action as a decision record, and raise the
  tickets that will prevent recurrence or shorten the next response.

  Background:
    Given a project bootstrapped with "aa init"
    And a closed incident ticket with a timeline and a mitigation record

  Scenario: Times are computed from the timeline, not estimated
    When "/aa-sup-postmortem" states the times
    Then time to detect, time to respond, time to restore, and the duration of impact are computed with a tool
    And each quotes the timeline timestamps it was calculated from

  Scenario: A gap in the timeline is said, not filled
    Given the timeline has no timestamp for when the incident was detected
    When "/aa-sup-postmortem" states the times
    Then the review says the time to detect could not be computed
    And no timeline entry is reconstructed

  Scenario: Each decision is asked what made it reasonable at the time
    When "/aa-sup-postmortem" walks the timeline
    Then for each decision the review records what was known then and what was not

  Scenario: Causes name systems and decisions, not people
    When "/aa-sup-postmortem" lists the contributing causes
    Then each cause names a system, a change, or a decision
    And no cause names a person
    And each cause cites the timeline entry or change that evidences it

  Scenario: One action that removes the cause is preferred
    Given a cause could be removed or surrounded by checks
    When "/aa-sup-postmortem" chooses the actions
    Then the action that removes the cause is preferred
    And each choice is a decision record with its options and consequences, linked from the incident

  Scenario: Every action is a ticket with an owner
    When "/aa-sup-postmortem" raises the prevention tickets
    Then every action item is a ticket in the configured ticket project with an owner
    And the review links to each ticket

  Scenario: The review is in the knowledge base and linked from the incident
    When "/aa-sup-postmortem" finishes
    Then the post-incident review is in the knowledge base
    And the incident ticket links to it
    And any decision records kept in the documents folder are staged and presented, not committed

@framework @agent @O-15 @O-01 @T-12
Feature: A requirement starts with written goals; the mock-up comes after
  No requirement begins as a screenshot or a mock-up. It begins as written goals, the outcome
  and then the scenarios, refined until they are unambiguous and testable. The mock-up is
  generated from the scenarios and names the ones it renders. A picture that arrives first is
  evidence for discovery, not a requirement.

  Background:
    Given a project bootstrapped with "aa init"
    And an anchor epic with a measurable outcome

  @G-35
  Scenario: The normal order, goals then scenarios then mock-up
    When "/aa-ba-discover" and "/aa-ba-refine-requirements" produce confirmed scenarios
    And "/aa-ux-prototype" runs for the ticket
    Then every mock-up is produced from the confirmed scenarios
    And every mock-up names the scenarios it renders
    And no scenario cites a mock-up as its source

  @G-35
  Scenario: A screenshot arrives as the whole requirement
    Given a stakeholder provides a screenshot and the words "build this"
    When "/aa-ba-discover" runs
    Then the screenshot is treated as evidence of what the stakeholder wants
    And the goals and scenarios it implies are written as draft scenarios
    And what the screenshot does not show is recorded as questions on the ticket
    And no scenario is written that cites the screenshot as its source

  @G-35
  Scenario: The mock-up is regenerated once the goals are confirmed
    Given draft scenarios written from a screenshot have been refined and confirmed
    When "/aa-ux-prototype" runs
    Then a new mock-up is produced from the confirmed scenarios
    And it names the scenarios it renders
    And where it differs from the original screenshot, the difference is explained on the ticket

  @G-36
  Scenario: A mock-up shows behaviour no scenario states
    Given a mock-up shows a control whose behaviour no scenario describes
    When "/aa-ux-prototype" or "/aa-ux-review-ux" notices it
    Then a question is added to the ticket
    And the scenario is changed first if the behaviour is wanted
    And the mock-up is changed after the scenario

  @G-36
  Scenario: The unhappy path is in the goals before it is in the picture
    Given confirmed scenarios include an error case
    When "/aa-ux-prototype" runs
    Then the mock-up shows the error state the scenario describes
    And it is not left to be invented at implementation time

  Scenario: The step still runs when handed a picture
    Given the only input available is a screenshot
    When "/aa-ba-discover" runs
    Then it does not refuse
    And it says it is treating the picture as evidence and why

  @R-29
  Scenario: Health reports mock-ups with no scenarios behind them
    Given mock-ups linked from tickets name no scenarios
    When "/aa-fw-health" runs
    Then R-29 is reported as unmet with the mock-ups listed

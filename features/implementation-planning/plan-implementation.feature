@agent @implementation-planning @O-10 @O-13 @O-20
Feature: /aa-ip-plan-implementation writes down how before anyone builds
  Before building a ticket, write down which files and components change, in what order, what
  tests prove each step, what could go wrong, and what is still unknown. The plan lives on the
  ticket and is confirmed before build starts.

  Background:
    Given a project bootstrapped with "aa init"
    And a refined ticket with linked scenarios and the thinking behind its size

  Scenario: The plan is written from the real code
    When "/aa-ip-plan-implementation" runs
    Then it reads the files it plans to change, not only the architecture
    And the plan lists the changes in build order, each with the test that proves it
    And the plan names the tiers the change touches and the risks and unknowns

  Scenario: The repository is checked against the refined revision first
    Given a linked scenario changed since the ticket was refined
    When "/aa-ip-plan-implementation" starts
    Then it says what changed and whether the scenarios still hold before planning

  Scenario: Nothing speculative enters the plan
    Given the scenarios describe one export format
    When "/aa-ip-plan-implementation" plans
    Then no step introduces a format registry or a second format
    And every step serves a scenario of the ticket

  Scenario: The plan checks the size
    Given the plan reveals more work than the sizing reasoning saw
    When "/aa-ip-plan-implementation" finishes the plan
    Then the size on the ticket is revised with the reason

  Scenario: A plan longer than the change hands the ticket back
    Given the plan runs to more steps than the change it describes
    When "/aa-ip-plan-implementation" reviews it
    Then the ticket is handed back to refinement to split

  Scenario: Build waits for confirmation
    When "/aa-ip-plan-implementation" presents the plan
    Then the plan is on the ticket with the revision it was written against
    And implementation does not start until the user or the ticket owner confirms it

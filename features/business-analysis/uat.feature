@agent @business-analysis @T-07 @T-12
Feature: /aa-ba-uat confirms with stakeholders that what was built is what they meant
  Walk stakeholders through the scenarios as written against the deployed software, record
  acceptance by name and date for each scenario, and turn every gap into a ticket or a scenario
  change, never a note that fades.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose scenarios are built and deployed to an environment the stakeholder can use

  Scenario: The scenarios are checked against the build before the walkthrough
    Given the ticket records the revision it was built against
    When "/aa-ba-uat" starts
    Then it compares that revision with the head for the linked feature files
    And a scenario that changed since is noted on the ticket before the walkthrough

  Scenario: The walkthrough covers every scenario
    When "/aa-ba-uat" writes the walkthrough order on the ticket
    Then every scenario for the ticket appears in it with the Given it needs set up
    And the scenarios themselves are the test cases, not a rewrite of them

  Scenario: The scenario is walked as written
    Given the stakeholder asks to see something the scenario does not state
    When "/aa-ba-uat" walks the scenario
    Then the Given, When, Then are walked as written
    And the request is recorded as a question on the ticket for the feature file, not as a demo step

  Scenario: Acceptance is recorded by name
    When "/aa-ba-uat" records a scenario as accepted
    Then the result names who accepted it and on what date
    And "UAT passed" on its own is not recorded as a result

  Scenario: A scenario not met becomes a ticket for Development
    Given the software does not do what a scenario says
    When "/aa-ba-uat" records the result
    Then the scenario is marked not accepted with the gap described
    And a new ticket linked to this one is raised for Development

  Scenario: A met scenario that is not what was meant is a requirement change
    Given the software does what a scenario says but the stakeholder meant something else
    When "/aa-ba-uat" records the result
    Then the gap is raised as a question on the ticket and changed in the feature file first
    And it is not recorded as a failure of the build

  Scenario: The results report is on the ticket and linked from the page
    When "/aa-ba-uat" finishes
    Then the UAT results report is on the anchor ticket
    And the knowledge base page links to it and it links back
    And any changed feature file is staged and presented, not committed

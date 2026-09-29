# Generated from the knowledge base page Requirements/business-analysis/uat. Do not edit: change the page, then pull it.
# Checksum: sha256:8105441d39a4baf89d7d1646189a93f367c4e765bf9fdcec45feafdc6c590a86
@agent @business-analysis @T-07 @T-12 @F-005
Feature: /aa-ba-uat confirms with stakeholders that what was built is what they meant
  Walk stakeholders through the scenarios as written against the deployed software, record
  acceptance by name and date for each scenario, and turn every gap into a ticket or a scenario
  change, never a note that fades.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose scenarios are built and deployed to an environment the stakeholder can use

  @F-005-01
  Scenario: The scenarios are checked against the build before the walkthrough
    Given the ticket records the revision and the page versions it was built against
    When "/aa-ba-uat" starts
    Then it pulls the linked feature pages and compares them with the revision and page versions the ticket records
    And a scenario that changed since is noted on the ticket before the walkthrough

  @F-005-02
  Scenario: The walkthrough covers every scenario
    When "/aa-ba-uat" writes the walkthrough order on the ticket
    Then every scenario for the ticket appears in it with the Given it needs set up
    And the scenarios themselves are the test cases, not a rewrite of them

  @F-005-03
  Scenario: The scenario is walked as written
    Given the stakeholder asks to see something the scenario does not state
    When "/aa-ba-uat" walks the scenario
    Then the Given, When, Then are walked as written
    And the request is recorded as a question on the ticket for the feature page, not as a demo step

  @F-005-04
  Scenario: Acceptance is recorded by name
    When "/aa-ba-uat" records a scenario as accepted
    Then the result names who accepted it and on what date
    And "UAT passed" on its own is not recorded as a result

  @F-005-05
  Scenario: A scenario not met becomes a ticket for Development
    Given the software does not do what a scenario says
    When "/aa-ba-uat" records the result
    Then the scenario is marked not accepted with the gap described
    And a new ticket linked to this one is raised for Development

  @F-005-06
  Scenario: A met scenario that is not what was meant is a requirement change
    Given the software does what a scenario says but the stakeholder meant something else
    When "/aa-ba-uat" records the result
    Then the gap is raised as a question on the ticket and written as a Draft scenario on its feature page first
    And it is not recorded as a failure of the build

  @F-005-07
  Scenario: The results report is on the ticket and linked from the page
    When "/aa-ba-uat" finishes
    Then the UAT results report is on the anchor ticket
    And the knowledge base page links to it and it links back
    And any feature page it changed in the documents folder is staged and presented, not committed

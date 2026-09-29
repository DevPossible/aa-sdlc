# Generated from the knowledge base page Requirements/framework/requirements-are-gherkin. Do not edit: change the page, then pull it.
# Checksum: sha256:06604dee32b8ece08d87b373381e480ca1c6fa1120288823c653c572d9961b54
@framework @agent @T-12 @T-14 @O-01 @F-037
Feature: The knowledge base holds the requirements; feature files are pulled from it
  Every project using the framework, and the framework itself, keeps its requirements as feature
  pages in its knowledge base, in structured tables anyone can read and edit. The repository's
  feature files are pulled from the pages per ticket, carry a provenance header, and are never
  edited by hand. The ticket system stays the truth for work state; the pages are the truth for
  what the software must do.

  Background:
    Given a project bootstrapped with "aa init"
    And the project has a features folder

  @R-11 @R-17 @F-037-06
  Scenario: Feature files are the business-facing tests
    Given a project with a tool that can execute feature files
    When generate-tests runs for a ticket
    Then the scenarios for that ticket are the business-facing test cases
    And no separate acceptance criteria document is produced

  @O-01 @F-037-09
  Scenario: Tests name the scenarios they prove
    When a test is written during implement, generate-tests, or e2e-tests
    Then the test names the ids of the scenarios it proves, in the form its test framework supports
    And a scenario with no test naming its id is reported as not covered

  @R-03 @R-16 @F-037-10
  Scenario: A new requirement starts on a feature page
    When a requirement is captured during discover or refine-requirements
    Then it is written as a Draft scenario on a feature page under the project's Requirements section, in its topic
    And no feature file is written for it until the scenario is Approved and a ticket pulls it

  @R-02 @F-037-11
  Scenario: Every Approved scenario is linked to a ticket
    Given an Approved scenario on a feature page
    Then the scenario carries a tag naming the ticket that asked for it
    And the ticket links to the feature page and names the scenario id

  @R-27 @F-037-12
  Scenario: Each ticket begins by pulling its features
    Given a ticket that links to feature pages
    When any anchored step starts on the ticket
    Then it pulls the Approved scenarios of those pages into the features folder
    And each feature file names its page and the page version in its provenance header
    And the ticket records the page versions pulled

  @F-037-13
  Scenario: Only Approved scenarios reach the repository
    Given a feature page with Draft, Approved, and Retired scenarios
    When the page is pulled
    Then the feature file holds the Approved scenarios only
    And a page with no Approved scenario generates no feature file

  @O-19 @F-037-14
  Scenario: A requirement changes on its page, through a ticket
    Given an Approved scenario and the feature file pulled from it
    When the requirement must change
    Then the change is made on the feature page, under a ticket that records why
    And the next pull for that ticket brings the change into the repository

  @O-17 @F-037-15
  Scenario: A feature file edited in the repository is caught at review
    Given a feature file that differs from what its page generates, or that no page generates
    When the change is checked before the commit or in the pipeline
    Then the check fails and names the file
    And it says to change the page and pull it instead
    And the check needs no access to the knowledge base, because the provenance header carries a checksum

  @O-13 @F-037-16
  Scenario: A change found while building is proposed back to the page
    Given an implementer finds a scenario wrong or missing while building
    When they write the change they need
    Then it is converted to the page format and proposed on the feature page for its owner to approve
    And the repository gets the change only by pulling the page once it is Approved

  @O-01 @G-49 @F-037-17
  Scenario: Ids are assigned on the page
    When a feature or a scenario is added to a page with its id cell empty
    Then it is given the next free id, unique in the project for a feature and within its feature for a scenario
    And an id is never renumbered or reused, even when a scenario is moved or retired

  @R-03 @R-06 @F-037-18
  Scenario: With no knowledge base, the documents folder holds the pages
    Given a project with no knowledge base in scope
    Then its feature pages are markdown files under the documents folder's knowledge folder, in the same format
    And moving them into a knowledge base later is an upload, not a rewrite

  @T-14 @F-037-19
  Scenario: Only the project's own pages are read
    Given a knowledge base space shared with other projects
    When features are pulled, counted, or checked
    Then only pages under the project's own root are read
    And no other project's page is changed

  @F-037-20
  Scenario: The framework dogfoods its own rule
    Given the aa-sdlc repository
    Then its own requirements are feature pages under docs/knowledge/Requirements
    And the feature files under features/ are generated from them and checked by the unit tier

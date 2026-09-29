# Generated from the knowledge base page Requirements/business-analysis/discover. Do not edit: change the page, then pull it.
# Checksum: sha256:71eed82b23bc1a3ad87351e7b720fd67f2de1cf9784d31d24e9bdad1c05123b5
@agent @business-analysis @O-01 @O-15 @F-003
Feature: /aa-ba-discover captures what stakeholders need as draft scenarios
  Capture stakeholder input as Draft scenarios on feature pages in the knowledge base from the
  first pass, tagged with the epic, with a question log on the epic for everything not yet
  answered. No feature file is written; the repository gets a scenario by pulling its page once
  the scenario is Approved.
  A screenshot or mock-up that arrives as the request is treated as evidence, not as the
  requirement.

  Background:
    Given a project bootstrapped with "aa init"
    And an anchor epic with an outcome and a transcript of a stakeholder conversation

  @F-003-01
  Scenario: Needs are written as Gherkin from the first pass
    When "/aa-ba-discover" captures the stated needs
    Then each need is a Draft scenario on a feature page under the project's Requirements section
    And each scenario is tagged with the epic
    And the feature description states the business objectives and the scope boundaries
    And no feature file is written

  @F-003-02
  Scenario: A screenshot is a witness, not a specification
    Given the request arrived as a screenshot
    When "/aa-ba-discover" starts
    Then it writes the goals and scenarios the screenshot implies
    And what the screenshot does not show is logged as questions on the epic
    And the screenshot is not recorded as the requirement

  @F-003-03
  Scenario: Silence becomes a question
    Given the stakeholder said nothing about what happens when the input is invalid
    When "/aa-ba-discover" reviews the draft scenarios
    Then a question about the error case is added to the question log
    And the question has its context and an owner
    And no behaviour is assumed for it

  @F-003-04
  Scenario: An out-of-scope need is an explicit non-requirement
    Given the stakeholder asked for something outside the epic's outcome
    When "/aa-ba-discover" captures it
    Then it is recorded as an explicit non-requirement in the feature description
    And it is not silently dropped

  @F-003-05
  Scenario: An existing scenario is not written twice
    Given an existing feature page already states one of the needs
    When "/aa-ba-discover" captures the needs
    Then the existing scenario is linked from the epic
    And no duplicate scenario is written

  @F-003-06
  Scenario: A requirement found only in the ticket is a conflict
    Given the epic description states a requirement that no feature page contains
    When "/aa-ba-discover" checks where the truth lives
    Then it raises the requirement as a conflict on the epic
    And it does not absorb it silently

  @F-003-07
  Scenario: The pages are linked and presented, never committed
    When "/aa-ba-discover" finishes
    Then the epic links to each feature page and its scenario ids, and each page links back
    And where the pages are in the documents folder, the new and changed pages are staged with a Conventional Commit message
    And no commit is made unless the user asked for that commit

  @G-18 @F-003-08
  Scenario: A requirement found only in a feature file is a conflict
    Given a feature file in the repository states a requirement that no feature page generates
    When "/aa-ba-discover" checks where the truth lives
    Then it raises the requirement as a conflict on the epic
    And it does not absorb it into a page silently

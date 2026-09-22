@agent @business-analysis @O-01 @O-15
Feature: /aa-ba-discover captures what stakeholders need as draft scenarios
  Capture stakeholder input as draft Gherkin scenarios in the features folder from the first
  pass, tagged with the epic, with a question log on the epic for everything not yet answered.
  A screenshot or mock-up that arrives as the request is treated as evidence, not as the
  requirement.

  Background:
    Given a project bootstrapped with "aa init"
    And an anchor epic with an outcome and a transcript of a stakeholder conversation

  Scenario: Needs are written as Gherkin from the first pass
    When "/aa-ba-discover" captures the stated needs
    Then each need is a draft scenario in a feature file in the features folder
    And each scenario is tagged with the epic
    And the feature description states the business objectives, the scope boundaries, and the knowledge base page

  Scenario: A screenshot is a witness, not a specification
    Given the request arrived as a screenshot
    When "/aa-ba-discover" starts
    Then it writes the goals and scenarios the screenshot implies
    And what the screenshot does not show is logged as questions on the epic
    And the screenshot is not recorded as the requirement

  Scenario: Silence becomes a question
    Given the stakeholder said nothing about what happens when the input is invalid
    When "/aa-ba-discover" reviews the draft scenarios
    Then a question about the error case is added to the question log
    And the question has its context and an owner
    And no behaviour is assumed for it

  Scenario: An out-of-scope need is an explicit non-requirement
    Given the stakeholder asked for something outside the epic's outcome
    When "/aa-ba-discover" captures it
    Then it is recorded as an explicit non-requirement in the feature description
    And it is not silently dropped

  Scenario: An existing scenario is not written twice
    Given an existing feature file already states one of the needs
    When "/aa-ba-discover" captures the needs
    Then the existing scenario is linked from the epic
    And no duplicate scenario is written

  Scenario: A requirement found only in the ticket is a conflict
    Given the epic description states a requirement that no feature file contains
    When "/aa-ba-discover" checks where the truth lives
    Then it raises the requirement as a conflict on the epic
    And it does not absorb it silently

  Scenario: The feature files are staged and presented, never committed
    When "/aa-ba-discover" finishes
    Then the epic links to the feature file and the page, and the page links back
    And the new and changed feature files are staged with a Conventional Commit message
    And no commit is made unless the user asked for that commit

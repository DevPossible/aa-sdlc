# Generated from the knowledge base page Requirements/ux-design/prototype. Do not edit: change the page, then pull it.
# Checksum: sha256:41bce3673a62774c8018afaaf0c4052fd9303f48e08b3244a1b7e537cfd229e0
@agent @ux-design @O-15 @F-081
Feature: /aa-ux-prototype makes the requirement visible before it is built
  Produce a mockup for every scenario with a user interface, made from the confirmed scenarios
  and naming the ones it renders, an interactive prototype where the interaction matters, and
  feed what stakeholders say back through the feature file.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with confirmed scenarios that describe a user interface

  @F-081-01
  Scenario: No mock-up without confirmed scenarios
    Given a request for a mock-up with no confirmed scenarios behind it
    When "/aa-ux-prototype" starts
    Then it writes or requests the scenarios first
    And no mock-up is produced until they are confirmed

  @F-081-02
  Scenario: A screenshot that arrives first is evidence
    Given the request arrived as a screenshot
    When "/aa-ux-prototype" starts
    Then it writes the goals and scenarios the screenshot implies
    And what the screenshot does not show is logged as questions on the ticket
    And the mock-up is made from the confirmed scenarios, not from the screenshot

  @F-081-03
  Scenario: Every scenario with a user interface has a mockup that names it
    When "/aa-ux-prototype" produces the mockups
    Then every scenario with a user interface has at least one mockup showing its When and Then
    And every mockup names the scenarios it renders

  @F-081-04
  Scenario: The unhappy path is shown
    Given a scenario has an error state
    When "/aa-ux-prototype" produces the mockups
    Then the error state has its own mockup
    And it is not left to be invented at implementation time

  @F-081-05
  Scenario: Variations are labelled with the question they answer
    Given two designs answer the same open question
    When "/aa-ux-prototype" presents them
    Then each variation is labelled with the question it answers

  @F-081-06
  Scenario: Behaviour without a scenario is a question
    Given a mockup shows behaviour no scenario states
    When "/aa-ux-prototype" checks the mockups against the scenarios
    Then the behaviour is recorded as a question on the ticket
    And it is not treated as a requirement

  @F-081-07
  Scenario: Feedback changes the scenario first
    Given a stakeholder's reaction to the prototype changes what the user needs
    When "/aa-ux-prototype" feeds the change back
    Then the scenario in the feature file is changed first
    And the prototype is changed to match it afterwards

  @F-081-08
  Scenario: The prototype covers the primary flow end to end
    When "/aa-ux-prototype" builds the interactive prototype
    Then a stakeholder can complete the scenario's When without help

  @F-081-09
  Scenario: Artifacts are linked, staged, and presented, never committed
    When "/aa-ux-prototype" finishes
    Then every mockup and the prototype are linked from the ticket and the page
    And it asks before sending anything to an audience outside the project
    And files added to the repository are staged with a Conventional Commit message and not committed unless the user asked

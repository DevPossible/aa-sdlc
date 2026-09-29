# Generated from the knowledge base page Requirements/refinement/plan-work. Do not edit: change the page, then pull it.
# Checksum: sha256:8616e284a73bd0c48285642750c13df2c54538c5ea1df4039ea1a1386155ec80
@agent @refinement @F-058
Feature: /aa-rf-plan-work turns an epic and its feature pages into stories
  Break an epic into stories and tasks in the ticket system, split by scenario rather than by
  layer, each small enough to finish in one iteration, each linked to the feature page it
  delivers from and naming exactly the scenario ids it delivers, with dependencies as links and
  gaps sent back as questions.

  Background:
    Given a project bootstrapped with "aa init"
    And an epic with an outcome, feature pages, an architecture, and a priority

  @F-058-01
  Scenario: Every scenario reaches exactly one story
    When "/aa-rf-plan-work" creates the stories
    Then every Approved scenario on the epic's feature pages is linked to exactly one story
    And every story is a child of the epic, links to the feature page it delivers from, and names the scenario ids it delivers

  @F-058-02
  Scenario: Stories are split by scenario, not by layer
    Given a scenario needs a change in the user interface and a change in the service behind it
    When "/aa-rf-plan-work" splits the epic
    Then one story delivers that scenario end to end
    And no story is a layer of the system on its own

  @F-058-03
  Scenario: A story too large for one iteration is split again
    Given a story could not be finished in one iteration by one person or agent
    When "/aa-rf-plan-work" reviews the stories
    Then the story is split along scenario lines until each part can

  @F-058-04
  Scenario: A gap becomes a question, not a guess
    Given the feature pages say nothing about what happens when an upload fails
    When "/aa-rf-plan-work" notices
    Then a question is added to the epic for Business Analysis
    And no story invents the missing behaviour

  @F-058-05
  Scenario: Dependencies are links, not prose
    Given one story needs another finished first
    When "/aa-rf-plan-work" records the dependency
    Then it is a link between the two tickets
    And it is not only described in a ticket's text

  @F-058-06
  Scenario: The outcome is on every story
    When "/aa-rf-plan-work" writes a story
    Then the story states which outcome of the epic it serves

  @F-058-07
  Scenario: A size is grounded in thinking
    When "/aa-rf-plan-work" sizes a story
    Then the story first records what changes, what is unknown, and what could go wrong
    And a number wanted before that thinking exists is given as a labelled range and not recorded as the size

  @G-16 @F-058-08
  Scenario: A Draft scenario is a question, not a story
    Given a feature page of the epic has a Draft scenario
    When "/aa-rf-plan-work" lists the work
    Then no story delivers the Draft scenario
    And a question on the epic asks Business Analysis to settle it

  @G-18 @G-19 @G-54 @F-058-09
  Scenario: Ticket tags reach the feature files only by pulling
    When "/aa-rf-plan-work" has created the stories
    Then each scenario a story delivers carries the story's ticket tag on its feature page
    And the pages are pulled again, so the feature files carry the tags
    And no tag is added to a feature file by hand

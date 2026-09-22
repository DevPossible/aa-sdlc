@agent @refinement
Feature: /aa-rf-plan-work turns an epic and its feature files into stories
  Break an epic into stories and tasks in the ticket system, split by scenario rather than by
  layer, each small enough to finish in one iteration, each linked to exactly the scenarios it
  delivers, with dependencies as links and gaps sent back as questions.

  Background:
    Given a project bootstrapped with "aa init"
    And an epic with an outcome, feature files, an architecture, and a priority

  Scenario: Every scenario reaches exactly one story
    When "/aa-rf-plan-work" creates the stories
    Then every scenario in the epic's feature files is linked to exactly one story
    And every story is a child of the epic and links back to the scenarios it delivers

  Scenario: Stories are split by scenario, not by layer
    Given a scenario needs a change in the user interface and a change in the service behind it
    When "/aa-rf-plan-work" splits the epic
    Then one story delivers that scenario end to end
    And no story is a layer of the system on its own

  Scenario: A story too large for one iteration is split again
    Given a story could not be finished in one iteration by one person or agent
    When "/aa-rf-plan-work" reviews the stories
    Then the story is split along scenario lines until each part can

  Scenario: A gap becomes a question, not a guess
    Given the feature files say nothing about what happens when an upload fails
    When "/aa-rf-plan-work" notices
    Then a question is added to the epic for Business Analysis
    And no story invents the missing behaviour

  Scenario: Dependencies are links, not prose
    Given one story needs another finished first
    When "/aa-rf-plan-work" records the dependency
    Then it is a link between the two tickets
    And it is not only described in a ticket's text

  Scenario: The outcome is on every story
    When "/aa-rf-plan-work" writes a story
    Then the story states which outcome of the epic it serves

  Scenario: A size is grounded in thinking
    When "/aa-rf-plan-work" sizes a story
    Then the story first records what changes, what is unknown, and what could go wrong
    And a number wanted before that thinking exists is given as a labelled range and not recorded as the size

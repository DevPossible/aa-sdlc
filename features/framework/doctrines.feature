# Generated from the knowledge base page Requirements/framework/doctrines. Do not edit: change the page, then pull it.
# Checksum: sha256:cbbebb7bf60a4d3902576f8eaa8c4f0c40402862e1ec3a53625c98ab80747ede
@framework @agent @O-28 @O-18 @T-03 @T-07 @F-087
Feature: Every product has doctrines, and every requirement is checked against them
  Every product has one set of doctrines on a page in the Overview section of its knowledge base:
  a one-sentence mission, who the product is for, a small number of doctrines each with a
  permanent D-nn id, and its non-goals. Outcomes, scenarios, architecture, decision records, the
  order of the backlog, and merge requests are checked against them and cite the doctrine they
  serve or are bounded by. A conflict is never absorbed silently: the work changes, or the
  doctrines are amended from evidence with a decision record. No step blocks when there are none.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base

  @G-57 @F-087-01
  Scenario: An outcome cites the doctrine it serves
    Given the product's doctrines page holds a mission, doctrines D-01 to D-04, and non-goals
    When "/aa-pd-define-outcome" writes the anchor epic
    Then the epic names the doctrines its outcome serves by their ids
    And the epic says it conflicts with no doctrine or non-goal

  @G-57 @F-087-02
  Scenario: A scenario that conflicts with a non-goal is raised, not absorbed
    Given the product's doctrines list a non-goal
    And a stakeholder asks for a behaviour the non-goal excludes
    When "/aa-ba-refine-requirements" refines the scenario for it
    Then it names the non-goal and the conflict on the ticket
    And it does not mark the scenario Approved until the user decides to change the scenario or to propose an amendment

  @G-57 @F-087-03
  Scenario: A conflicting decision is checked the same way
    Given the product's doctrines include a doctrine that a proposed technical option contradicts
    When "/aa-ta-decide" records the decision
    Then the decision record names the doctrine among the reasons for the option chosen or rejected
    And a choice that contradicts the doctrine is recorded only with an amendment the user agreed to

  @G-58 @O-18 @F-087-04
  Scenario: The doctrines are amended deliberately, with a record
    Given feedback from production shows a doctrine no longer describes what the product is for
    When "/aa-pd-iterate" proposes an amendment and the user agrees
    Then a decision record states what changed in the doctrines and why
    And a new doctrine takes the next free D-nn id
    And a doctrine it replaces is marked retired and keeps its id

  @T-03 @G-57 @F-087-05
  Scenario: No doctrines does not block a step
    Given the product has no doctrines page
    When "/aa-ba-discover" runs for a ticket
    Then it produces its draft scenarios and question log
    And it says the doctrine check was made against nothing

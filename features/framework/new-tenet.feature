# Generated from the knowledge base page Requirements/framework/new-tenet. Do not edit: change the page, then pull it.
# Checksum: sha256:19bc60088e50e16e74c8cd0a91909912da1b70af552a31598f4a2bc4f7954251
@framework @agent @fw @F-033
Feature: /aa-internal-new-tenet adds a tenet and makes existing content agree with it
  Tenets are few and govern everything. Adding one means showing it in action and checking
  that nothing already written contradicts it.

  Background:
    Given I am in the aa-sdlc repository

  @F-033-01
  Scenario: Add a well-formed tenet
    When I run "/aa-internal-new-tenet" with a principle and its reasoning
    Then docs/tenets.md gains an entry with the next T-nn id
    And the grouping sentence and every tenet range in the docs are updated
    And a feature page under docs/knowledge/Requirements/framework/ shows the principle applied in at least three situations
    And its feature file is pulled from it into features/, not written by hand

  @F-033-02
  Scenario: Redirect what is not a tenet
    Given the statement is about how to perform a step, or chooses between alternatives
    When I run "/aa-internal-new-tenet"
    Then it says whether the statement is guidance or an opinion
    And it redirects to the right place instead of adding a tenet

  @F-033-03
  Scenario: Existing content is checked for conflicts
    Given an existing opinion or guidance item contradicts the new tenet
    When I run "/aa-internal-new-tenet"
    Then the contradiction is named
    And it is resolved in the same change, or the tenet is not added

  @F-033-04
  Scenario: Governed disciplines and steps cite it
    When "/aa-internal-new-tenet" finishes
    Then every discipline or step the tenet governs lists it under tenets
    And the unit tier passes and the discipline review regenerates

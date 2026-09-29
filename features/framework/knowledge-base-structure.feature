# Generated from the knowledge base page Requirements/framework/knowledge-base-structure. Do not edit: change the page, then pull it.
# Checksum: sha256:2815ba2b4854e4d4c877277379d09442ba7a0fa2574dfff04de54da4434ef79b
@framework @agent @O-27 @T-12 @F-084
Feature: The knowledge base has one structure
  Every project's knowledge base space has six top-level sections: Overview, Requirements,
  Architecture, Operations, Releases, and Guides. Pages explain and index; feature files and
  decision records stay the source of truth. Superseded pages are marked and linked, never deleted.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base

  @F-084-01
  Scenario: A requirement page lives under Requirements and names its feature
    When "/aa-ba-refine-requirements" writes the page for a feature
    Then the page is under the Requirements section
    And its title names the feature and its feature id
    And it links to the feature file, which names the page

  @F-084-02
  Scenario: A decision is indexed, not copied
    When "/aa-ta-decide" records a decision
    Then the decision record is written in the repository
    And the Architecture section's index of decision records links to it

  @F-084-03
  Scenario: A superseded page is kept and linked
    Given a Guides page that a change has made wrong
    When "/aa-doc-maintain-docs" replaces it with a new page
    Then the old page is marked superseded and links to the new one
    And the old page is not deleted

  @F-084-04
  Scenario: A missing section is offered, not assumed
    Given the knowledge base has no Releases section
    When "/aa-fw-init" runs
    Then it offers to create the Releases section, and creates it only with the user's consent

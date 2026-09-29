# Generated from the knowledge base page Requirements/framework/knowledge-base-structure. Do not edit: change the page, then pull it.
# Checksum: sha256:1c3d6b416eda0aac3404129a48b03761af8b1947f0d76c2aaa838746d50b6c01
@framework @agent @O-27 @T-12 @T-14 @F-084
Feature: The knowledge base has one structure
  Every project's knowledge base has six top-level sections under the project's own root:
  Overview, Requirements, Architecture, Operations, Releases, and Guides. The feature pages under
  Requirements are the source of truth for requirements, and the repository's feature files are
  pulled from them; decision records stay in the repository and the other pages explain and
  index. Superseded pages are marked and linked, never deleted.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base

  @F-084-01
  Scenario: A requirement page lives under Requirements and names its feature
    When "/aa-ba-refine-requirements" writes the page for a feature
    Then the page is under the Requirements section of the project's own root
    And its title names the feature and its feature id
    And the feature file pulled from it names the page and its version in its provenance header

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

  @T-14 @G-55 @F-084-05
  Scenario: In a shared space, the sections are under the project's own root
    Given a knowledge base space shared with other projects
    When "/aa-fw-init" creates the sections with the user's consent
    Then they are created under the project's own root page
    And no other project's page and nothing in the space's structure is changed

# Generated from the knowledge base page Requirements/product-management/discover-doctrines. Do not edit: change the page, then pull it.
# Checksum: sha256:3034174925ee15b3ac8f1776418dbc452802987608ddb6346666118927a6ba26
@agent @product-management @O-28 @F-091
Feature: /aa-pd-discover-doctrines proposes doctrines from what the project already shows
  Read an existing product's code, documents, decision records, knowledge base pages, and
  tickets, and propose a mission, who it is for, candidate doctrines, and non-goals, each with
  the evidence it was drawn from. It proposes; it writes no doctrine and assigns no id.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base
    And the product has no doctrines page

  @G-58 @F-091-01
  Scenario: Every proposal names its evidence
    Given a repository with a README, decision records, and code, and a ticket project with epics
    When I run "/aa-pd-discover-doctrines"
    Then it proposes a mission, who the product is for, candidate doctrines, and non-goals
    And each proposal names the file, decision record, page, or ticket it was drawn from
    And each proposal is marked stated or inferred

  @F-091-02
  Scenario: Non-goals come from what was deliberately left out
    Given a decision record that rejected an option and tickets closed as out of scope
    When I run "/aa-pd-discover-doctrines"
    Then the proposed non-goals cite that decision record and those tickets

  @G-16 @F-091-03
  Scenario: Contradictions are listed, not resolved
    Given the README states an aim that the code contradicts
    When I run "/aa-pd-discover-doctrines"
    Then the proposal lists the contradiction with the evidence on both sides
    And neither side is proposed as a doctrine

  @F-091-04
  Scenario: It writes no doctrine
    When "/aa-pd-discover-doctrines" finishes
    Then no doctrines page was created or changed
    And no D-nn id was assigned
    And it recommends "/aa-pd-define-doctrines" to adopt the proposal

  @G-12 @F-091-05
  Scenario: With an anchor ticket the proposal is written on it
    Given a ticket for writing the product's doctrines
    When I run "/aa-pd-discover-doctrines" with the ticket id
    Then the proposal is written on the ticket

  @F-091-06
  Scenario: A blank project has nothing to discover
    Given a blank repository and an empty ticket project
    When I run "/aa-pd-discover-doctrines"
    Then it says there was nothing to read
    And it recommends "/aa-pd-define-doctrines", which asks

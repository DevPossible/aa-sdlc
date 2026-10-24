# Generated from the knowledge base page Requirements/product-management/check-doctrines. Do not edit: change the page, then pull it.
# Checksum: sha256:0a5b56c7e29a1d5a3fbff9aa3460a7a22e9bb745a7043ed9712a7a61432efcc5
@agent @product-management @O-28 @T-03 @F-089
Feature: /aa-pd-check-doctrines reports what conflicts with the doctrines
  Read the doctrines and report every open ticket, approved scenario, and decision record that
  conflicts with a doctrine or non-goal, the doctrines nothing cites, and the epics that cite no
  doctrine, with one recommended command per conflict. It changes nothing.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base

  @G-57 @F-089-01
  Scenario: A conflict is reported as a specific pair
    Given an open ticket asks for a behaviour a non-goal excludes
    When I run "/aa-pd-check-doctrines"
    Then the report names the ticket, the non-goal, and the sentence in each that disagrees
    And it recommends one command for the conflict with the ticket id

  @F-089-02
  Scenario: What nothing cites is reported
    Given no ticket, scenario, or decision record cites D-04
    And an open epic cites no doctrine
    When I run "/aa-pd-check-doctrines"
    Then the report lists D-04 as cited by nothing
    And it lists the epic as citing no doctrine

  @F-089-03
  Scenario: It changes nothing
    When "/aa-pd-check-doctrines" finishes with conflicts found
    Then no ticket, page, or decision record was edited, commented on, or transitioned

  @T-10 @F-089-04
  Scenario: An unread source is not reported clean
    Given the ticket system is out of reach
    When I run "/aa-pd-check-doctrines"
    Then the report says the tickets could not be read and why
    And it still checks the scenarios and decision records

  @F-089-05
  Scenario: No doctrines to check against
    Given the product has no doctrines page
    When I run "/aa-pd-check-doctrines"
    Then it reports that alone
    And it recommends "/aa-pd-discover-doctrines" for a project with anything to read, or "/aa-pd-define-doctrines" for a new one

# Generated from the knowledge base page Requirements/product-management/amend-doctrines. Do not edit: change the page, then pull it.
# Checksum: sha256:e26748c2fb51c52e697c4b8745e4888e3e85f0da4158df58f8ed6d2ee8ab4bcb
@agent @product-management @O-28 @O-18 @F-088
Feature: /aa-pd-amend-doctrines changes one doctrine, from evidence, with a record
  Add, change, or retire one doctrine or non-goal, from evidence, with a decision record that
  states it before and after and what it invalidates. Ids are permanent: a new doctrine takes
  the next free id, a changed one keeps its id, and a retired one is marked and kept.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base
    And the product's doctrines page holds doctrines D-01 to D-04

  @G-58 @F-088-01
  Scenario: A new doctrine takes the next free id
    When "/aa-pd-amend-doctrines" adds a doctrine and I confirm it
    Then the new doctrine is D-05
    And a decision record states the evidence, the options considered, and the consequences
    And the page links the record beside the doctrine

  @G-58 @F-088-02
  Scenario: A retired doctrine keeps its id
    When "/aa-pd-amend-doctrines" retires D-02 and I confirm it
    Then D-02 is marked retired and still on the page
    And no later doctrine is renumbered
    And the decision record that retired it is linked

  @F-088-03
  Scenario: What the amendment invalidates is raised, not changed
    Given open tickets and approved scenarios cite D-03
    When "/aa-pd-amend-doctrines" changes D-03 and I confirm it
    Then the decision record lists each item that cited D-03 and whether it still holds
    And each item that no longer holds gets a question on its ticket
    And none of those items is changed by this step

  @G-57 @F-088-04
  Scenario: Convenience is not evidence
    Given the only reason given for changing D-01 is that a requirement in hand conflicts with it
    When I run "/aa-pd-amend-doctrines"
    Then it says the change has no evidence beyond the requirement
    And it recommends changing the requirement instead
    And it changes no doctrine unless I still confirm the amendment

  @T-06 @F-088-05
  Scenario: Nothing is written before I confirm
    When "/aa-pd-amend-doctrines" proposes an amendment and I decline it
    Then the doctrines page is unchanged
    And no decision record is written

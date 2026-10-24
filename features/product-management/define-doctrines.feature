# Generated from the knowledge base page Requirements/product-management/define-doctrines. Do not edit: change the page, then pull it.
# Checksum: sha256:29a692c69008dd283abf3d0c1c61aea680d0171feb3016a8494d518058582ea8
@agent @product-management @O-28 @O-18 @F-090
Feature: /aa-pd-define-doctrines writes the product's first set of doctrines
  Write the product's first set of doctrines with the user, from a discovered proposal or from
  the user's answers: a one-sentence mission, who it is for, doctrines numbered from D-01, and
  the non-goals, on a page in the Overview section, holding only what the user confirmed, with a
  decision record for the adoption.

  Background:
    Given a project bootstrapped with "aa init" with a linked knowledge base

  @G-58 @F-090-01
  Scenario: Adopt a discovered proposal
    Given a proposal from "/aa-pd-discover-doctrines"
    When I run "/aa-pd-define-doctrines"
    Then it walks me through each proposal to accept, edit, or drop
    And the doctrines page holds only what I confirmed
    And the doctrines are numbered from D-01, each with why it holds

  @F-090-02
  Scenario: Ask where there is nothing to read
    Given a blank repository and an empty ticket project
    When I run "/aa-pd-define-doctrines"
    Then it asks one question at a time for the mission, who the product is for, what it must always do, and what it must never become
    And it writes the page once I confirm the whole set

  @G-53 @F-090-03
  Scenario: The page lives in the Overview section
    When "/aa-pd-define-doctrines" writes the doctrines
    Then the page is in the Overview section under the project's knowledge root
    And it records the date the set was adopted

  @G-41 @O-18 @F-090-04
  Scenario: The adoption is a decision record
    When "/aa-pd-define-doctrines" writes the doctrines
    Then a decision record numbered next in the sequence records the adoption and the candidates I rejected
    And the page and the anchor ticket link to it

  @F-090-05
  Scenario: An existing set is never overwritten
    Given the product already has a doctrines page
    When I run "/aa-pd-define-doctrines"
    Then it changes nothing
    And it recommends "/aa-pd-amend-doctrines"

  @F-090-06
  Scenario: No knowledge base in scope
    Given no knowledge base is in scope
    When "/aa-pd-define-doctrines" writes the doctrines
    Then the page is written in the documents folder's knowledge folder in the same format

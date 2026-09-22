@framework @fw
Feature: /aa-fw-new-opinion adds an opinion with all of its plumbing
  An opinion is only real when the framework depends on it. The command adds the entry and
  everything the entry implies, in one change, in the aa-sdlc repository.

  Background:
    Given I am in the aa-sdlc repository

  Scenario: Add a well-formed opinion
    When I run "/aa-fw-new-opinion" with a stance, its reasoning, and the alternatives it rejects
    Then docs/opinions.md gains an entry with the next O-nn id
    And the entry has stance, why, rejected, would-change-our-mind, and requirements
    And the README's opinions list and the design's opinions sentence include it

  Scenario: Implied requirements and guidance are created
    Given the stance assumes a capability the framework did not previously require
    When I run "/aa-fw-new-opinion"
    Then a requirement with met and unmet scenarios exists for the capability
    And any practice the stance demands is guidance attached to the steps it applies to

  Scenario: A stance that names a tool is refused
    Given the stance names a product or language
    When I run "/aa-fw-new-opinion"
    Then it reports the tenet T-01 violation
    And it does not write the entry until the stance is rewritten

  Scenario: Ids are never reused
    Given an earlier opinion was withdrawn
    When I run "/aa-fw-new-opinion"
    Then the new opinion takes the next unused id, not the withdrawn one

  Scenario: The change is verified before it is reported
    When "/aa-fw-new-opinion" finishes
    Then the unit test tier has been run and passes
    And docs/discipline-review.md has been regenerated
    And the decision log records the opinion
    And the report lists every file changed

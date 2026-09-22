@framework @O-09 @O-03
Feature: One repository, one ticket project
  Every repository maps to exactly one ticket system project. Many repositories may share it;
  none manages tickets across two. The mapping lives in the project config and every anchored
  step works within it.

  Background:
    Given a repository initialised with "aa init"
    And its project config names one ticket project

  Scenario: Every step anchors within the configured project
    When any anchored step is run with a ticket id
    Then the id is resolved within the configured project without a qualifier
    And the step refuses an id from another project and explains why

  Scenario: Two repositories share a project
    Given a second repository whose config names the same ticket project
    When work in both repositories anchors on the same ticket
    Then both record their branches and merge requests against that one ticket
    And neither repository's config changes

  Scenario: Cross-project work is linked, not shared
    Given work in this repository depends on a ticket in a different project
    When a step needs to reference it
    Then a ticket exists in this repository's project that links to the other
    And the step anchors on the local ticket

  Scenario: Health reports a repository drifting across projects
    Given branches or commits reference tickets from two projects
    When "/aa-fw-health" runs
    Then R-22 is reported as unmet with the foreign references listed

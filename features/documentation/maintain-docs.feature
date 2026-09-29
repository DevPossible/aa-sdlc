# Generated from the knowledge base page Requirements/documentation/maintain-docs. Do not edit: change the page, then pull it.
# Checksum: sha256:46a445eff97e210392ba7644972777390aed4f93bd2026be40063cd9b449b051
@agent @documentation @O-16 @T-12 @F-017
Feature: /aa-doc-maintain-docs audits feature files and documentation against the feature pages
  Walk from the feature pages outward: check that every feature file in the repository was
  pulled from its page, unedited, and is current with it, then check the rest of the
  documentation against the pages, the code, and the running software. Fix what has drifted,
  delete what describes something that no longer exists, surface contradictions as conflicts,
  and report what was checked, fixed, and ticketed.

  Background:
    Given a project bootstrapped with "aa init"
    And a maintenance ticket and a previous documentation health report naming the revision and page versions it audited

  @F-017-01
  Scenario: The scope is the changes since the last audit
    When "/aa-doc-maintain-docs" starts
    Then it computes the range of changes merged since the revision the last report audited
    And it lists the feature pages, feature files, code, and documents changed in that range
    And it records the head revision and the page versions this audit is made against

  @F-017-03
  Scenario: A document that states what no scenario states is a conflict
    Given a knowledge base page or a document describes behaviour no scenario on the feature pages states
    When "/aa-doc-maintain-docs" compares them
    Then a question naming the document and the behaviour is on the ticket
    And neither the feature page nor the document is changed to hide the difference

  @F-017-04
  Scenario: Documentation for something that no longer exists is deleted
    Given a document in the documents folder describes a component that is no longer in the code
    When "/aa-doc-maintain-docs" checks the documents folder
    Then the document is deleted
    And the deletion is listed in the health report

  @F-017-05
  Scenario: What needs an owner becomes a ticket
    Given a finding that needs a decision this run cannot make
    When "/aa-doc-maintain-docs" sorts its findings
    Then a ticket in the configured project carries the finding
    And the anchor ticket and the health report link to it

  @F-017-06
  Scenario: The health report lives in the knowledge base
    When "/aa-doc-maintain-docs" finishes
    Then a health report in the knowledge base lists the revision range and page versions, what was checked, fixed, deleted, ticketed, and not checked
    And the report is linked from the ticket

  @F-017-07
  Scenario: Fixes are staged on a branch and presented, never committed
    When "/aa-doc-maintain-docs" finishes
    Then the documentation changes are on a branch that references the ticket
    And they are staged as one change set with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

  @R-46 @F-017-08
  Scenario: A feature file behind its page is pulled again
    Given a feature page changed and the feature file pulled from it did not
    When "/aa-doc-maintain-docs" checks the feature files against their pages
    Then the feature file is brought up to date by pulling the page
    And the page is not changed to match the feature file
    And the fix is listed in the health report

  @G-18 @R-46 @F-017-09
  Scenario: A feature file edited by hand is restored from its page
    Given a feature file with no provenance header or a checksum that no longer matches
    When "/aa-doc-maintain-docs" runs the feature-file check
    Then the check's output is quoted in the health report
    And the feature file is restored by pulling its page
    And a change the edit meant is proposed on the page for its owner to approve

  @T-12 @R-46 @F-017-10
  Scenario: A feature file no page generates is a conflict
    Given a feature file that no feature page generates
    When "/aa-doc-maintain-docs" runs the feature-file check
    Then a question naming the feature file is on the ticket
    And the feature file is neither absorbed into a page nor deleted without its owner's word

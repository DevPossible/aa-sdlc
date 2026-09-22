@agent @documentation @O-16
Feature: /aa-doc-maintain-docs audits documentation against the feature files
  Walk from the feature files outward to the knowledge base and the documents folder, fix
  what has drifted, delete what describes something that no longer exists, surface
  contradictions as conflicts, and report what was checked, fixed, and ticketed.

  Background:
    Given a project bootstrapped with "aa init"
    And a maintenance ticket and a previous documentation health report naming the revision it audited

  Scenario: The scope is the changes since the last audit
    When "/aa-doc-maintain-docs" starts
    Then it computes the range of changes merged since the revision the last report audited
    And it lists the feature files, code, and documents changed in that range
    And it records the head revision this audit is made against

  Scenario: A page behind its feature file is fixed from the feature file
    Given a feature file changed and its knowledge base page did not
    When "/aa-doc-maintain-docs" compares them
    Then the page is updated to match the feature file
    And the fix is listed in the health report

  Scenario: A page that states what no scenario states is a conflict
    Given a knowledge base page describes behaviour no scenario in its feature file states
    When "/aa-doc-maintain-docs" compares them
    Then a question naming the page and the behaviour is on the ticket
    And neither the feature file nor the page is changed to hide the difference

  Scenario: Documentation for something that no longer exists is deleted
    Given a document in the documents folder describes a component that is no longer in the code
    When "/aa-doc-maintain-docs" checks the documents folder
    Then the document is deleted
    And the deletion is listed in the health report

  Scenario: What needs an owner becomes a ticket
    Given a finding that needs a decision this run cannot make
    When "/aa-doc-maintain-docs" sorts its findings
    Then a ticket in the configured project carries the finding
    And the anchor ticket and the health report link to it

  Scenario: The health report lives in the knowledge base
    When "/aa-doc-maintain-docs" finishes
    Then a health report in the knowledge base lists the revision range, what was checked, fixed, deleted, ticketed, and not checked
    And the report is linked from the ticket

  Scenario: Fixes are staged on a branch and presented, never committed
    When "/aa-doc-maintain-docs" finishes
    Then the documentation changes are on a branch that references the ticket
    And they are staged as one change set with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

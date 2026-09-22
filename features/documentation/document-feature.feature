@agent @documentation @O-16
Feature: /aa-doc-document-feature documents a ticket from its scenarios
  Write or update the user-facing and developer-facing documentation for a ticket, written
  from its scenarios and verified against the running software, in the places the project
  keeps each kind, linked from the ticket and the feature's knowledge base page.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose change has merged, with scenarios and configured documentation locations

  Scenario: Documentation is written where the project keeps it
    When "/aa-doc-document-feature" starts
    Then it reads the documentation locations from the project config or the knowledge base
    And developer documentation goes in the documents folder
    And user documentation goes in the knowledge base or the configured user documentation location
    And no new location is invented

  Scenario: The feature is run before it is described
    When "/aa-doc-document-feature" writes the user documentation
    Then it has walked each scenario against the running software
    And a user can do what each scenario describes by following the documentation

  Scenario: The software and a scenario disagree
    Given the running software does not do what a scenario says
    When "/aa-doc-document-feature" finds this
    Then a question naming the difference is on the ticket
    And the documentation describes what the scenario says, not what the software does

  Scenario: Scenarios are linked or embedded, never restated
    When "/aa-doc-document-feature" refers to a scenario
    Then the documentation links to or embeds the scenario
    And no prose copy of the scenario exists

  Scenario: The unhappy path is documented
    Given a scenario describes what happens when the feature goes wrong
    When "/aa-doc-document-feature" writes the user documentation
    Then the documentation says what the user sees and what to do next

  Scenario: A developer can find the feature and its tests
    When "/aa-doc-document-feature" writes the developer documentation
    Then it names where the feature lives, its configuration keys and environment templates, and any migration
    And it names how the feature is tested at each tier and how to run those tests from the root test script

  Scenario: The change is staged, linked, and presented, never committed
    When "/aa-doc-document-feature" finishes
    Then the documentation links to the ticket and the feature's knowledge base page and both link back
    And the changes are staged as one change set with a docs-typed Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

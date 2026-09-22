@agent @technical-analysis @O-04 @O-18 @O-20
Feature: /aa-ta-architect decides the shape of the system with the reasons
  Decide the components, boundaries, integrations, data, and technology stack for an epic,
  each traced to the scenario that requires it or the decision record that justifies it, and
  record every significant choice as a numbered, dated, immutable decision record.

  Background:
    Given a project bootstrapped with "aa init"
    And an epic with feature files and a technical constraints document

  Scenario: Every scenario traces to the components that satisfy it
    When "/aa-ta-architect" writes the system architecture
    Then the architecture lists every scenario and the components that satisfy it
    And it shows every integration boundary and the responsibility of each component

  Scenario: Nothing enters the architecture without a scenario or a decision record
    Given the feature files describe one consumer of a notification
    When "/aa-ta-architect" designs the notification boundary
    Then no extension point for further consumers is added
    And every component, boundary, and extension point names the scenario or decision record behind it

  Scenario: Each technology choice has a decision record
    When "/aa-ta-architect" writes the technology stack document
    Then every technology choice cites a decision record
    And each record is numbered next in the repository sequence, dated, and lists the options rejected
    And the constraints imposed on Development and Operations are stated explicitly

  Scenario: A changed choice supersedes rather than edits
    Given an accepted decision record chose a storage approach
    When "/aa-ta-architect" reaches a different conclusion
    Then a new decision record is written that supersedes the old one and links back to it
    And the old record is not edited

  Scenario: An unknown is time-boxed, not designed around
    Given a scenario depends on behaviour nobody can confirm
    When "/aa-ta-architect" meets it
    Then a time box is stated before investigating
    And an unknown that survives the box becomes a spike ticket and a labelled assumption on the epic

  Scenario: The architecture is staged and presented, never committed
    When "/aa-ta-architect" finishes
    Then the architecture and its decision records are linked from the epic and the knowledge base page
    And the changed files are staged with a Conventional Commit message naming the epic
    And no commit is made unless the user asked for that commit

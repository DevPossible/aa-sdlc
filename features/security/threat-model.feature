@agent @security @O-18 @F-069
Feature: /aa-sec-threat-model turns threats into decisions and testable requirements
  Work through the architecture from an attacker's view, following the data across every
  trust boundary, rate each threat and decide to mitigate, accept, or transfer it with a
  reason, and turn every mitigation into a scenario in the features folder and a ticket.

  Background:
    Given a project bootstrapped with "aa init"
    And an epic with a system architecture, a technology stack document, and feature files

  @F-069-01
  Scenario: Every boundary and flow is considered
    When "/aa-sec-threat-model" writes the threat model
    Then the model lists the assets, every trust boundary they cross, and every data flow in the architecture
    And every threat is recorded against the boundary it applies to

  @F-069-02
  Scenario: Every threat has a rating and a decision
    When "/aa-sec-threat-model" rates the threats
    Then every threat has a rating from impact and likelihood
    And every threat has one decision of mitigate, accept, or transfer, with a reason
    And an accepted risk names its owner

  @F-069-03
  Scenario: A security posture decision is a decision record
    Given a threat is accepted rather than mitigated
    When "/aa-sec-threat-model" records the acceptance
    Then a decision record is written, numbered next in the sequence and dated
    And the record is linked from the epic

  @F-069-04
  Scenario: Every mitigation is a scenario a test can verify
    Given a threat is to be mitigated by limiting payload size
    When "/aa-sec-threat-model" writes the security requirement
    Then a scenario exists in the features folder with a hostile action and an observable outcome
    And the scenario is tagged with its ticket and the feature names its knowledge base page
    And no requirement reads only as an instruction such as "validate input"

  @F-069-05
  Scenario: Every mitigation is a ticket someone can build
    When "/aa-sec-threat-model" raises the security requirements
    Then each mitigation has a ticket in the configured ticket project as a child of the epic
    And each ticket links to its scenario

  @F-069-06
  Scenario: The new scenarios are staged and presented, never committed
    When "/aa-sec-threat-model" finishes
    Then the threat model is in the knowledge base and linked from the epic
    And the new feature files are staged with a Conventional Commit message naming the epic
    And no commit is made unless the user asked for that commit

  @F-069-07
  Scenario: The threats are enumerated by a separate mind where one is available
    Given the harness can run the aa-sec subagent
    When "/aa-sec-threat-model" runs
    Then it hands following the data, enumerating the threats, and rating them to the aa-sec subagent
    And where no subagent is available it does that work itself

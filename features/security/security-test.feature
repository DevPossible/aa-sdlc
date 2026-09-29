# Generated from the knowledge base page Requirements/security/security-test. Do not edit: change the page, then pull it.
# Checksum: sha256:50fcc02249738540c118f7ba42ded2235cdac6abc2f75668256ec60bd18a5abc
@agent @security @F-068
Feature: /aa-sec-security-test proves the built system against the threat model
  Test the built system for the weaknesses the threat model and the common weakness classes
  predict, record a result for every security scenario and a ticket for every finding, and
  map each required control to its evidence in the compliance report.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket with a threat model, security scenarios, and a built system in a production-like environment

  @F-068-01
  Scenario: The model comes before the checklist
    When "/aa-sec-security-test" plans the tests
    Then every security scenario from the threat model has a named test
    And the common weakness classes are added after the scenarios, each with a named test

  @F-068-02
  Scenario: Production is never tested without written permission
    Given the only deployed system is production
    And the ticket carries no written permission to test it
    When "/aa-sec-security-test" starts
    Then it stops before running any test against production
    And it records on the ticket what permission is needed

  @F-068-03
  Scenario: A scanner result counts only for the current revision
    Given a dependency scan report exists from an earlier revision
    When "/aa-sec-security-test" runs the security tooling
    Then it runs the scanner against the current revision
    And it quotes the actual output rather than the earlier report

  @F-068-04
  Scenario: Every scenario has a result and every finding has a ticket
    When "/aa-sec-security-test" finishes the run
    Then every security scenario has a result on the ticket, including any reported as not run with the reason
    And every finding has a severity from impact and likelihood and a ticket in the configured ticket project
    And every finding can be reproduced from the recorded steps

  @F-068-05
  Scenario: The compliance report maps controls to evidence
    When "/aa-sec-security-test" updates the security compliance report
    Then every control the organisation requires maps to the evidence that it is met or to the ticket that will meet it
    And no control is left unmapped

  @F-068-06
  Scenario: Run output in the repository is staged, never committed
    Given the project config keeps run output in the documents folder
    When "/aa-sec-security-test" finishes
    Then the run output is staged with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

  @F-068-07
  Scenario: The security pass is run by a separate mind where one is available
    Given the harness can run the aa-sec subagent
    When "/aa-sec-security-test" runs
    Then it hands the plan, the tooling, the scenarios, and the findings to the aa-sec subagent with the threat model
    And where no subagent is available it does that work itself

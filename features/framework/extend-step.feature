# Generated from the knowledge base page Requirements/framework/extend-step. Do not edit: change the page, then pull it.
# Checksum: sha256:d5c1311b7326f9a5eebbe21842b2fdf18718cc1efe80a1f04f4331082b5b2386
@agent @framework @T-01 @T-02 @T-11 @T-12 @F-026
Feature: /aa-fw-extend walks a need to a valid, installable extension
  The step reads what is installed before adding, fits the kind to the need, refuses what would
  change core by name, writes the feature file before the skill, declares requirements in the
  extension's own id range, validates before installing, and stages rather than commits. The
  kinds of extension and their shapes are specified in extensibility.feature; this file
  specifies how the step behaves.

  Background:
    Given a project bootstrapped with "aa init"
    And a need the installed skills do not cover

  @F-026-01
  Scenario: What exists is read before anything is added
    When "/aa-fw-extend" runs
    Then it reads the installed extensions at every scope and the organisation config repository if one is set
    And where an existing pack covers the same technology or process it offers to add to that pack

  @F-026-02
  Scenario: The kind is fitted to the need and confirmed
    When "/aa-fw-extend" chooses the kind
    Then it explains in one sentence why that kind fits
    And it confirms the choice with the user before scaffolding

  @F-026-03
  Scenario: A change to core is refused by name
    Given the need would redefine a core skill, step, tenet, or opinion
    When "/aa-fw-extend" assesses it
    Then it names the exact core item it would change
    And it offers the nearest allowed alternative

  @F-026-04
  Scenario: The feature file comes before the skill
    When "/aa-fw-extend" scaffolds the extension
    Then scenarios describing its behaviour exist in its features folder, tagged with the framework ids they realise
    And no skill text is written before them

  @F-026-05
  Scenario: Requirements are declared in the extension's own range
    When "/aa-fw-extend" scaffolds the extension
    Then every capability its guidance depends on is a requirement with an id in the extension's own numbered range
    And the manifest names the range

  @F-026-06
  Scenario: Validation runs before installation and is quoted
    When "/aa-fw-extend" finishes scaffolding
    Then it checks the structure, the manifest, the requirement ids, and the feature files
    And it checks that nothing in core changed and that no core-level guidance names a tool
    And every problem is reported with the file that has it
    And the extension is installed at the chosen scope only when validation passes, with the validator output quoted

  @F-026-07
  Scenario: The extension is staged, not committed
    When "/aa-fw-extend" finishes
    Then the extension's files are staged as one change set with a Conventional Commit message
    And no commit is made unless the user asked for it
    And the ticket, when one was given, records what was produced and where

  @F-026-08
  Scenario: Without a ticket the step still runs
    Given no ticket was given
    When "/aa-fw-extend" runs
    Then it produces the extension locally
    And it says that no ticket was updated

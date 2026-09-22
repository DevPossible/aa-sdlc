@framework @agent @O-21 @T-09 @T-10
Feature: Conventions are enforced by tools, not by people
  Coding conventions live as formatter and linter configuration committed to the repository.
  Formatting is automated on changed files. Linting runs from the root build and the pipeline
  calls the same script. A formatter is required; a linter is recommended, and where none is
  known for a language the project says so once and health warns rather than blocks.

  Background:
    Given a project bootstrapped with "aa init"
    And formatter and linter configuration committed for the project's languages

  @G-44 @G-01
  Scenario: A change is formatted and linted before it is presented
    When "/aa-dev-implement" reaches a green build
    Then the formatter has run on the changed files and no others
    And the root build has run with the lint switch and reported no findings
    And the staged change is presented for the user to commit

  @G-44
  Scenario: A linter finding is fixed or justified, never ignored
    Given the linter reports a finding on a changed file
    When "/aa-dev-implement" handles it
    Then the finding is fixed
    Or a suppression is added beside it with the reason
    And the change is not presented with the finding outstanding

  @G-44
  Scenario: Style is not argued in review
    Given a merge request whose only stylistic issue is one the formatter would fix
    When "/aa-dev-review" reviews it
    Then no style comment is made
    And the review notes that the formatter did not run on that file, if so

  @G-44
  Scenario: The pipeline and the developer run the same lint
    When "/aa-ops-setup-pipeline" writes the lint stage
    Then the stage calls the root build with the lint switch
    And a lint failure in the pipeline can be reproduced locally with the same command

  @G-44
  Scenario: A language with no known linter is recorded, not blocked
    Given the project uses a language for which no linter is known
    When "/aa-dev-setup-environment" configures the tools
    Then the development environment configuration records that no linter is known for that language
    And the formatter is still configured for it
    And "/aa-fw-health" warns for R-12 and nothing blocks

  Scenario: Conventions never live only in a document
    Given a style rule that can be expressed as formatter or linter configuration
    When it is proposed as a paragraph in a document
    Then it is added to the configuration instead
    And the document, if any, points to the configuration

  Scenario: Enforced by a hook where the target allows
    Given the target supports hooks
    When "aa setup" installs the framework
    Then a pre-commit hook runs the formatter on changed files and the linter
    And a failure is reported with its output, never bypassed

  @R-35
  Scenario: Health reports a project with no root way to lint
    Given neither a lint switch on the build script nor a root lint script exists
    When "/aa-fw-health" runs
    Then R-35 is reported as unmet
    And the remedy names "aa init"

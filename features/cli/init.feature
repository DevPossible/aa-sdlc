# Generated from the knowledge base page Requirements/cli/init. Do not edit: change the page, then pull it.
# Checksum: sha256:f2eff188ca53d4a17889acf4ef83cd081e7ea9e13918df11a4bf8a3d62cb2ded
@cli @T-11 @R-05 @R-06 @R-07 @R-08 @R-16 @F-006
Feature: aa init bootstraps a repository
  Lays down what a repository needs before an agent is involved: the project config, the
  documents folder, the features folder, and project-scope skills and commands. Then hands off
  to the agent for the checks and fixes that need judgement.

  Background:
    Given "aa setup" has been run on this machine

  @F-006-01
  Scenario: Initialise the current directory
    Given I am in a project directory
    When I run "aa init"
    Then a project config exists at the project root
    And a documents folder exists
    And a features folder exists
    And project-scope skills and commands are installed for each harness chosen for this repository

  @F-006-02
  Scenario: Initialise a directory by path
    When I run "aa init -path <dir>"
    Then <dir> is initialised exactly as the current directory would have been

  @F-006-03
  Scenario: Project not under source control
    Given the directory is not a repository
    When I run "aa init"
    Then it offers to initialise a repository
    And it proceeds only with consent

  @F-006-04
  Scenario: Layer the scopes into the project config
    Given user, team, and enterprise configs exist
    When I run "aa init"
    Then the project config is created from the merged scopes
    And project settings take precedence over team, team over enterprise

  @F-006-05
  Scenario: Set default conventions
    When I run "aa init"
    Then the project config records a default pattern for referencing the anchor ticket
    And the pattern can be changed in the project config

  @O-21 @R-35 @F-006-06
  Scenario: Add a lint stub to the build script
    When I run "aa init"
    Then the "build" script stub accepts a lint switch
    And the stub names what it must do: run the formatter in check mode and each configured linter
    And it says which languages were detected with no known linter, if any

  @O-18 @R-32 @F-006-07
  Scenario: Create the decision record sequence
    When I run "aa init"
    Then the decision record folder exists at the location the project config names
    And it holds a template with context, options, decision, and consequences
    And record 0001 records the adoption of the framework, dated today
    And the location can be changed in the project config to a knowledge base page

  @O-14 @R-28 @F-006-08
  Scenario: Record the commit message format
    When I run "aa init"
    Then the project config records the Conventional Commits pattern
    And it records the default list of commit types
    And the types and scopes can be changed in the project config

  @O-09 @R-22 @F-006-09
  Scenario: Record the one ticket project
    When I run "aa init"
    Then it asks which ticket system project or group this repository maps to
    And the project config records exactly one
    And a second repository may record the same project

  @F-006-10
  Scenario: Re-running is safe
    Given "aa init" has already been run here
    When I run "aa init" again
    Then existing config, folders, and feature files are left as they are
    And missing pieces are added

  @F-006-11
  Scenario: Hand off to the agent
    When "aa init" completes
    Then it tells the user to run "/aa-fw-health" and "/aa-fw-init" in their agent

  @F-006-12
  Scenario: Health is not a CLI verb
    When I run "aa health"
    Then the CLI explains that health is an agent command
    And it names "/aa-fw-health"

  @F-006-13
  Scenario: The guidance sets are installed beside the project skills
    Given I am in a project directory
    When I run "aa init"
    Then the shared guidance sets are installed at project scope with no command
    And every installed skill at project scope points at the guidance sets by their project-scope path

  @F-006-14
  Scenario: The project instruction file points at the framework
    Given Codex is a configured target
    When I run "aa init" and name a ticket project
    Then AGENTS.md at the repository root has an AA-SDLC block naming the ticket project and "/aa-fw-whatsnext"
    And any text already in AGENTS.md outside the block is kept

  @F-006-15
  Scenario: Re-running replaces the block, never duplicates it
    Given AGENTS.md already has an AA-SDLC block
    When I run "aa init" again
    Then AGENTS.md has exactly one AA-SDLC block

  @F-006-16
  Scenario: The ticket life cycle and knowledge base sections are recorded
    When I run "aa init"
    Then the project config maps the ticket kinds and life-cycle states, starting from the framework's own names
    And the project config maps the knowledge base sections, starting from the framework's own names

  @F-006-17
  Scenario: Ask which harnesses the repository gets
    Given Claude Code, Gemini CLI, and Qwen Code are found on this machine
    When I run "aa init" interactively
    Then it lists only the harnesses found on this machine or already in the repository as a checklist
    And it ticks only the harnesses the repository already has folders for
    And project-scope skills and commands are installed only for the harnesses I leave ticked
    And the project config records exactly those harnesses as its targets

  @F-006-18
  Scenario: The machine's harnesses are not the repository's
    Given "aa setup" recorded Claude Code, Gemini CLI, and Windsurf in the user config
    When I run "aa init" and tick only Claude Code
    Then no .gemini or .windsurf folder is created in the repository
    And the project config's targets name only Claude Code

  @F-006-19
  Scenario: Name the harnesses without being asked
    When I run "aa init -targets claude-code,codex"
    Then it does not ask which harnesses to install into
    And project-scope skills and commands are installed for Claude Code and Codex only

  @F-006-20
  Scenario: Without anyone to ask, only the harnesses already in the repository
    Given no terminal is attached and no harness is named
    When I run "aa init"
    Then project-scope skills and commands are installed only for harnesses the repository already has folders for
    And when there are none, it installs none and says how to name them with -targets

  @F-006-21
  Scenario: A repository that already records its harnesses is not asked again
    Given the project config names its targets
    When I run "aa init" again
    Then it installs for those targets without asking
    And it says to edit the project config's targets, or run "aa uninstall -scope project", to change them

  @F-006-22
  Scenario: Check the tools the project lists
    Given the project config lists tools with check commands
    When I run "aa init"
    Then it runs each check and reports each tool as found with its version, too old, or missing
    And a tool with no check command is left to "/aa-fw-health" in the agent

  @F-006-23
  Scenario: Install a missing project tool only with explicit consent
    Given the project config lists a missing tool with an install command for this platform
    When I run "aa init" interactively
    Then it shows the exact install command and runs it only if I agree
    And "-yes" alone never runs an install command from a project config
    And with no install command for this platform it says to run the root initialize script

  @F-006-24
  Scenario: A blank repository is surveyed in the agent
    Given the repository has no code to infer a stack from
    When I run "aa init"
    Then it says "/aa-fw-init" will ask what the project is and which tools it needs

@cli @T-11 @F-008
Feature: aa setup bootstraps the machine
  The main CLI verb. Run once per machine after installing the package globally. It prepares
  every agent target on the machine so that any repository can then be initialised with aa init.

  Background:
    Given the aa-sdlc package is installed globally

  @F-008-01
  Scenario: Detect installed agent targets
    When I run "aa setup"
    Then it lists every supported agent target found on the machine
    And it installs the skills and commands for each at user scope

  @F-008-02
  Scenario: Write the user config
    When I run "aa setup"
    Then a user-scope config exists
    And it records the targets installed and the package version

  @F-008-03
  Scenario: Connect to an organisation config repository
    When I run "aa setup" with an organisation config repository
    Then the enterprise and team plugins and settings from that repository are layered over core
    And the user config records the repository

  @F-008-04
  Scenario: Re-running is safe
    Given "aa setup" has already been run
    When I run "aa setup" again
    Then nothing is duplicated
    And any newly installed agent targets are picked up

  @F-008-05
  Scenario: No supported target found
    Given no supported agent target is installed
    When I run "aa setup"
    Then it names the targets it supports
    And it still writes the user config

  @F-008-06
  Scenario: Tell the user what to do next
    When "aa setup" completes
    Then it tells the user to run "aa init" in a repository

  @F-008-07
  Scenario: The guidance sets are installed once beside the skills
    When I run "aa setup"
    Then the shared guidance sets are installed at user scope with no command
    And every installed skill at user scope points at the guidance sets by their user-scope path

  @F-008-08
  Scenario: Install into every harness found
    Given Claude Code, Codex, and Gemini CLI are installed on this machine
    When I run "aa setup"
    Then it lists all three as installed at user scope
    And the skills are written once to the Claude Code skills folder and once to the shared agents skills folder
    And Gemini CLI gets its commands in its own command format
    And the user config records all three targets

  @F-008-09
  Scenario: Choose the harnesses explicitly
    Given Claude Code and Codex are installed on this machine
    When I run "aa setup -targets codex"
    Then only Codex is installed
    And the user config records only codex

  @F-008-10
  Scenario: Pick from a checklist
    Given Claude Code and Codex are installed on this machine
    When I run "aa setup" interactively and untick Claude Code
    Then only Codex is installed

  @F-008-11
  Scenario: A harness that would see a skill twice is named
    Given Claude Code and Codex are installed on this machine
    And Cursor is installed on this machine
    When I run "aa setup"
    Then it names Cursor as reading the skills from more than one folder

  @F-008-12
  Scenario: A harness that cannot load skills is named, not installed into
    Given Aider is installed on this machine
    When I run "aa setup"
    Then it says Aider has no skills support and installs nothing for it

  @F-008-13
  Scenario: Discipline subagents are installed where the harness takes them
    Given Claude Code and Codex are installed on this machine
    When I run "aa setup"
    Then Claude Code gets one subagent per delivery discipline
    And nothing is written for Codex's subagents

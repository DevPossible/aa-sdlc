@cli @T-03 @F-083
Feature: aa uninstall removes the framework from the harnesses the user picks
  The reverse of aa setup and aa init. It removes only what the framework installed: the aa-
  skills, the shared guidance sets, the aa- commands, and the AA-SDLC block in an instruction
  file. Anything else in those folders and files is the user's and is left alone. Harnesses that
  are not picked keep working, even where they shared a folder with one that was removed.

  Background:
    Given "aa setup" has been run on this machine

  @F-083-01
  Scenario: Remove the framework from one harness
    Given Claude Code and Codex are installed and set up
    When I run "aa uninstall -targets codex"
    Then the shared agents skills folder no longer holds any aa- skill
    And Claude Code still has every skill and command
    And the user config records only claude-code

  @F-083-02
  Scenario: A harness that shared a folder keeps its skills
    Given Claude Code and Cursor are installed and set up
    When I run "aa uninstall -targets claude-code"
    Then Cursor's skills are reinstalled in a folder it reads
    And the Claude Code skills and commands are gone

  @F-083-03
  Scenario: Remove the framework from every harness
    Given Claude Code and Codex are installed and set up
    When I run "aa uninstall -all"
    Then no aa- skill, guidance set, or command remains in any harness folder at user scope
    And the user config records no targets

  @F-083-04
  Scenario: Only the framework's files are removed
    Given a skill of the user's own sits beside the aa- skills
    When I run "aa uninstall -all"
    Then the user's own skill is still there

  @F-083-05
  Scenario: Pick from a checklist
    Given Claude Code and Codex are installed and set up
    When I run "aa uninstall" interactively and tick Codex
    Then only Codex's framework files are removed

  @F-083-06
  Scenario: Nothing is removed without a choice
    When I run "aa uninstall" with no targets named, no -all, and no terminal
    Then it removes nothing
    And it says to name the harnesses with -targets or use -all

  @F-083-07
  Scenario: Remove the framework from a repository
    Given I am in a repository initialised with "aa init"
    When I run "aa uninstall -all -scope project"
    Then no aa- skill or command remains in the repository
    And the AA-SDLC block is gone from its instruction files
    And the rest of each instruction file is left as it was

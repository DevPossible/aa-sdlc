@framework @agent @O-22 @O-16 @T-07
Feature: Dependencies change through the package manager, never by hand
  A dependency is added, updated, or removed only through the ecosystem's package manager, so
  conflicts are resolved, warnings surfaced, transitive dependencies re-resolved, and the lock
  file regenerated in one operation. A version in a manifest or lock file is never edited by
  hand. A tool refusal is a finding on the ticket, never something to bypass.

  Background:
    Given a project bootstrapped with "aa init"
    And an ecosystem with a package manager and a committed lock file

  @G-45
  Scenario: A dependency is updated with the tool
    Given a ticket to update a dependency to a newer version
    When "/aa-dev-implement" makes the change
    Then the package manager's update command is run with the version requested
    And the manifest and the lock file both change
    And the transitive dependencies are re-resolved by the tool
    And the two files are staged together as their own commit

  @G-45
  Scenario: An agent does not edit the version number
    Given the agent could satisfy the ticket by changing one number in the manifest
    When "/aa-dev-implement" considers how to make the change
    Then it does not edit the manifest or the lock file
    And it runs the package manager instead

  @G-45
  Scenario: A tool refusal becomes a finding, not a workaround
    Given the package manager refuses the update because of a conflict with another dependency
    When "/aa-dev-implement" receives the refusal
    Then the refusal and its output are recorded on the ticket
    And the conflict is resolved through the tool or the ticket is handed back with the question
    And no file is edited to make the refusal go away

  @G-45
  Scenario: A security patch follows the same rule
    Given "/aa-sec-maintain-security" finds a vulnerable dependency
    When it patches the dependency
    Then the package manager performs the update
    And the warnings it emits are recorded on the patch ticket
    And the manifest and lock file changes are staged together

  @G-45
  Scenario: Review catches a manifest changed without its lock file
    Given a merge request that changes a manifest version and not the lock file
    When "/aa-dev-review" reviews it
    Then a blocking finding says the manifest was edited by hand
    And the finding asks for the change to be redone with the package manager

  Scenario: The lock file is always committed
    Given the package manager has regenerated the lock file
    When the change is staged
    Then the lock file is part of the staged change
    And it is never ignored or deleted to resolve a conflict

  @R-36
  Scenario: Health reports a manifest that disagrees with its lock file
    Given a manifest names a version the lock file does not resolve to
    When "/aa-fw-health" runs
    Then R-36 is reported as unmet
    And the remedy is to run the package manager, never to edit the lock file

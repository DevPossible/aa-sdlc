@agent @security @O-16 @O-22
Feature: /aa-sec-maintain-security keeps the released system safe and its evidence current
  Recurring maintenance anchored on a ticket: patch dependencies through the package manager
  in small tested steps, rotate and remove secrets without ever recording one, review access,
  and keep the patch log and compliance evidence current.

  Background:
    Given a project bootstrapped with "aa init"
    And a maintenance ticket with dependency and vulnerability reports, a compliance report, and secrets and access inventories

  Scenario: Every vulnerability above the threshold has an outcome
    Given the scanner reports three vulnerabilities above the agreed threshold
    When "/aa-sec-maintain-security" triages them
    Then each is patched, accepted with a written reason and an owner, or ticketed with a date
    And the security patch log in the knowledge base records all three with their tickets

  Scenario: A clean scan is verified before it is reported
    Given the scanner reports no findings
    When "/aa-sec-maintain-security" reads the report
    Then it confirms the scanner ran against the current head before reporting clean

  Scenario: A dependency is patched through the package manager
    When "/aa-sec-maintain-security" patches a dependency
    Then the change is made with the package manager and the manifest and lock file move together
    And no version is edited by hand
    And the root build and tests are run and their output quoted

  Scenario: A tool refusal is recorded, not bypassed
    Given the package manager refuses an update because of a conflict
    When "/aa-sec-maintain-security" meets the refusal
    Then the refusal is recorded on the ticket to be resolved
    And the lock file is not edited to make it go away

  Scenario: A found secret is referenced, never repeated
    Given a secret value is found in a committed configuration file
    When "/aa-sec-maintain-security" reports it
    Then the report names where the secret was and not what it was
    And the secret is rotated, the file holds a placeholder for the key, and the exposure has a ticket

  Scenario: Every control has evidence or a ticket
    When "/aa-sec-maintain-security" updates the compliance audit evidence
    Then every control has current evidence or an open ticket

  Scenario: Each patch is staged as its own commit, never committed
    When "/aa-sec-maintain-security" finishes
    Then each dependency change is staged as its own commit with a Conventional Commit message naming the ticket
    And no commit is made unless the user asked for that commit

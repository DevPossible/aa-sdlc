@agent @operations @O-24
Feature: /aa-ops-validate-production confirms from evidence that the release did what it claimed
  After a release, the running artifact identity is checked against the one the release named,
  every verification check is run read-only and recorded with its evidence, and key metrics
  are computed before and after over a stated window with every regression ticketed.

  Background:
    Given a project bootstrapped with "aa init"
    And a release deployed to production with verification checks, notes, and a performance baseline

  Scenario: The running identity matches the release
    When "/aa-ops-validate-production" runs
    Then the identity of the artifact running in production is read from the platform or the deployment record
    And it is compared with the identity the release named
    And the result is recorded on the release ticket

  Scenario: A mismatched identity stops the validation
    Given the running artifact identity differs from the one the release named
    When "/aa-ops-validate-production" compares them
    Then it records the mismatch on the release ticket
    And it raises an incident rather than continuing the checks

  Scenario: Every check has a result with evidence
    When "/aa-ops-validate-production" runs the verification checks
    Then every check on the release has a result
    And each result carries its evidence and the time it was taken
    And a failed check is recorded as an incident or a rollback, never fixed in production

  Scenario: Metrics are computed, not glanced at
    When "/aa-ops-validate-production" compares metrics to the baseline
    Then each key metric is computed before and after over a stated window with a tool
    And the window, the query, and the numbers appear in the production metrics report in the knowledge base

  Scenario: A regression is ticketed
    Given a metric moved the wrong way beyond what the baseline allows
    When "/aa-ops-validate-production" finds it
    Then a ticket with the numbers and the window is linked from the release ticket
    And the report says whether the regression warrants rollback

  Scenario: Validation changes nothing
    When "/aa-ops-validate-production" runs
    Then no setting, data, or deployment in production is changed
    And no file in the repository is changed
    And the release ticket ends with the results, the report link, and what remains

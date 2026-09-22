@agent @operations @O-16
Feature: /aa-ops-observability makes the running system visible
  Every scenario maps to a signal production can show, the dashboards show the outcome metrics
  and the health of each component, every alert is code in the repository with a runbook, an
  owner, and a reasoned threshold, and a scenario the code cannot show becomes a ticket for the
  signal.

  Background:
    Given a project bootstrapped with "aa init"
    And an anchor epic with outcome metrics and scenarios linked to the ticket

  Scenario: Every scenario maps to a signal
    When "/aa-ops-observability" runs
    Then the ticket lists, for each scenario, the metric, log event, or trace that shows it being met and the component that emits it
    And signals users feel, latency and error rate at the edge, come before machine measures

  Scenario: A missing signal is a ticket on the code
    Given a scenario that production cannot currently show
    When "/aa-ops-observability" reaches it
    Then a ticket for the code change that emits the signal is raised and linked from the anchor ticket
    And no alert is defined on a signal that does not exist yet

  Scenario: Dashboards show the outcome and the health of each component
    When "/aa-ops-observability" builds the dashboards
    Then the dashboards in the observability tool show the outcome metrics from define-outcome
    And they show the health of each component in the architecture
    And each dashboard is linked from the knowledge base page and the page from the dashboard

  Scenario: The runbook comes before the alert
    When "/aa-ops-observability" defines an alert
    Then a runbook for it exists in the documents folder before the alert is enabled
    And the alert names its owner and the reason for its threshold

  Scenario: Alerts are code in the repository
    Given the observability tool accepts alert definitions as code
    When "/aa-ops-observability" defines the alerts
    Then the definitions are in the repository and staged with the runbooks as one change set with a Conventional Commit message
    And no commit is made unless the user asked for it

  Scenario: Alerts the tool cannot hold as code are documented
    Given the observability tool does not accept alert definitions as code
    When "/aa-ops-observability" defines the alerts
    Then each alert is documented in the documents folder with its runbook, owner, and threshold

  Scenario: An alert nobody would act on is not added
    Given a proposed alert has no action anyone would take when it fires
    When "/aa-ops-observability" reviews the alerts
    Then the alert is removed or not added
    And the reason is recorded on the ticket

  Scenario: The signals are proven to arrive
    When "/aa-ops-observability" finishes
    Then the system was exercised or a known event replayed
    And what the dashboard showed and which alerts fired is quoted in the report

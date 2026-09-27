@agent @framework @T-03 @T-04 @T-10
Feature: /aa-fw-whatsnext names the one thing to do next
  The step reviews the working folder, and the ticket system and knowledge base it links to, in a
  fixed order of layers: foundation, work in flight, recent changes held to the opinions, the
  knowledge base in step with those changes, then the next ticket. It stops at the first major
  gap and recommends one thing, usually a command with its arguments. It changes nothing and
  never blocks; a layer it cannot reach is reported as not checked, never as passed.

  Scenario: An empty folder needs a project first
    Given an empty folder
    When I run "/aa-fw-whatsnext"
    Then it recommends "aa init", then "/aa-fw-init" to link the ticket project and the knowledge base
    And it lists every later layer as not reached

  Scenario: A foundation gap comes from the health report
    Given a repository whose health report shows a required requirement unmet
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-fw-init" naming that requirement
    And it does not probe the requirements a second time

  Scenario: Unfinished work comes before new work
    Given a repository with uncommitted changes on a branch that names a ticket
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-dev-finish-branch" with that ticket id
    And it does not recommend a new ticket

  Scenario: Recent code without tests
    Given the foundation passes and no work is in flight
    And a recent commit on the default branch changed code and no test
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-qa-generate-tests" with the commit's ticket id
    And the evidence names the commit and the files it changed
    And it cites O-07

  Scenario: A failing build outranks everything after it
    Given the foundation passes and no work is in flight
    And the root test script fails on the default branch
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-dev-fix-bug" naming the failing test
    And it quotes the test output

  Scenario: A significant decision without a record
    Given the foundation passes and no work is in flight
    And a recent commit added a dependency with no decision record
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-ta-decide"
    And it cites O-18

  Scenario: The knowledge base is out of step with recent changes
    Given the code layers pass
    And a knowledge base page linked to a recent ticket describes behaviour that ticket changed
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-doc-maintain-docs" naming the page

  Scenario: Everything is in order, so the next ticket
    Given every layer before the backlog passes
    And the highest-priority ticket in the current iteration is refined but has no confirmed plan
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-ip-plan-implementation" with that ticket id

  Scenario Outline: The next ticket's state chooses the command
    Given every layer before the backlog passes
    And the highest-priority ticket in the current iteration is <state>
    When I run "/aa-fw-whatsnext"
    Then it recommends "<command>" with that ticket id

    Examples:
      | state                            | command                    |
      | not refined                      | /aa-rf-refine-ticket       |
      | refined without a confirmed plan | /aa-ip-plan-implementation |
      | planned                          | /aa-dev-implement          |
      | built but not accepted           | /aa-ba-uat                 |

  Scenario: No iteration and no backlog
    Given every layer before the backlog passes
    And there is no current iteration
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-pm-plan-iteration"

  Scenario: A system out of reach is not a pass
    Given the knowledge base cannot be reached
    When I run "/aa-fw-whatsnext"
    Then it reports the knowledge layer as not checked, with the reason
    And it continues with the layers it can check
    And it never lists the knowledge layer as passed

  Scenario: Only the first major gap is reported
    Given the foundation passes
    And there is work in flight and a recent commit without tests
    When I run "/aa-fw-whatsnext"
    Then it reports only the work in flight
    And it lists the recent-changes layer as not reached

  Scenario: It changes nothing
    When I run "/aa-fw-whatsnext" in any folder
    Then no file, ticket, page, commit, or install is created or changed

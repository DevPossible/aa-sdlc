# Generated from the knowledge base page Requirements/framework/whatsnext. Do not edit: change the page, then pull it.
# Checksum: sha256:0e64d5d25d6e4ca658b1c511f6db7a97f7d433a375c84f6504b05b090b4015fb
@agent @framework @T-03 @T-04 @T-10 @F-045
Feature: /aa-fw-whatsnext names the one thing to do next
  The step reviews the working folder, and the ticket system and knowledge base it links to, in a
  fixed order of layers: foundation, work in flight, recent changes held to the opinions, the
  knowledge base in step with those changes, then the next ticket. It stops at the first major
  gap and recommends one thing, usually a command with its arguments. It changes nothing and
  never blocks; a layer it cannot reach is reported as not checked, never as passed.

  @F-045-01
  Scenario: An empty folder needs a project first
    Given an empty folder
    When I run "/aa-fw-whatsnext"
    Then it recommends "aa init", then "/aa-fw-init" to link the ticket project and the knowledge base
    And it lists every later layer as not reached

  @F-045-02
  Scenario: A foundation gap comes from the health report
    Given a repository whose health report shows a required requirement unmet
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-fw-init" naming that requirement
    And it does not probe the requirements a second time

  @F-045-03
  Scenario: Unfinished work comes before new work
    Given a repository with uncommitted changes on a branch that names a ticket
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-dev-finish-branch" with that ticket id
    And it does not recommend a new ticket

  @F-045-04
  Scenario: Recent code without tests
    Given the foundation passes and no work is in flight
    And a recent commit on the default branch changed code and no test
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-qa-generate-tests" with the commit's ticket id
    And the evidence names the commit and the files it changed
    And it cites O-07

  @F-045-14
  Scenario: A recently changed scenario that no test names
    Given the foundation passes and no work is in flight
    And a recent commit added or changed a scenario whose id no test names
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-qa-generate-tests" with that scenario id and the commit's ticket id
    And it cites R-40

  @F-045-05
  Scenario: A failing build outranks everything after it
    Given the foundation passes and no work is in flight
    And the root test script fails on the default branch
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-dev-fix-bug" naming the failing test
    And it quotes the test output

  @F-045-06
  Scenario: A significant decision without a record
    Given the foundation passes and no work is in flight
    And a recent commit added a dependency with no decision record
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-ta-decide"
    And it cites O-18

  @F-045-07
  Scenario: The knowledge base is out of step with recent changes
    Given the code layers pass
    And a knowledge base page linked to a recent ticket describes behaviour that ticket changed
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-doc-maintain-docs" naming the page

  @F-045-08
  Scenario: Everything is in order, so the next ticket
    Given every layer before the backlog passes
    And the highest-priority ticket in the current iteration is refined but has no confirmed plan
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-ip-plan-implementation" with that ticket id

  @F-045-09
  Scenario Outline: The next ticket's state chooses the command
    Given every layer before the backlog passes
    And the highest-priority ticket in the current iteration is <state>
    When I run "/aa-fw-whatsnext"
    Then it recommends "<command>" with that ticket id

    Examples:
      | state                             | command                    |
      | New                               | /aa-rf-refine-ticket       |
      | Refined                           | /aa-ip-plan-implementation |
      | Planned                           | /aa-dev-implement          |
      | In review, with its change merged | /aa-ba-uat                 |
      | Accepted                          | /aa-rel-prepare-release    |

  @F-045-10
  Scenario: No iteration and no backlog
    Given every layer before the backlog passes
    And there is no current iteration
    When I run "/aa-fw-whatsnext"
    Then it recommends "/aa-pm-plan-iteration"

  @F-045-11
  Scenario: A system out of reach is not a pass
    Given the knowledge base cannot be reached
    When I run "/aa-fw-whatsnext"
    Then it reports the knowledge layer as not checked, with the reason
    And it continues with the layers it can check
    And it never lists the knowledge layer as passed

  @F-045-12
  Scenario: Only the first major gap is reported
    Given the foundation passes
    And there is work in flight and a recent commit without tests
    When I run "/aa-fw-whatsnext"
    Then it reports only the work in flight
    And it lists the recent-changes layer as not reached

  @F-045-15
  Scenario: The remaining planned work closes every report
    Given a current iteration with open tickets in several states
    When I run "/aa-fw-whatsnext"
    Then after the recommendation it reports how many tickets remain open in the iteration, counted by state
    And it reports this whichever layer stopped the review

  @F-045-13
  Scenario: It changes nothing
    When I run "/aa-fw-whatsnext" in any folder
    Then no file, ticket, page, commit, or install is created or changed

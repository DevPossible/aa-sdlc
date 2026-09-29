# F-045 /aa-fw-whatsnext names the one thing to do next

| Feature | F-045 |
| --- | --- |
| Name | /aa-fw-whatsnext names the one thing to do next |
| Tags | @agent @framework @T-03 @T-04 @T-10 |
| File | whatsnext |

The step reviews the working folder, and the ticket system and knowledge base it links to, in a
fixed order of layers: foundation, work in flight, recent changes held to the opinions, the
knowledge base in step with those changes, then the next ticket. It stops at the first major
gap and recommends one thing, usually a command with its arguments. It changes nothing and
never blocks; a layer it cannot reach is reported as not checked, never as passed.

## F-045-01 An empty folder needs a project first

| Scenario | F-045-01 |
| --- | --- |
| Name | An empty folder needs a project first |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an empty folder |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "aa init", then "/aa-fw-init" to link the ticket project and the knowledge base |
| And | it lists every later layer as not reached |

## F-045-02 A foundation gap comes from the health report

| Scenario | F-045-02 |
| --- | --- |
| Name | A foundation gap comes from the health report |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a repository whose health report shows a required requirement unmet |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-fw-init" naming that requirement |
| And | it does not probe the requirements a second time |

## F-045-03 Unfinished work comes before new work

| Scenario | F-045-03 |
| --- | --- |
| Name | Unfinished work comes before new work |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a repository with uncommitted changes on a branch that names a ticket |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-dev-finish-branch" with that ticket id |
| And | it does not recommend a new ticket |

## F-045-04 Recent code without tests

| Scenario | F-045-04 |
| --- | --- |
| Name | Recent code without tests |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the foundation passes and no work is in flight |
| And | a recent commit on the default branch changed code and no test |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-qa-generate-tests" with the commit's ticket id |
| And | the evidence names the commit and the files it changed |
| And | it cites O-07 |

## F-045-14 A recently changed scenario that no test names

| Scenario | F-045-14 |
| --- | --- |
| Name | A recently changed scenario that no test names |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the foundation passes and no work is in flight |
| And | a recent commit added or changed a scenario whose id no test names |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-qa-generate-tests" with that scenario id and the commit's ticket id |
| And | it cites R-40 |

## F-045-05 A failing build outranks everything after it

| Scenario | F-045-05 |
| --- | --- |
| Name | A failing build outranks everything after it |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the foundation passes and no work is in flight |
| And | the root test script fails on the default branch |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-dev-fix-bug" naming the failing test |
| And | it quotes the test output |

## F-045-06 A significant decision without a record

| Scenario | F-045-06 |
| --- | --- |
| Name | A significant decision without a record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the foundation passes and no work is in flight |
| And | a recent commit added a dependency with no decision record |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-ta-decide" |
| And | it cites O-18 |

## F-045-07 The knowledge base is out of step with recent changes

| Scenario | F-045-07 |
| --- | --- |
| Name | The knowledge base is out of step with recent changes |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the code layers pass |
| And | a knowledge base page linked to a recent ticket describes behaviour that ticket changed |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-doc-maintain-docs" naming the page |

## F-045-08 Everything is in order, so the next ticket

| Scenario | F-045-08 |
| --- | --- |
| Name | Everything is in order, so the next ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | every layer before the backlog passes |
| And | the highest-priority ticket in the current iteration is refined but has no confirmed plan |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-ip-plan-implementation" with that ticket id |

## F-045-09 The next ticket's state chooses the command

| Scenario | F-045-09 |
| --- | --- |
| Name | The next ticket's state chooses the command |
| Kind | Scenario Outline |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | every layer before the backlog passes |
| And | the highest-priority ticket in the current iteration is <state> |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "<command>" with that ticket id |

### Examples

| state | command |
| --- | --- |
| New | /aa-rf-refine-ticket |
| Refined | /aa-ip-plan-implementation |
| Planned | /aa-dev-implement |
| In review, with its change merged | /aa-ba-uat |
| Accepted | /aa-rel-prepare-release |

## F-045-10 No iteration and no backlog

| Scenario | F-045-10 |
| --- | --- |
| Name | No iteration and no backlog |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | every layer before the backlog passes |
| And | there is no current iteration |
| When | I run "/aa-fw-whatsnext" |
| Then | it recommends "/aa-pm-plan-iteration" |

## F-045-11 A system out of reach is not a pass

| Scenario | F-045-11 |
| --- | --- |
| Name | A system out of reach is not a pass |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the knowledge base cannot be reached |
| When | I run "/aa-fw-whatsnext" |
| Then | it reports the knowledge layer as not checked, with the reason |
| And | it continues with the layers it can check |
| And | it never lists the knowledge layer as passed |

## F-045-12 Only the first major gap is reported

| Scenario | F-045-12 |
| --- | --- |
| Name | Only the first major gap is reported |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the foundation passes |
| And | there is work in flight and a recent commit without tests |
| When | I run "/aa-fw-whatsnext" |
| Then | it reports only the work in flight |
| And | it lists the recent-changes layer as not reached |

## F-045-15 The remaining planned work closes every report

| Scenario | F-045-15 |
| --- | --- |
| Name | The remaining planned work closes every report |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a current iteration with open tickets in several states |
| When | I run "/aa-fw-whatsnext" |
| Then | after the recommendation it reports how many tickets remain open in the iteration, counted by state |
| And | it reports this whichever layer stopped the review |

## F-045-13 It changes nothing

| Scenario | F-045-13 |
| --- | --- |
| Name | It changes nothing |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-fw-whatsnext" in any folder |
| Then | no file, ticket, page, commit, or install is created or changed |

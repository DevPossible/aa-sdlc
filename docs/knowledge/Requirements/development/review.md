# F-014 /aa-dev-review reviews a merge request against its purpose

| Feature | F-014 |
| --- | --- |
| Name | /aa-dev-review reviews a merge request against its purpose |
| Tags | @agent @development @O-19 @O-20 @O-23 @T-07 |
| File | review |

Review a merge request against its ticket, scenarios, plan, and the project's conventions,
run it yourself, and record findings where the author will see them.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a merge request for a ticket with scenarios and a plan |

## F-014-01 Purpose before diff, and the branch is run

| Scenario | F-014-01 |
| --- | --- |
| Name | Purpose before diff, and the branch is run |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-review" starts |
| Then | it reads the ticket, scenarios, and plan before the diff |
| And | it builds and tests the branch itself and keeps the output |

## F-014-02 A hunk that serves no scenario is a finding

| Scenario | F-014-02 |
| --- | --- |
| Name | A hunk that serves no scenario is a finding |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the diff contains a change unrelated to the ticket's scenarios or a stated reason |
| When | "/aa-dev-review" reviews it |
| Then | a finding names the hunk and asks what it is for |

## F-014-03 Speculative structure is a finding

| Scenario | F-014-03 |
| --- | --- |
| Name | Speculative structure is a finding |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the diff introduces an interface with a single implementation and no scenario needing another |
| When | "/aa-dev-review" reviews it |
| Then | a finding names the interface and cites the simplest-design opinion |

## F-014-04 A non-deterministic test is blocking

| Scenario | F-014-04 |
| --- | --- |
| Name | A non-deterministic test is blocking |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the diff adds a test that sleeps or calls a live service |
| When | "/aa-dev-review" reviews it |
| Then | a blocking finding names the test and the source of variance |

## F-014-05 Style is never a review comment

| Scenario | F-014-05 |
| --- | --- |
| Name | Style is never a review comment |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the only issue is one the formatter would fix |
| When | "/aa-dev-review" reviews it |
| Then | no style comment is made |
| And | the finding, if any, is that the tools did not run |

## F-014-06 Findings are recorded where the author sees them

| Scenario | F-014-06 |
| --- | --- |
| Name | Findings are recorded where the author sees them |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-review" finishes |
| Then | each finding is on the merge request with file, line, reason, and blocking or not |
| And | a summary is on the ticket |
| And | the review says what it did not check |

## F-014-07 Approval means the tests were seen to pass

| Scenario | F-014-07 |
| --- | --- |
| Name | Approval means the tests were seen to pass |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-review" approves |
| Then | every scenario had a passing test that the reviewer saw run |

## F-014-08 The review goes to a separate mind where one is available

| Scenario | F-014-08 |
| --- | --- |
| Name | The review goes to a separate mind where one is available |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the harness can run the aa-dev subagent |
| When | "/aa-dev-review" runs |
| Then | it hands the build, the walk through the diff, and the checks of the commits and the proof to the aa-dev subagent |
| And | it records what the agent returns on the merge request |
| And | where no subagent is available it does that work itself, reading the change as if it had not written it |

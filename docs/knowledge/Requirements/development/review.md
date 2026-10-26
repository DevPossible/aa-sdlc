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
| And | an identified candidate for a ticket with scenarios and a plan |

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
| And | it executes the independent candidate gate or validates a still-current independently executed run for the same scope |
| And | it retains actual output, executor identity and independence rather than trusting author-only results |

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
| Then | each finding is on the authorized merge request or local review record with file, line, reason, and blocking or not |
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
| Then | every required scenario has passing proof in an independently executed run the reviewer observed or validated for the same scope |

## F-014-08 The review goes to a separate mind where one is available

| Scenario | F-014-08 |
| --- | --- |
| Name | The review goes to a separate mind where one is available |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the harness can run a separate reviewer and delegation is explicitly authorized |
| When | "/aa-dev-review" runs |
| Then | it hands the candidate, brief and evidence to the separate reviewer |
| And | it records the reviewer's findings on the authorized review surface |
| And | without an authorized reviewer it labels its own review as self-review and does not substitute it for required independent acceptance |

## F-014-09 A feature file not pulled from its page is blocking

| Scenario | F-014-09 |
| --- | --- |
| Name | A feature file not pulled from its page is blocking |
| Kind | Scenario |
| Tags | @G-56 @R-46 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the branch has a feature file with no provenance header, a checksum that does not match, or no page that generates it |
| When | "/aa-dev-review" runs the feature-file check |
| Then | a blocking finding names the feature file |
| And | it says to change the page and pull it, never to edit the file |

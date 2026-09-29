# F-043 Every change traces back to its purpose

| Feature | F-043 |
| --- | --- |
| Name | Every change traces back to its purpose |
| Tags | @framework @agent @O-19 @O-03 @T-12 |
| File | trace-to-purpose |

Every change to the repository can be followed back to why it was made. The commit names a
ticket, the ticket links to the scenarios it satisfies or to the decision record or page that
explains it, and the scenario is tagged with the ticket. The chain runs in both directions.
A change that cannot name its purpose is a ticket to create first or work not to do.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket linked to scenarios in a feature file |

## F-043-01 A change carries its purpose with it

| Scenario | F-043-01 |
| --- | --- |
| Name | A change carries its purpose with it |
| Kind | Scenario |
| Tags | @G-42 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-implement" makes a change for the ticket |
| Then | the branch name references the ticket |
| And | every commit message footer references the ticket |
| And | the merge request references the ticket |
| And | the ticket links back to the merge request |

## F-043-02 From a line of code to the requirement and back

| Scenario | F-043-02 |
| --- | --- |
| Name | From a line of code to the requirement and back |
| Kind | Scenario |
| Tags | @G-42 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merged change for the ticket |
| When | someone follows the chain from a changed line |
| Then | the commit names the ticket |
| And | the ticket names the scenario the change satisfies |
| And | the scenario carries the ticket tag |
| And | from the scenario the same commit can be reached |

## F-043-03 A change with no purpose is stopped before it is made

| Scenario | F-043-03 |
| --- | --- |
| Name | A change with no purpose is stopped before it is made |
| Kind | Scenario |
| Tags | @G-42 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent notices unrelated code it would like to tidy while implementing the ticket |
| When | it considers making the change |
| Then | it does not make it on this branch |
| And | it raises a ticket for the tidy-up, or leaves it |
| And | the ticket's change stays within its own purpose |

## F-043-04 Work with no scenario names a documented explanation

| Scenario | F-043-04 |
| --- | --- |
| Name | Work with no scenario names a documented explanation |
| Kind | Scenario |
| Tags | @G-42 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a change that no scenario states, such as a dependency upgrade |
| When | "/aa-dev-implement" makes it |
| Then | the ticket links to the decision record or page that explains why |
| And | the commit references the ticket |

## F-043-05 Review finds a hunk that traces to nothing

| Scenario | F-043-05 |
| --- | --- |
| Name | Review finds a hunk that traces to nothing |
| Kind | Scenario |
| Tags | @G-42 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merge request whose diff includes a change unrelated to the ticket's scenarios or stated reason |
| When | "/aa-dev-review" reviews it |
| Then | a finding names the hunk and says what purpose it lacks |
| And | the finding asks for a ticket or for the hunk to be removed |

## F-043-06 An incident fix is traced like any other change

| Scenario | F-043-06 |
| --- | --- |
| Name | An incident fix is traced like any other change |
| Kind | Scenario |
| Tags | @G-42 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a change made during an incident to restore service |
| When | "/aa-sup-respond-incident" records the mitigation |
| Then | the change references the incident ticket |
| And | the incident ticket links to the change |
| And | the post-incident review links the permanent fix to its own ticket |

## F-043-07 A release with an untraced commit is not ready

| Scenario | F-043-07 |
| --- | --- |
| Name | A release with an untraced commit is not ready |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit since the last release tag references no ticket |
| When | "/aa-rel-prepare-release" runs |
| Then | the commit is a finding on the release ticket |
| And | the release is not marked ready until it traces to a ticket or gets one |

## F-043-08 Health reports a broken chain

| Scenario | F-043-08 |
| --- | --- |
| Name | Health reports a broken chain |
| Kind | Scenario |
| Tags | @R-33 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a recent commit references no ticket |
| And | a ticket referenced by recent commits links to no scenario, record, or page |
| When | "/aa-fw-health" runs |
| Then | R-33 is reported as unmet |
| And | the report lists the commit and the ticket |

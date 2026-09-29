# F-077 /aa-qa-explore finds what the scenarios did not think of

| Feature | F-077 |
| --- | --- |
| Name | /aa-qa-explore finds what the scenarios did not think of |
| Tags | @agent @testing @T-07 |
| File | explore |

A time-boxed session using the running system with a charter and a testing lens, recording
what was tried and what surprised, and turning every surprise into a defect ticket, a
question on the ticket, or a pending scenario in the feature file.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket naming an area of the running system and its scenarios |

## F-077-01 No charter, no session

| Scenario | F-077-01 |
| --- | --- |
| Name | No charter, no session |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket names an area but no lens and no time box |
| When | "/aa-qa-explore" starts |
| Then | it asks for the lens and the time box before touching the system |
| And | the charter is written on the ticket before the session begins |

## F-077-02 The environment under test is recorded

| Scenario | F-077-02 |
| --- | --- |
| Name | The environment under test is recorded |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-qa-explore" starts the system |
| Then | it prefers the repository's container definitions |
| And | the revision and configuration under test are at the top of the session notes |

## F-077-03 Interruptions are tried and noted against the scenarios

| Scenario | F-077-03 |
| --- | --- |
| Name | Interruptions are tried and noted against the scenarios |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-qa-explore" works the charter |
| Then | it cancels midway, drops the connection, submits twice, goes back, and changes role |
| And | each attempt is noted with what happened and whether any scenario says what should have |

## F-077-04 The time box is honoured

| Scenario | F-077-04 |
| --- | --- |
| Name | The time box is honoured |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the time box has elapsed with the charter half covered |
| When | "/aa-qa-explore" reaches it |
| Then | it stops and records what the charter did and did not cover |
| And | it continues only with a second stated time box |

## F-077-05 A contradiction is a defect ticket

| Scenario | F-077-05 |
| --- | --- |
| Name | A contradiction is a defect ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the system does something a scenario says it must not |
| When | "/aa-qa-explore" records the surprise |
| Then | a defect ticket in the configured project carries the steps to reproduce it |
| And | the defect ticket and the anchor ticket link to each other |

## F-077-06 Behaviour no scenario states is a pending scenario

| Scenario | F-077-06 |
| --- | --- |
| Name | Behaviour no scenario states is a pending scenario |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the system does something no scenario mentions |
| When | "/aa-qa-explore" records the surprise |
| Then | a question is on the ticket |
| And | a pending scenario tagged with the ticket is in the feature file |
| And | the feature file change is staged and presented, not committed |

## F-077-07 Session notes are on the ticket

| Scenario | F-077-07 |
| --- | --- |
| Name | Session notes are on the ticket |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-qa-explore" finishes |
| Then | the ticket holds the charter, the environment, what was tried, what surprised, and what was concluded |
| And | every surprise links to a ticket, a question, or a pending scenario |
| And | nothing remains only as a note |

## F-077-08 The session is run by a separate mind where one is available

| Scenario | F-077-08 |
| --- | --- |
| Name | The session is run by a separate mind where one is available |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the harness can run the aa-qa subagent |
| When | "/aa-qa-explore" runs |
| Then | it hands the session, from starting the system to sorting the surprises, to the aa-qa subagent with the charter |
| And | where no subagent is available it runs the session itself |

# F-074 /aa-ta-decide records one significant decision as a decision record

| Feature | F-074 |
| --- | --- |
| Name | /aa-ta-decide records one significant decision as a decision record |
| Tags | @agent @technical-analysis @O-04 @O-18 @O-20 |
| File | decide |

Capture one technical decision, made in an architecture session or in the middle of a
change, as a one-screen record with context, options, decision, and consequences, numbered
next in the repository sequence, dated, immutable once accepted, and linked from its ticket.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a ticket on which a technical decision has arisen |

## F-074-01 The record has every part and one screen

| Scenario | F-074-01 |
| --- | --- |
| Name | The record has every part and one screen |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-decide" writes the record |
| Then | the record states the context, the options considered, the decision, and the consequences |
| And | it is numbered next in the repository sequence and dated |
| And | it fits on one screen |

## F-074-02 The losing options are recorded with the winner

| Scenario | F-074-02 |
| --- | --- |
| Name | The losing options are recorded with the winner |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | three options were seriously considered |
| When | "/aa-ta-decide" writes the record |
| Then | all three options appear with what each costs and gives |
| And | the chosen option is the simplest that meets the scenarios that exist |

## F-074-03 An existing record that answers the question is cited, not duplicated

| Scenario | F-074-03 |
| --- | --- |
| Name | An existing record that answers the question is cited, not duplicated |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an accepted decision record already answers the question |
| When | "/aa-ta-decide" reads the records in the same area |
| Then | it cites that record on the ticket |
| And | no new record is written |

## F-074-04 A reversal supersedes and never edits

| Scenario | F-074-04 |
| --- | --- |
| Name | A reversal supersedes and never edits |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an accepted decision record is being reversed |
| When | "/aa-ta-decide" records the reversal |
| Then | a new record names the record it supersedes and links back to it |
| And | the superseded record is unchanged |

## F-074-05 The record and the ticket link both ways

| Scenario | F-074-05 |
| --- | --- |
| Name | The record and the ticket link both ways |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-decide" finishes |
| Then | the record links to the ticket and the ticket links to the record |
| And | anything the decision left open is a question on the ticket |

## F-074-06 A record in the repository is staged, never committed

| Scenario | F-074-06 |
| --- | --- |
| Name | A record in the repository is staged, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config keeps decision records in the documents folder |
| When | "/aa-ta-decide" finishes |
| Then | the new record is staged with a Conventional Commit message naming the ticket |
| And | no commit is made unless the user asked for that commit |

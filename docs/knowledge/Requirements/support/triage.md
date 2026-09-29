# F-072 /aa-sup-triage turns an incoming report into a ticket that can be acted on

| Feature | F-072 |
| --- | --- |
| Name | /aa-sup-triage turns an incoming report into a ticket that can be acted on |
| Tags | @agent @support @O-09 @T-04 @T-13 |
| File | triage |

Take an incoming incident, defect report, or request and turn it into a ticket with the right
type, severity, priority, and owner, or link it to the existing ticket it duplicates. Severity
is impact, priority is order, and a report without enough to act on goes back with questions.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an incoming report from the channel the project uses |

## F-072-01 Duplicates are found by symptom and linked, not created

| Scenario | F-072-01 |
| --- | --- |
| Name | Duplicates are found by symptom and linked, not created |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an open ticket describes the same behaviour under a different title |
| When | "/aa-sup-triage" searches existing tickets |
| Then | the search uses the symptom, environment, and error text rather than the reporter's title |
| And | the report is linked to the existing ticket |
| And | no second ticket is created |

## F-072-02 A report without enough to act on goes back with exact questions

| Scenario | F-072-02 |
| --- | --- |
| Name | A report without enough to act on goes back with exact questions |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the report has no steps to reproduce |
| When | "/aa-sup-triage" checks it |
| Then | the ticket records precisely what is missing as questions for the reporter |
| And | the ticket is not marked triaged while a question that blocks reproduction is open |

## F-072-03 Severity is set from impact, per the project's definitions

| Scenario | F-072-03 |
| --- | --- |
| Name | Severity is set from impact, per the project's definitions |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the reporter insists the issue is critical |
| When | "/aa-sup-triage" sets severity |
| Then | the severity follows the project's definitions and the evidence of impact |
| And | the evidence is written on the ticket beside the severity |
| And | an unverified impact is recorded as an assumption |

## F-072-04 Priority is order, not severity restated

| Scenario | F-072-04 |
| --- | --- |
| Name | Priority is order, not severity restated |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sup-triage" sets priority |
| Then | the priority is set relative to the other open tickets |
| And | the ticket says in one sentence why |

## F-072-05 The triaged ticket has a type, severity, priority, and owner

| Scenario | F-072-05 |
| --- | --- |
| Name | The triaged ticket has a type, severity, priority, and owner |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-sup-triage" finishes |
| Then | the ticket has a type, severity, priority, and owner per the project's definitions |
| And | it has environment, steps, expected, actual, and impact |
| And | it links to the scenario it violates where one exists |

## F-072-06 A report belonging to another project stays linked from this one

| Scenario | F-072-06 |
| --- | --- |
| Name | A report belonging to another project stays linked from this one |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the report concerns a ticket in a different ticket project |
| When | "/aa-sup-triage" anchors the work |
| Then | a ticket is created or used in the repository's configured ticket project |
| And | the two tickets are linked |

## F-072-07 Without a ticket system the triage record is produced locally

| Scenario | F-072-07 |
| --- | --- |
| Name | Without a ticket system the triage record is produced locally |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no ticket system is in scope |
| When | "/aa-sup-triage" runs |
| Then | the triaged record is written locally and the report says so |
| And | it is staged and presented, not committed |

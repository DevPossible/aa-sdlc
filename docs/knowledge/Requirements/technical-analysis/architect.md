# F-073 /aa-ta-architect decides the shape of the system with the reasons

| Feature | F-073 |
| --- | --- |
| Name | /aa-ta-architect decides the shape of the system with the reasons |
| Tags | @agent @technical-analysis @O-04 @O-18 @O-20 |
| File | architect |

Decide the components, boundaries, integrations, data, and technology stack for an epic,
each traced to the scenario that requires it or the decision record that justifies it, and
record every significant choice as a numbered, dated, immutable decision record.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an epic with feature files and a technical constraints document |

## F-073-01 Every scenario traces to the components that satisfy it

| Scenario | F-073-01 |
| --- | --- |
| Name | Every scenario traces to the components that satisfy it |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-architect" writes the system architecture |
| Then | the architecture lists every scenario and the components that satisfy it |
| And | it shows every integration boundary and the responsibility of each component |

## F-073-02 Nothing enters the architecture without a scenario or a decision record

| Scenario | F-073-02 |
| --- | --- |
| Name | Nothing enters the architecture without a scenario or a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the feature files describe one consumer of a notification |
| When | "/aa-ta-architect" designs the notification boundary |
| Then | no extension point for further consumers is added |
| And | every component, boundary, and extension point names the scenario or decision record behind it |

## F-073-03 Each technology choice has a decision record

| Scenario | F-073-03 |
| --- | --- |
| Name | Each technology choice has a decision record |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-architect" writes the technology stack document |
| Then | every technology choice cites a decision record |
| And | each record is numbered next in the repository sequence, dated, and lists the options rejected |
| And | the constraints imposed on Development and Operations are stated explicitly |

## F-073-04 A changed choice supersedes rather than edits

| Scenario | F-073-04 |
| --- | --- |
| Name | A changed choice supersedes rather than edits |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an accepted decision record chose a storage approach |
| When | "/aa-ta-architect" reaches a different conclusion |
| Then | a new decision record is written that supersedes the old one and links back to it |
| And | the old record is not edited |

## F-073-05 An unknown is time-boxed, not designed around

| Scenario | F-073-05 |
| --- | --- |
| Name | An unknown is time-boxed, not designed around |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a scenario depends on behaviour nobody can confirm |
| When | "/aa-ta-architect" meets it |
| Then | a time box is stated before investigating |
| And | an unknown that survives the box becomes a spike ticket and a labelled assumption on the epic |

## F-073-06 The architecture is staged and presented, never committed

| Scenario | F-073-06 |
| --- | --- |
| Name | The architecture is staged and presented, never committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-architect" finishes |
| Then | the architecture and its decision records are linked from the epic and the knowledge base page |
| And | the changed files are staged with a Conventional Commit message naming the epic |
| And | no commit is made unless the user asked for that commit |

# F-034 One person or fifteen, the same framework

| Feature | F-034 |
| --- | --- |
| Name | One person or fifteen, the same framework |
| Tags | @framework @agent @T-13 |
| File | one-person-or-fifteen |

A discipline is a kind of work, not a headcount. A solo developer and a fifteen-person team
run the same steps, produce the same artifacts, and follow the same guidance. They differ
only in who performs which discipline, and the framework never asks.

## F-034-01 A solo developer runs every discipline

| Scenario | F-034-01 |
| --- | --- |
| Name | A solo developer runs every discipline |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a project with one person and their agent |
| When | they work a ticket from discover through release |
| Then | every step they run is the same step a team would run |
| And | every artifact lands in the same place with the same name |
| And | no step asks them to hand anything to someone else |

## F-034-02 A team assigns disciplines to roles

| Scenario | F-034-02 |
| --- | --- |
| Name | A team assigns disciplines to roles |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a project with fifteen people in distinct roles |
| When | the team maps disciplines to people in the knowledge base |
| Then | each person runs the steps of the disciplines they own |
| And | the artifacts, locations, and names are identical to the solo case |
| And | the framework does not record or require the mapping |

## F-034-03 Any step can be run by someone who has never seen the project

| Scenario | F-034-03 |
| --- | --- |
| Name | Any step can be run by someone who has never seen the project |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a step and its anchor ticket |
| When | a person or agent with no prior context runs the step |
| Then | the ticket, the feature files, and the knowledge base give them what they need |
| And | the step does not depend on memory of an earlier session |

## F-034-04 Health reports coverage, not headcount

| Scenario | F-034-04 |
| --- | --- |
| Name | Health reports coverage, not headcount |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-fw-health" reports on a project |
| Then | it reports which disciplines have steps, skills, and requirements in scope |
| And | it never reports how many people work on the project |
| And | it never marks a discipline unmet because no one is assigned to it |

## F-034-05 Guidance never assumes a large organisation

| Scenario | F-034-05 |
| --- | --- |
| Name | Guidance never assumes a large organisation |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a piece of core guidance |
| When | it is reviewed against this tenet |
| Then | it does not require a role that exists only in a large organisation |
| And | it does not require a hand-off between two people |
| And | anything that does is moved to a process pack |

## F-034-06 The website shows both paths

| Scenario | F-034-06 |
| --- | --- |
| Name | The website shows both paths |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | a visitor reads the framework's landing page |
| Then | they see the solo developer path and the team path side by side |
| And | both lead to the same install, the same steps, and the same artifacts |

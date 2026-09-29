# F-037 The knowledge base holds the requirements; feature files are pulled from it

| Feature | F-037 |
| --- | --- |
| Name | The knowledge base holds the requirements; feature files are pulled from it |
| Tags | @framework @agent @T-12 @T-14 @O-01 |
| File | requirements-are-gherkin |

Every project using the framework, and the framework itself, keeps its requirements as feature
pages in its knowledge base, in structured tables anyone can read and edit. The repository's
feature files are pulled from the pages per ticket, carry a provenance header, and are never
edited by hand. The ticket system stays the truth for work state; the pages are the truth for
what the software must do.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | the project has a features folder |

## F-037-01 A new requirement starts as a scenario

| Scenario | F-037-01 |
| --- | --- |
| Name | A new requirement starts as a scenario |
| Kind | Scenario |
| Tags | @R-16 |
| Status | Retired |

| Step | Text |
| --- | --- |
| When | a requirement is captured during discover or refine-requirements |
| Then | it is written as a scenario in a feature file in the features folder |
| And | it is not considered captured until the feature file contains it |

## F-037-02 Every scenario is linked to a ticket

| Scenario | F-037-02 |
| --- | --- |
| Name | Every scenario is linked to a ticket |
| Kind | Scenario |
| Tags | @R-02 |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | a scenario exists in a feature file |
| When | the tooling next runs a step that touches requirements |
| Then | the scenario carries a tag naming its anchor ticket |
| And | the ticket links back to the feature file and scenario |

## F-037-03 Every feature is linked to a knowledge base page

| Scenario | F-037-03 |
| --- | --- |
| Name | Every feature is linked to a knowledge base page |
| Kind | Scenario |
| Tags | @R-03 |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | a feature file exists |
| When | the tooling next runs a step that touches requirements |
| Then | the feature description names its knowledge base page |
| And | the page carries the feature's narrative and links back to the feature file |

## F-037-04 Changing a scenario propagates outward

| Scenario | F-037-04 |
| --- | --- |
| Name | Changing a scenario propagates outward |
| Kind | Scenario |
| Tags |  |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | a scenario, its ticket, and its knowledge base page are aligned |
| When | the scenario is changed in the feature file |
| Then | the tooling updates the ticket's acceptance criteria to match |
| And | the tooling updates the knowledge base page to match |
| And | the anchor ticket records that the requirement changed |

## F-037-05 A requirement changed outside the feature file is a conflict, not a change

| Scenario | F-037-05 |
| --- | --- |
| Name | A requirement changed outside the feature file is a conflict, not a change |
| Kind | Scenario |
| Tags |  |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | a scenario, its ticket, and its knowledge base page are aligned |
| When | the acceptance criteria are edited in the ticket alone |
| Then | the tooling reports a conflict between the ticket and the feature file |
| And | it does not silently rewrite either side |
| And | the user decides which is correct |

## F-037-06 Feature files are the business-facing tests

| Scenario | F-037-06 |
| --- | --- |
| Name | Feature files are the business-facing tests |
| Kind | Scenario |
| Tags | @R-11 @R-17 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a project with a tool that can execute feature files |
| When | generate-tests runs for a ticket |
| Then | the scenarios for that ticket are the business-facing test cases |
| And | no separate acceptance criteria document is produced |

## F-037-07 The framework dogfoods its own rule

| Scenario | F-037-07 |
| --- | --- |
| Name | The framework dogfoods its own rule |
| Kind | Scenario |
| Tags |  |
| Status | Retired |

| Step | Text |
| --- | --- |
| Given | the aa-sdlc repository |
| Then | its own requirements are feature files under features/ |
| And | the requirements registry document is an index derived from them |

## F-037-08 Features and scenarios carry stable ids

| Scenario | F-037-08 |
| --- | --- |
| Name | Features and scenarios carry stable ids |
| Kind | Scenario |
| Tags | @O-01 |
| Status | Retired |

| Step | Text |
| --- | --- |
| When | a feature or a scenario is written during discover or refine-requirements |
| Then | the feature carries an id tag unique in the repository |
| And | each scenario carries an id derived from its feature's id |
| And | an id is never renumbered or reused, even when a scenario is moved or deleted |

## F-037-09 Tests name the scenarios they prove

| Scenario | F-037-09 |
| --- | --- |
| Name | Tests name the scenarios they prove |
| Kind | Scenario |
| Tags | @O-01 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | a test is written during implement, generate-tests, or e2e-tests |
| Then | the test names the ids of the scenarios it proves, in the form its test framework supports |
| And | a scenario with no test naming its id is reported as not covered |

## F-037-10 A new requirement starts on a feature page

| Scenario | F-037-10 |
| --- | --- |
| Name | A new requirement starts on a feature page |
| Kind | Scenario |
| Tags | @R-03 @R-16 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | a requirement is captured during discover or refine-requirements |
| Then | it is written as a Draft scenario on a feature page under the project's Requirements section, in its topic |
| And | no feature file is written for it until the scenario is Approved and a ticket pulls it |

## F-037-11 Every Approved scenario is linked to a ticket

| Scenario | F-037-11 |
| --- | --- |
| Name | Every Approved scenario is linked to a ticket |
| Kind | Scenario |
| Tags | @R-02 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an Approved scenario on a feature page |
| Then | the scenario carries a tag naming the ticket that asked for it |
| And | the ticket links to the feature page and names the scenario id |

## F-037-12 Each ticket begins by pulling its features

| Scenario | F-037-12 |
| --- | --- |
| Name | Each ticket begins by pulling its features |
| Kind | Scenario |
| Tags | @R-27 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket that links to feature pages |
| When | any anchored step starts on the ticket |
| Then | it pulls the Approved scenarios of those pages into the features folder |
| And | each feature file names its page and the page version in its provenance header |
| And | the ticket records the page versions pulled |

## F-037-13 Only Approved scenarios reach the repository

| Scenario | F-037-13 |
| --- | --- |
| Name | Only Approved scenarios reach the repository |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a feature page with Draft, Approved, and Retired scenarios |
| When | the page is pulled |
| Then | the feature file holds the Approved scenarios only |
| And | a page with no Approved scenario generates no feature file |

## F-037-14 A requirement changes on its page, through a ticket

| Scenario | F-037-14 |
| --- | --- |
| Name | A requirement changes on its page, through a ticket |
| Kind | Scenario |
| Tags | @O-19 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an Approved scenario and the feature file pulled from it |
| When | the requirement must change |
| Then | the change is made on the feature page, under a ticket that records why |
| And | the next pull for that ticket brings the change into the repository |

## F-037-15 A feature file edited in the repository is caught at review

| Scenario | F-037-15 |
| --- | --- |
| Name | A feature file edited in the repository is caught at review |
| Kind | Scenario |
| Tags | @O-17 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a feature file that differs from what its page generates, or that no page generates |
| When | the change is checked before the commit or in the pipeline |
| Then | the check fails and names the file |
| And | it says to change the page and pull it instead |
| And | the check needs no access to the knowledge base, because the provenance header carries a checksum |

## F-037-16 A change found while building is proposed back to the page

| Scenario | F-037-16 |
| --- | --- |
| Name | A change found while building is proposed back to the page |
| Kind | Scenario |
| Tags | @O-13 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an implementer finds a scenario wrong or missing while building |
| When | they write the change they need |
| Then | it is converted to the page format and proposed on the feature page for its owner to approve |
| And | the repository gets the change only by pulling the page once it is Approved |

## F-037-17 Ids are assigned on the page

| Scenario | F-037-17 |
| --- | --- |
| Name | Ids are assigned on the page |
| Kind | Scenario |
| Tags | @O-01 @G-49 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | a feature or a scenario is added to a page with its id cell empty |
| Then | it is given the next free id, unique in the project for a feature and within its feature for a scenario |
| And | an id is never renumbered or reused, even when a scenario is moved or retired |

## F-037-18 With no knowledge base, the documents folder holds the pages

| Scenario | F-037-18 |
| --- | --- |
| Name | With no knowledge base, the documents folder holds the pages |
| Kind | Scenario |
| Tags | @R-03 @R-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a project with no knowledge base in scope |
| Then | its feature pages are markdown files under the documents folder's knowledge folder, in the same format |
| And | moving them into a knowledge base later is an upload, not a rewrite |

## F-037-19 Only the project's own pages are read

| Scenario | F-037-19 |
| --- | --- |
| Name | Only the project's own pages are read |
| Kind | Scenario |
| Tags | @T-14 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a knowledge base space shared with other projects |
| When | features are pulled, counted, or checked |
| Then | only pages under the project's own root are read |
| And | no other project's page is changed |

## F-037-20 The framework dogfoods its own rule

| Scenario | F-037-20 |
| --- | --- |
| Name | The framework dogfoods its own rule |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the aa-sdlc repository |
| Then | its own requirements are feature pages under docs/knowledge/Requirements |
| And | the feature files under features/ are generated from them and checked by the unit tier |

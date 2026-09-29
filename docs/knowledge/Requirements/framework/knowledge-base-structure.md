# F-084 The knowledge base has one structure

| Feature | F-084 |
| --- | --- |
| Name | The knowledge base has one structure |
| Tags | @framework @agent @O-27 @T-12 @T-14 |
| File | knowledge-base-structure |

Every project's knowledge base has six top-level sections under the project's own root:
Overview, Requirements, Architecture, Operations, Releases, and Guides. The feature pages under
Requirements are the source of truth for requirements, and the repository's feature files are
pulled from them; decision records stay in the repository and the other pages explain and
index. Superseded pages are marked and linked, never deleted.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" with a linked knowledge base |

## F-084-01 A requirement page lives under Requirements and names its feature

| Scenario | F-084-01 |
| --- | --- |
| Name | A requirement page lives under Requirements and names its feature |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ba-refine-requirements" writes the page for a feature |
| Then | the page is under the Requirements section of the project's own root |
| And | its title names the feature and its feature id |
| And | the feature file pulled from it names the page and its version in its provenance header |

## F-084-02 A decision is indexed, not copied

| Scenario | F-084-02 |
| --- | --- |
| Name | A decision is indexed, not copied |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-ta-decide" records a decision |
| Then | the decision record is written in the repository |
| And | the Architecture section's index of decision records links to it |

## F-084-03 A superseded page is kept and linked

| Scenario | F-084-03 |
| --- | --- |
| Name | A superseded page is kept and linked |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a Guides page that a change has made wrong |
| When | "/aa-doc-maintain-docs" replaces it with a new page |
| Then | the old page is marked superseded and links to the new one |
| And | the old page is not deleted |

## F-084-04 A missing section is offered, not assumed

| Scenario | F-084-04 |
| --- | --- |
| Name | A missing section is offered, not assumed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the knowledge base has no Releases section |
| When | "/aa-fw-init" runs |
| Then | it offers to create the Releases section, and creates it only with the user's consent |

## F-084-05 In a shared space, the sections are under the project's own root

| Scenario | F-084-05 |
| --- | --- |
| Name | In a shared space, the sections are under the project's own root |
| Kind | Scenario |
| Tags | @T-14 @G-55 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a knowledge base space shared with other projects |
| When | "/aa-fw-init" creates the sections with the user's consent |
| Then | they are created under the project's own root page |
| And | no other project's page and nothing in the space's structure is changed |

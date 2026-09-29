# F-084 The knowledge base has one structure

| Feature | F-084 |
| --- | --- |
| Name | The knowledge base has one structure |
| Tags | @framework @agent @O-27 @T-12 |
| File | knowledge-base-structure |

Every project's knowledge base space has six top-level sections: Overview, Requirements,
Architecture, Operations, Releases, and Guides. Pages explain and index; feature files and
decision records stay the source of truth. Superseded pages are marked and linked, never deleted.

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
| Then | the page is under the Requirements section |
| And | its title names the feature and its feature id |
| And | it links to the feature file, which names the page |

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

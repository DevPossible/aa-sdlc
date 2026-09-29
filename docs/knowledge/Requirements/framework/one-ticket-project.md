# F-035 One repository, one ticket project

| Feature | F-035 |
| --- | --- |
| Name | One repository, one ticket project |
| Tags | @framework @agent @O-09 @O-03 |
| File | one-ticket-project |

Every repository maps to exactly one ticket system project. Many repositories may share it;
none manages tickets across two. The mapping lives in the project config and every anchored
step works within it.

## Background

| Step | Text |
| --- | --- |
| Given | a repository initialised with "aa init" |
| And | its project config names one ticket project |

## F-035-01 Every step anchors within the configured project

| Scenario | F-035-01 |
| --- | --- |
| Name | Every step anchors within the configured project |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | any anchored step is run with a ticket id |
| Then | the id is resolved within the configured project without a qualifier |
| And | the step refuses an id from another project and explains why |

## F-035-02 Two repositories share a project

| Scenario | F-035-02 |
| --- | --- |
| Name | Two repositories share a project |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a second repository whose config names the same ticket project |
| When | work in both repositories anchors on the same ticket |
| Then | both record their branches and merge requests against that one ticket |
| And | neither repository's config changes |

## F-035-03 Cross-project work is linked, not shared

| Scenario | F-035-03 |
| --- | --- |
| Name | Cross-project work is linked, not shared |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | work in this repository depends on a ticket in a different project |
| When | a step needs to reference it |
| Then | a ticket exists in this repository's project that links to the other |
| And | the step anchors on the local ticket |

## F-035-04 Health reports a repository drifting across projects

| Scenario | F-035-04 |
| --- | --- |
| Name | Health reports a repository drifting across projects |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | branches or commits reference tickets from two projects |
| When | "/aa-fw-health" runs |
| Then | R-22 is reported as unmet with the foreign references listed |

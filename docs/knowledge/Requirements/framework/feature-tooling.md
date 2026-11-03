# F-093 Feature tooling preserves reviewed requirements

| Feature | F-093 |
| --- | --- |
| Name | Feature tooling preserves reviewed requirements |
| Tags | @agent @T-12 |
| File | feature-tooling |

The ten behavior changes approved in the eleven-item backport on 2026-11-02.
Executable regression coverage and the local approval anchor are in docs/feature-tooling-backport.md.

## F-093-01 MCP exports preserve every scenario

| Scenario | F-093-01 |
| --- | --- |
| Name | MCP exports preserve every scenario |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a feature page exported with Setext headings or empty table headers |
| When | the page is converted |
| Then | the Approved output equals the canonical Markdown output including identities steps and examples |

## F-093-02 Malformed requirement tables cannot disappear

| Scenario | F-093-02 |
| --- | --- |
| Name | Malformed requirement tables cannot disappear |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a page with malformed duplicate foreign or unconsumed requirement tables |
| When | the page is converted including a selected subset |
| Then | conversion fails before generating acceptance output |

## F-093-03 Invalid synchronization sources preserve the batch

| Scenario | F-093-03 |
| --- | --- |
| Name | Invalid synchronization sources preserve the batch |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | existing generated features and a missing Requirements folder invalid page duplicate destination or unsafe filename |
| When | feature synchronization is requested |
| Then | it fails before changing any generated file |

## F-093-04 Public tooling modules have versioned manifests

| Scenario | F-093-04 |
| --- | --- |
| Name | Public tooling modules have versioned manifests |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the installed feature converter and snapshot importer |
| When | their manifests are inspected and imported |
| Then | each declares its version PowerShell requirement and explicit public exports |

## F-093-05 Snapshot import uses the configured knowledge identity

| Scenario | F-093-05 |
| --- | --- |
| Name | Snapshot import uses the configured knowledge identity |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an offline storage snapshot and the project's configured knowledge space and URL |
| When | the snapshot is imported |
| Then | only Approved scenarios generate with the exact page and version provenance |
| And | invalid metadata wrong spaces and unsupported content are rejected |

## F-093-06 Named entities preserve one reference layer

| Scenario | F-093-06 |
| --- | --- |
| Name | Named entities preserve one reference layer |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a storage snapshot containing named numeric and escaped entity references |
| When | it is imported |
| Then | recognized references retain their exact text without becoming markup |
| And | unknown references DTDs and external entities are rejected |

## F-093-07 Simple preamble lists preserve meaning

| Scenario | F-093-07 |
| --- | --- |
| Name | Simple preamble lists preserve meaning |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a storage snapshot containing a simple ordered or unordered preamble list |
| When | it is imported |
| Then | item order text and links survive |
| And | unsupported nesting attributes casing and scenario lists are rejected |

## F-093-08 Snapshot command preserves destination identity

| Scenario | F-093-08 |
| --- | --- |
| Name | Snapshot command preserves destination identity |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an offline snapshot and an existing generated feature |
| When | the snapshot command generates or checks its output |
| Then | source changes downgrades same-version conflicts and hand edits are rejected without replacing existing bytes |
| And | lost approvals never silently delete the destination |

## F-093-09 Exact Approved scenario selection preserves source order

| Scenario | F-093-09 |
| --- | --- |
| Name | Exact Approved scenario selection preserves source order |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a fully validated feature page and an explicit list of Approved scenario IDs |
| When | a component projection is generated |
| Then | only those scenarios generate in source order with their IDs recorded |
| And | empty duplicate unknown case-mismatched Draft or Retired selections are rejected |

## F-093-10 Selected output binds the full source

| Scenario | F-093-10 |
| --- | --- |
| Name | Selected output binds the full source |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a selected projection bound to its full source Markdown checksum |
| When | the source selection version or projection metadata changes |
| Then | the import command rejects same-version conflicts malformed metadata and silent membership changes |
| And | a newer valid source updates the full-source checksum even when selected steps stay unchanged |

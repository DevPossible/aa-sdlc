# F-024 Dependencies change through the package manager, never by hand

| Feature | F-024 |
| --- | --- |
| Name | Dependencies change through the package manager, never by hand |
| Tags | @framework @agent @O-22 @O-16 @T-07 |
| File | dependencies-via-tooling |

A dependency is added, updated, or removed only through the ecosystem's package manager, so
conflicts are resolved, warnings surfaced, transitive dependencies re-resolved, and the lock
file regenerated in one operation. A version in a manifest or lock file is never edited by
hand. A tool refusal is a finding on the ticket, never something to bypass.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | an ecosystem with a package manager and a committed lock file |

## F-024-01 A dependency is updated with the tool

| Scenario | F-024-01 |
| --- | --- |
| Name | A dependency is updated with the tool |
| Kind | Scenario |
| Tags | @G-45 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket to update a dependency to a newer version |
| When | "/aa-dev-implement" makes the change |
| Then | the package manager's update command is run with the version requested |
| And | the manifest and the lock file both change |
| And | the transitive dependencies are re-resolved by the tool |
| And | the two files are staged together as their own commit |

## F-024-02 An agent does not edit the version number

| Scenario | F-024-02 |
| --- | --- |
| Name | An agent does not edit the version number |
| Kind | Scenario |
| Tags | @G-45 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the agent could satisfy the ticket by changing one number in the manifest |
| When | "/aa-dev-implement" considers how to make the change |
| Then | it does not edit the manifest or the lock file |
| And | it runs the package manager instead |

## F-024-03 A tool refusal becomes a finding, not a workaround

| Scenario | F-024-03 |
| --- | --- |
| Name | A tool refusal becomes a finding, not a workaround |
| Kind | Scenario |
| Tags | @G-45 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the package manager refuses the update because of a conflict with another dependency |
| When | "/aa-dev-implement" receives the refusal |
| Then | the refusal and its output are recorded on the ticket |
| And | the conflict is resolved through the tool or the ticket is handed back with the question |
| And | no file is edited to make the refusal go away |

## F-024-04 A security patch follows the same rule

| Scenario | F-024-04 |
| --- | --- |
| Name | A security patch follows the same rule |
| Kind | Scenario |
| Tags | @G-45 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | "/aa-sec-maintain-security" finds a vulnerable dependency |
| When | it patches the dependency |
| Then | the package manager performs the update |
| And | the warnings it emits are recorded on the patch ticket |
| And | the manifest and lock file changes are staged together |

## F-024-05 Review catches a manifest changed without its lock file

| Scenario | F-024-05 |
| --- | --- |
| Name | Review catches a manifest changed without its lock file |
| Kind | Scenario |
| Tags | @G-45 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merge request that changes a manifest version and not the lock file |
| When | "/aa-dev-review" reviews it |
| Then | a blocking finding says the manifest was edited by hand |
| And | the finding asks for the change to be redone with the package manager |

## F-024-06 The lock file is always committed

| Scenario | F-024-06 |
| --- | --- |
| Name | The lock file is always committed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the package manager has regenerated the lock file |
| When | the change is staged |
| Then | the lock file is part of the staged change |
| And | it is never ignored or deleted to resolve a conflict |

## F-024-07 Health reports a manifest that disagrees with its lock file

| Scenario | F-024-07 |
| --- | --- |
| Name | Health reports a manifest that disagrees with its lock file |
| Kind | Scenario |
| Tags | @R-36 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a manifest names a version the lock file does not resolve to |
| When | "/aa-fw-health" runs |
| Then | R-36 is reported as unmet |
| And | the remedy is to run the package manager, never to edit the lock file |

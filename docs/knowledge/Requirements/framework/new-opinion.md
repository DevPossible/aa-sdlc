# F-030 /aa-internal-new-opinion adds an opinion with all of its plumbing

| Feature | F-030 |
| --- | --- |
| Name | /aa-internal-new-opinion adds an opinion with all of its plumbing |
| Tags | @framework @agent @fw |
| File | new-opinion |

An opinion is only real when the framework depends on it. The command adds the entry and
everything the entry implies, in one change, in the aa-sdlc repository.

## Background

| Step | Text |
| --- | --- |
| Given | I am in the aa-sdlc repository |

## F-030-01 Add a well-formed opinion

| Scenario | F-030-01 |
| --- | --- |
| Name | Add a well-formed opinion |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-internal-new-opinion" with a stance, its reasoning, and the alternatives it rejects |
| Then | docs/opinions.md gains an entry with the next O-nn id |
| And | the entry has stance, why, rejected, would-change-our-mind, and requirements |
| And | the README's opinions list and the design's opinions sentence include it |

## F-030-02 Implied requirements and guidance are created

| Scenario | F-030-02 |
| --- | --- |
| Name | Implied requirements and guidance are created |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stance assumes a capability the framework did not previously require |
| When | I run "/aa-internal-new-opinion" |
| Then | a requirement with met and unmet scenarios exists for the capability |
| And | any practice the stance demands is guidance attached to the steps it applies to |

## F-030-03 A stance that names a tool is refused

| Scenario | F-030-03 |
| --- | --- |
| Name | A stance that names a tool is refused |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stance names a product or language |
| When | I run "/aa-internal-new-opinion" |
| Then | it reports the tenet T-01 violation |
| And | it does not write the entry until the stance is rewritten |

## F-030-04 Ids are never reused

| Scenario | F-030-04 |
| --- | --- |
| Name | Ids are never reused |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an earlier opinion was withdrawn |
| When | I run "/aa-internal-new-opinion" |
| Then | the new opinion takes the next unused id, not the withdrawn one |

## F-030-05 The change is verified before it is reported

| Scenario | F-030-05 |
| --- | --- |
| Name | The change is verified before it is reported |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-internal-new-opinion" finishes |
| Then | the unit test tier has been run and passes |
| And | docs/discipline-review.md has been regenerated |
| And | the decision log records the opinion |
| And | the report lists every file changed |

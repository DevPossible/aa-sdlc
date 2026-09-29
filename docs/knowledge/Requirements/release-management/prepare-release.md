# F-060 /aa-rel-prepare-release assembles everything needed to say ready or not yet

| Feature | F-060 |
| --- | --- |
| Name | /aa-rel-prepare-release assembles everything needed to say ready or not yet |
| Tags | @agent @release-management @O-14 @O-19 @O-24 |
| File | prepare-release |

The version is derived from the commit types since the last tag, every commit traces to a
ticket, the release names the artifact identity that was tested, the notes are generated from
the record and edited for the reader, and every go/no-go item links its evidence.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | merged changes since the last release tag, each with a ticket, and test results for every tier |

## F-060-01 The version is derived from the history

| Scenario | F-060-01 |
| --- | --- |
| Name | The version is derived from the history |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" runs |
| Then | the version bump is computed from the commit types since the last tag by the project's scheme |
| And | the commits that drove the bump are listed |

## F-060-02 An unexplained commit is a finding, not something to work around

| Scenario | F-060-02 |
| --- | --- |
| Name | An unexplained commit is a finding, not something to work around |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit since the last tag names no ticket or does not parse as a Conventional Commit |
| When | "/aa-rel-prepare-release" traces the history |
| Then | the commit is recorded as a finding on the release ticket |
| And | the release is reported as not ready until it has a ticket or a recorded reason |

## F-060-03 The release names the artifact that was tested

| Scenario | F-060-03 |
| --- | --- |
| Name | The release names the artifact that was tested |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" identifies the artifact |
| Then | the release names the immutable identity the pipeline produced for the release commit |
| And | that identity is the one that ran every test tier, the security tests, and UAT |
| And | a rebuilt or unidentified artifact makes the release not ready |

## F-060-04 The notes come from the record and read for the audience

| Scenario | F-060-04 |
| --- | --- |
| Name | The notes come from the record and read for the audience |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" writes the release notes |
| Then | commits are grouped by type and ticket |
| And | every included ticket appears and nothing appears that is not included |
| And | the notes are edited for the audience the project names |

## F-060-05 Every checklist item links its evidence

| Scenario | F-060-05 |
| --- | --- |
| Name | Every checklist item links its evidence |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" runs the go/no-go checklist |
| Then | each item links the test run, the approval, or the scan that satisfies it, or says why it does not apply |
| And | the decision and who made it are recorded on the release ticket |

## F-060-06 The release is recorded in the ticket system and the knowledge base

| Scenario | F-060-06 |
| --- | --- |
| Name | The release is recorded in the ticket system and the knowledge base |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" records the release |
| Then | the release in the ticket system and the knowledge base entry name the version, the artifact identity, and the notes |
| And | each links to the release ticket and the ticket links back |

## F-060-07 The tag and the notes wait for the user

| Scenario | F-060-07 |
| --- | --- |
| Name | The tag and the notes wait for the user |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-rel-prepare-release" finishes |
| Then | the notes file is staged with a Conventional Commit message and not committed unless the user asked |
| And | the tag name and the commit it will point at are stated |
| And | the tag is created or pushed only when the user asks |

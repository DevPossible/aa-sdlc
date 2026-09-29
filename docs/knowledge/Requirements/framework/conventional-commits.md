# F-021 Commit messages are Conventional Commits

| Feature | F-021 |
| --- | --- |
| Name | Commit messages are Conventional Commits |
| Tags | @framework @agent @O-14 @O-02 @T-07 |
| File | conventional-commits |

Every commit in a source code repository has a type from the project's list, an optional
scope, an imperative subject, a body that says why, and a footer with the ticket reference
and any breaking change. The history becomes data: release notes and the version bump are
derived from it.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | the project config names the commit pattern and the allowed types |

## F-021-01 A commit made by a step conforms

| Scenario | F-021-01 |
| --- | --- |
| Name | A commit made by a step conforms |
| Kind | Scenario |
| Tags | @G-33 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket being implemented on a branch |
| When | "/aa-dev-implement" commits a change |
| Then | the subject starts with a type from the configured list |
| And | the subject is imperative and has no trailing period |
| And | the footer references the anchor ticket |
| And | the body says why the change was made |

## F-021-02 A change that cannot name one type is split

| Scenario | F-021-02 |
| --- | --- |
| Name | A change that cannot name one type is split |
| Kind | Scenario |
| Tags | @G-33 @G-39 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a working tree that contains a fix and an unrelated refactor |
| When | "/aa-dev-implement" commits |
| Then | two commits are made, one typed fix and one typed refactor |
| And | neither message describes the other's change |

## F-021-03 A breaking change is declared where it happens

| Scenario | F-021-03 |
| --- | --- |
| Name | A breaking change is declared where it happens |
| Kind | Scenario |
| Tags | @G-33 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a change that removes a public behaviour a consumer relies on |
| When | "/aa-dev-implement" commits it |
| Then | the subject carries the breaking marker |
| And | the footer has a breaking-change entry that says what breaks and what to do |

## F-021-04 Review flags a message that does not conform

| Scenario | F-021-04 |
| --- | --- |
| Name | Review flags a message that does not conform |
| Kind | Scenario |
| Tags | @G-33 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merge request with a commit whose message has no type |
| When | "/aa-dev-review" reviews it |
| Then | a non-blocking finding names the commit and the configured pattern |
| And | the review says the release notes will not pick the change up as written |

## F-021-05 The release is derived from the history

| Scenario | F-021-05 |
| --- | --- |
| Name | The release is derived from the history |
| Kind | Scenario |
| Tags | @G-34 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | commits since the last release tag typed feat, fix, and one with a breaking marker |
| When | "/aa-rel-prepare-release" runs |
| Then | the proposed version bump is major because of the breaking change |
| And | the release notes group the commits by type and ticket |
| And | the notes are then edited for the reader, not left as raw subjects |

## F-021-06 A commit that does not parse is a finding, not a workaround

| Scenario | F-021-06 |
| --- | --- |
| Name | A commit that does not parse is a finding, not a workaround |
| Kind | Scenario |
| Tags | @G-34 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a commit since the last release tag that does not match the configured pattern |
| When | "/aa-rel-prepare-release" runs |
| Then | the commit is listed as a finding on the release ticket |
| And | the release is not marked ready until the finding is resolved or accepted with a reason |

## F-021-07 Enforced locally where the target allows

| Scenario | F-021-07 |
| --- | --- |
| Name | Enforced locally where the target allows |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the target supports hooks |
| When | "aa setup" installs the framework |
| Then | a commit-message hook checks each message against the configured pattern before the commit is made |
| And | a failure is reported to the user with the pattern, never bypassed |

## F-021-08 Health reports a history the tooling cannot read

| Scenario | F-021-08 |
| --- | --- |
| Name | Health reports a history the tooling cannot read |
| Kind | Scenario |
| Tags | @R-28 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | recent commits on the default branch do not match the configured pattern |
| When | "/aa-fw-health" runs |
| Then | R-28 is reported as unmet with the commits listed |

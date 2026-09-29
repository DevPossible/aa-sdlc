# F-015 /aa-dev-setup-environment makes a fresh clone buildable and testable

| Feature | F-015 |
| --- | --- |
| Name | /aa-dev-setup-environment makes a fresh clone buildable and testable |
| Tags | @agent @development @O-05 @O-06 @O-07 @O-11 @O-12 @O-16 @O-21 @O-25 |
| File | setup-environment |

Fill in the root scripts, configure the tools the stack needs, split the configuration, define
the end-to-end environment, and record anything a new developer must do by hand. Proven on a
clean clone.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | a technology stack document and the stub root scripts |

## F-015-01 The root scripts are filled in and proven on a clean clone

| Scenario | F-015-01 |
| --- | --- |
| Name | The root scripts are filled in and proven on a clean clone |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-setup-environment" runs |
| Then | initialize, build, test, and pack each run to completion on a fresh clone |
| And | build accepts a lint switch and test accepts a tier |
| And | the output of the clean-clone run is quoted |

## F-015-02 Existing equivalents are mapped, not duplicated

| Scenario | F-015-02 |
| --- | --- |
| Name | Existing equivalents are mapped, not duplicated |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the repository already keeps its documents in a folder with another name |
| When | "/aa-dev-setup-environment" runs |
| Then | the project config maps that folder as the documents folder |
| And | no second documents folder is created |

## F-015-03 Tools are configured, never chosen for the project

| Scenario | F-015-03 |
| --- | --- |
| Name | Tools are configured, never chosen for the project |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a language in the stack has no formatter configured |
| When | "/aa-dev-setup-environment" reaches it |
| Then | it lists what is available in the project's scope or as a plugin |
| And | the user chooses |
| And | a language with no known static analyser is recorded in the development environment configuration |

## F-015-04 The conventions start from a published baseline

| Scenario | F-015-04 |
| --- | --- |
| Name | The conventions start from a published baseline |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a language in the stack has no static analyser rule set |
| When | "/aa-dev-setup-environment" reaches it |
| Then | it offers a published best-practice rule set matching the language, the framework version, and the kind of application |
| And | it offers a short list of other widely used rule sets with what distinguishes each |
| And | it offers to build a rule set from scratch by asking the user's preferences |
| And | the user chooses |

## F-015-05 The chosen rule set is tailored and recorded

| Scenario | F-015-05 |
| --- | --- |
| Name | The chosen rule set is tailored and recorded |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user has chosen a baseline rule set |
| When | "/aa-dev-setup-environment" configures it |
| Then | the rule set is committed to the repository and the analyser runs from the root build's lint switch |
| And | each rule the user changes from the baseline is changed in the rule set file, not suppressed in code |
| And | a decision record names the baseline, its version, and every departure with the reason |

## F-015-06 An existing codebase adopts a rule set without a big-bang change

| Scenario | F-015-06 |
| --- | --- |
| Name | An existing codebase adopts a rule set without a big-bang change |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the chosen rule set reports findings in code the change did not touch |
| When | "/aa-dev-setup-environment" configures it |
| Then | the existing findings are recorded as a baseline the analyser accepts, or raised as tickets |
| And | new and changed code is held to the full rule set |

## F-015-07 Configuration is split by what varies

| Scenario | F-015-07 |
| --- | --- |
| Name | Configuration is split by what varies |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-setup-environment" writes the configuration |
| Then | one environment template per environment holds the settings that differ, with placeholders for secrets |
| And | the application configuration holds the functional settings once |
| And | the development environment configuration says where each secret comes from |

## F-015-08 The end-to-end environment is code

| Scenario | F-015-08 |
| --- | --- |
| Name | The end-to-end environment is code |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stack can run in containers |
| When | "/aa-dev-setup-environment" runs |
| Then | container definitions for the system and its dependencies are committed |
| And | test with the e2e tier starts them |

## F-015-09 A manual step is a bug until proven otherwise

| Scenario | F-015-09 |
| --- | --- |
| Name | A manual step is a bug until proven otherwise |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a setup step could not be automated |
| When | "/aa-dev-setup-environment" documents it |
| Then | the development environment configuration records the step and the reason it is manual |

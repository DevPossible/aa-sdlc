# F-009 aa update brings the install up to the package version

| Feature | F-009 |
| --- | --- |
| Name | aa update brings the install up to the package version |
| Tags | @cli |
| File | update |

Everything setup and init installed is updated together, so the CLI and the skills it
installed never drift apart.

## Background

| Step | Text |
| --- | --- |
| Given | "aa setup" has been run on this machine |

## F-009-01 Update user scope

| Scenario | F-009-01 |
| --- | --- |
| Name | Update user scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a newer aa-sdlc package is installed globally |
| When | I run "aa update" |
| Then | the skills and commands at user scope match the package version |
| And | the user config records the new version |

## F-009-02 Update project scope from inside a repository

| Scenario | F-009-02 |
| --- | --- |
| Name | Update project scope from inside a repository |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I am in a repository initialised with "aa init" |
| When | I run "aa update" |
| Then | the project-scope skills and commands match the package version |
| And | project config, documents, and feature files are left as they are |

## F-009-03 Report what changed

| Scenario | F-009-03 |
| --- | --- |
| Name | Report what changed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "aa update" completes |
| Then | it names each root folder it installs into at each scope, such as USER .claude, with its number of files |
| And | it counts the files added, changed, and removed in each, without listing them one by one |

## F-009-04 Update the plugins installed at each scope

| Scenario | F-009-04 |
| --- | --- |
| Name | Update the plugins installed at each scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin is installed at a scope |
| When | I run "aa update" |
| Then | the plugin is reinstalled from the source the config records for it |
| And | the plugin's files are not reported as stale core files |

## F-009-05 A repository keeps its own harnesses

| Scenario | F-009-05 |
| --- | --- |
| Name | A repository keeps its own harnesses |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config names no targets |
| And | "aa setup" installed into more harnesses on this machine than the repository has folders for |
| When | I run "aa update" inside the repository |
| Then | project scope is refreshed only for the harnesses the repository already has folders for |

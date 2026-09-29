# F-008 aa setup bootstraps the machine

| Feature | F-008 |
| --- | --- |
| Name | aa setup bootstraps the machine |
| Tags | @cli @T-11 |
| File | setup |

The main CLI verb. Run once per machine after installing the package globally. It prepares
every agent target on the machine so that any repository can then be initialised with aa init.

## Background

| Step | Text |
| --- | --- |
| Given | the aa-sdlc package is installed globally |

## F-008-01 Detect installed agent targets

| Scenario | F-008-01 |
| --- | --- |
| Name | Detect installed agent targets |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa setup" |
| Then | it lists every supported agent target found on the machine |
| And | it installs the skills and commands for each at user scope |

## F-008-02 Write the user config

| Scenario | F-008-02 |
| --- | --- |
| Name | Write the user config |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa setup" |
| Then | a user-scope config exists |
| And | it records the targets installed and the package version |

## F-008-03 Connect to an organisation config repository

| Scenario | F-008-03 |
| --- | --- |
| Name | Connect to an organisation config repository |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa setup" with an organisation config repository |
| Then | the enterprise and team plugins and settings from that repository are layered over core |
| And | the user config records the repository |

## F-008-04 Re-running is safe

| Scenario | F-008-04 |
| --- | --- |
| Name | Re-running is safe |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | "aa setup" has already been run |
| When | I run "aa setup" again |
| Then | nothing is duplicated |
| And | any newly installed agent targets are picked up |

## F-008-05 No supported target found

| Scenario | F-008-05 |
| --- | --- |
| Name | No supported target found |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no supported agent target is installed |
| When | I run "aa setup" |
| Then | it names the targets it supports |
| And | it still writes the user config |

## F-008-06 Tell the user what to do next

| Scenario | F-008-06 |
| --- | --- |
| Name | Tell the user what to do next |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "aa setup" completes |
| Then | it tells the user to run "aa init" in a repository |

## F-008-07 The guidance sets are installed once beside the skills

| Scenario | F-008-07 |
| --- | --- |
| Name | The guidance sets are installed once beside the skills |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa setup" |
| Then | the shared guidance sets are installed at user scope with no command |
| And | every installed skill at user scope points at the guidance sets by their user-scope path |

## F-008-08 Install into every harness found

| Scenario | F-008-08 |
| --- | --- |
| Name | Install into every harness found |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code, Codex, and Gemini CLI are installed on this machine |
| When | I run "aa setup" |
| Then | it lists all three as installed at user scope |
| And | the skills are written once to the Claude Code skills folder and once to the shared agents skills folder |
| And | Gemini CLI gets its commands in its own command format |
| And | the user config records all three targets |

## F-008-09 Choose the harnesses explicitly

| Scenario | F-008-09 |
| --- | --- |
| Name | Choose the harnesses explicitly |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed on this machine |
| When | I run "aa setup -targets codex" |
| Then | only Codex is installed |
| And | the user config records only codex |

## F-008-10 Pick from a checklist

| Scenario | F-008-10 |
| --- | --- |
| Name | Pick from a checklist |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed on this machine |
| When | I run "aa setup" interactively and untick Claude Code |
| Then | only Codex is installed |

## F-008-11 A harness that would see a skill twice is named

| Scenario | F-008-11 |
| --- | --- |
| Name | A harness that would see a skill twice is named |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed on this machine |
| And | Cursor is installed on this machine |
| When | I run "aa setup" |
| Then | it names Cursor as reading the skills from more than one folder |

## F-008-12 A harness that cannot load skills is named, not installed into

| Scenario | F-008-12 |
| --- | --- |
| Name | A harness that cannot load skills is named, not installed into |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Aider is installed on this machine |
| When | I run "aa setup" |
| Then | it says Aider has no skills support and installs nothing for it |

## F-008-13 Discipline subagents are installed where the harness takes them

| Scenario | F-008-13 |
| --- | --- |
| Name | Discipline subagents are installed where the harness takes them |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed on this machine |
| When | I run "aa setup" |
| Then | Claude Code gets one subagent per delivery discipline |
| And | nothing is written for Codex's subagents |

## F-008-14 Check the framework's own prerequisites

| Scenario | F-008-14 |
| --- | --- |
| Name | Check the framework's own prerequisites |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa setup" |
| Then | it checks this machine has a source control client and PowerShell 7 or newer |
| And | it reports each as found with its version, too old, or missing |

## F-008-15 Install a missing prerequisite with consent

| Scenario | F-008-15 |
| --- | --- |
| Name | Install a missing prerequisite with consent |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | PowerShell 7 is not installed on this machine |
| When | I run "aa setup" interactively and agree to install it |
| Then | it installs PowerShell with the platform's package manager and checks it again |
| And | where the platform has no package manager it knows, it says where to get it instead |

## F-008-16 Each skill is named for the command that runs it

| Scenario | F-008-16 |
| --- | --- |
| Name | Each skill is named for the command that runs it |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code is installed on this machine |
| When | I run "aa setup" |
| Then | every installed skill's name is its command, such as aa-fw-health |
| And | Claude Code gets no command files, because it runs a skill by its name |

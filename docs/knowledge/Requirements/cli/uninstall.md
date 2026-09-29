# F-083 aa uninstall removes the framework from the harnesses the user picks

| Feature | F-083 |
| --- | --- |
| Name | aa uninstall removes the framework from the harnesses the user picks |
| Tags | @cli @T-03 |
| File | uninstall |

The reverse of aa setup and aa init. It removes only what the framework installed: the aa-
skills, the shared guidance sets, the aa- commands, and the AA-SDLC block in an instruction
file. Anything else in those folders and files is the user's and is left alone. Harnesses that
are not picked keep working, even where they shared a folder with one that was removed.

## Background

| Step | Text |
| --- | --- |
| Given | "aa setup" has been run on this machine |

## F-083-01 Remove the framework from one harness

| Scenario | F-083-01 |
| --- | --- |
| Name | Remove the framework from one harness |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed and set up |
| When | I run "aa uninstall -targets codex" |
| Then | the shared agents skills folder no longer holds any aa- skill |
| And | Claude Code still has every skill and command |
| And | the user config records only claude-code |

## F-083-02 A harness that shared a folder keeps its skills

| Scenario | F-083-02 |
| --- | --- |
| Name | A harness that shared a folder keeps its skills |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Cursor are installed and set up |
| When | I run "aa uninstall -targets claude-code" |
| Then | Cursor's skills are reinstalled in a folder it reads |
| And | the Claude Code skills and commands are gone |

## F-083-03 Remove the framework from every harness

| Scenario | F-083-03 |
| --- | --- |
| Name | Remove the framework from every harness |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed and set up |
| When | I run "aa uninstall -all" |
| Then | no aa- skill, guidance set, or command remains in any harness folder at user scope |
| And | the user config records no targets |

## F-083-04 Only the framework's files are removed

| Scenario | F-083-04 |
| --- | --- |
| Name | Only the framework's files are removed |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a skill of the user's own sits beside the aa- skills |
| When | I run "aa uninstall -all" |
| Then | the user's own skill is still there |

## F-083-05 Pick from a checklist

| Scenario | F-083-05 |
| --- | --- |
| Name | Pick from a checklist |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | Claude Code and Codex are installed and set up |
| When | I run "aa uninstall" interactively and tick Codex |
| Then | only Codex's framework files are removed |

## F-083-06 Nothing is removed without a choice

| Scenario | F-083-06 |
| --- | --- |
| Name | Nothing is removed without a choice |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa uninstall" with no targets named, no -all, and no terminal |
| Then | it removes nothing |
| And | it says to name the harnesses with -targets or use -all |

## F-083-07 Remove the framework from a repository

| Scenario | F-083-07 |
| --- | --- |
| Name | Remove the framework from a repository |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I am in a repository initialised with "aa init" |
| When | I run "aa uninstall -all -scope project" |
| Then | no aa- skill or command remains in the repository |
| And | the AA-SDLC block is gone from its instruction files |
| And | the rest of each instruction file is left as it was |

# F-007 aa plugin manages plugins at a scope

| Feature | F-007 |
| --- | --- |
| Name | aa plugin manages plugins at a scope |
| Tags | @cli @T-02 |
| File | plugin |

Plugins supply the specifics the core deliberately leaves out: tech-stack packs, tool packs,
and process packs. They add skills, steps, guidance, and requirements without changing core,
and every skill in a plugin attaches to the life cycle: it names the core step or process it
serves, or the core requirement it satisfies. A skill that attaches to nothing is an ordinary
agent skill, not a plugin.

## Background

| Step | Text |
| --- | --- |
| Given | "aa setup" has been run on this machine |

## F-007-01 Install a plugin at project scope

| Scenario | F-007-01 |
| --- | --- |
| Name | Install a plugin at project scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I am in a repository initialised with "aa init" |
| When | I run "aa plugin install <plugin>" |
| Then | the plugin's skills and commands are installed at project scope |
| And | the project config records the plugin with its version and source |

## F-007-02 Install a plugin at user scope

| Scenario | F-007-02 |
| --- | --- |
| Name | Install a plugin at user scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa plugin install <plugin> --scope user" |
| Then | the plugin's skills and commands are installed at user scope |
| And | the user config records the plugin |

## F-007-03 add is another name for install

| Scenario | F-007-03 |
| --- | --- |
| Name | add is another name for install |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I am in a repository initialised with "aa init" |
| When | I run "aa plugin add <plugin>" |
| Then | the plugin's skills and commands are installed at project scope |

## F-007-04 Update a plugin from its source

| Scenario | F-007-04 |
| --- | --- |
| Name | Update a plugin from its source |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin is installed at a scope |
| And | its source now has a newer version that adds one skill and drops another |
| When | I run "aa plugin update <plugin>" |
| Then | the new skill is installed and the dropped skill is removed |
| And | the config records the newer version |
| And | the output names the old and new versions and what was added, changed, and removed |
| And | core skills are untouched |

## F-007-05 Update every plugin at a scope

| Scenario | F-007-05 |
| --- | --- |
| Name | Update every plugin at a scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin is installed at a scope |
| When | I run "aa plugin update" |
| Then | every plugin recorded at that scope is reinstalled from its source |
| And | a plugin already at its source's version is reported as current |

## F-007-06 Remove a plugin

| Scenario | F-007-06 |
| --- | --- |
| Name | Remove a plugin |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin is installed at a scope |
| When | I run "aa plugin remove <plugin>" |
| Then | its skills and commands are removed from that scope |
| And | core skills are untouched |

## F-007-07 List plugins

| Scenario | F-007-07 |
| --- | --- |
| Name | List plugins |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "aa plugin list" |
| Then | it lists installed plugins by scope, with each one's version and source |
| And | it lists the plugins available from the organisation config repository, if one is set |

## F-007-08 A plugin cannot change core

| Scenario | F-007-08 |
| --- | --- |
| Name | A plugin cannot change core |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin that redefines a core skill |
| When | I run "aa plugin install <plugin>" |
| Then | the plugin is refused |
| And | the reason names the core skill it tried to change |

## F-007-09 A plugin declares one of the three kinds

| Scenario | F-007-09 |
| --- | --- |
| Name | A plugin declares one of the three kinds |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin whose kind is not tech-stack, tool, or process |
| When | I run "aa plugin install <plugin>" |
| Then | the plugin is refused |
| And | the reason names the three kinds |

## F-007-10 Every plugin skill attaches to the life cycle

| Scenario | F-007-10 |
| --- | --- |
| Name | Every plugin skill attaches to the life cycle |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin with a skill that names no core step, process, or requirement |
| When | I run "aa plugin install <plugin>" |
| Then | the plugin is refused |
| And | the reason names the skill and says to install it as an ordinary agent skill instead |

## F-007-11 A plugin skill attaches only to what core defines

| Scenario | F-007-11 |
| --- | --- |
| Name | A plugin skill attaches only to what core defines |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a plugin with a skill that attaches to a step core does not define |
| When | I run "aa plugin install <plugin>" |
| Then | the plugin is refused |
| And | the reason names the unknown step |

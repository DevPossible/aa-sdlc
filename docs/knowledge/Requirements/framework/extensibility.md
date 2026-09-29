# F-027 /aa-fw-extend helps the user create extensions to the framework

| Feature | F-027 |
| --- | --- |
| Name | /aa-fw-extend helps the user create extensions to the framework |
| Tags | @framework @agent @T-02 @T-01 |
| File | extensibility |

The core roughs in the framework and expects others to supply the specifics (T-02). /aa-fw-extend
is the skill that makes supplying them easy: it walks the user from "I need the framework to
know about X" to a valid, installable extension that follows the tenets, declares its
requirements, and carries its own feature files.

## Background

| Step | Text |
| --- | --- |
| Given | the skills and commands are installed in the agent |

## F-027-01 Choose the kind of extension

| Scenario | F-027-01 |
| --- | --- |
| Name | Choose the kind of extension |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-fw-extend" |
| Then | it asks what the extension is for |
| And | it offers the kinds: a tech-stack pack, a tool pack, a process pack, a project skill, a target adapter, added guidance, and an added requirement |
| And | it explains which kind fits the need before scaffolding anything |

## F-027-02 Scaffold a tech-stack pack

| Scenario | F-027-02 |
| --- | --- |
| Name | Scaffold a tech-stack pack |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I choose a tech-stack pack for a technology |
| When | "/aa-fw-extend" scaffolds it |
| Then | a plugin folder exists with a manifest naming the technology it covers |
| And | it contains stack-specific guidance for implement, generate-tests, setup-pipeline, and the other steps it extends |
| And | it may name the tools of that stack, because that is what a plugin is for |
| And | it declares the requirements those tools imply |

## F-027-03 Scaffold a tool pack

| Scenario | F-027-03 |
| --- | --- |
| Name | Scaffold a tool pack |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I choose a tool pack for a tool the life cycle uses, such as a formatter, a load-testing tool, or a pipeline system |
| When | "/aa-fw-extend" scaffolds it |
| Then | a plugin folder exists with a manifest of kind tool |
| And | each skill names the core step or process it serves, or the core requirement it satisfies |
| And | it may name the tool and carry opinions on how to use it, per language where that matters |
| And | a pipeline pack covers pipeline definitions and runs, never the tickets, merge requests, or wiki of the same system (T-05) |

## F-027-04 Refuse a skill that does not attach to the life cycle

| Scenario | F-027-04 |
| --- | --- |
| Name | Refuse a skill that does not attach to the life cycle |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I ask for a plugin skill that serves no step, process, or requirement, such as code generation, script generation, organisation-wide practice, or media generation |
| When | "/aa-fw-extend" fits the kind |
| Then | it says the skill is an ordinary agent skill, not a plugin |
| And | it offers to leave it as a user or project skill outside the framework |

## F-027-05 Scaffold a process pack

| Scenario | F-027-05 |
| --- | --- |
| Name | Scaffold a process pack |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I choose a process pack for an extra step or gate |
| When | "/aa-fw-extend" scaffolds it |
| Then | a plugin folder exists with a manifest naming the process it adds to |
| And | each added step has a skill, a command, and named artifacts |
| And | the added process is described, not enforced |

## F-027-06 Scaffold a project skill

| Scenario | F-027-06 |
| --- | --- |
| Name | Scaffold a project skill |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I choose a project skill for something specific to this repository |
| When | "/aa-fw-extend" scaffolds it |
| Then | a skill folder exists in the project's own skills location |
| And | it is installed at project scope only |
| And | "/aa-fw-health" reports it as covering the technology or concern it names |

## F-027-07 Scaffold a target adapter

| Scenario | F-027-07 |
| --- | --- |
| Name | Scaffold a target adapter |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | I choose a target adapter for an agent the framework does not yet support |
| When | "/aa-fw-extend" scaffolds it |
| Then | a target folder exists with templates for where skills and commands are installed |
| And | it declares whether the target supports commands and hooks |
| And | the skills themselves are not copied or changed |

## F-027-08 An extension declares its requirements

| Scenario | F-027-08 |
| --- | --- |
| Name | An extension declares its requirements |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-fw-extend" scaffolds any extension |
| Then | every capability the extension depends on is declared as a requirement in its own numbered range |
| And | "/aa-fw-health" aggregates those requirements once the extension is installed |

## F-027-09 An extension carries its own feature files

| Scenario | F-027-09 |
| --- | --- |
| Name | An extension carries its own feature files |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-fw-extend" scaffolds any extension |
| Then | the extension has a features folder |
| And | its behaviour is captured as scenarios before its skills are written |
| And | the scenarios are tagged with the framework IDs they realise |

## F-027-10 An extension cannot change core

| Scenario | F-027-10 |
| --- | --- |
| Name | An extension cannot change core |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an extension that redefines a core skill, step, tenet, or opinion |
| When | "/aa-fw-extend" validates it |
| Then | the extension is refused |
| And | the reason names what it tried to change |
| And | it suggests adding guidance or a new step instead |

## F-027-11 Core extensions stay tool-neutral

| Scenario | F-027-11 |
| --- | --- |
| Name | Core extensions stay tool-neutral |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an extension that adds guidance to core steps rather than to a tech-stack pack |
| And | that guidance names a tool |
| When | "/aa-fw-extend" validates it |
| Then | it reports the tenet T-01 violation |
| And | it suggests moving the guidance into a tech-stack pack |

## F-027-12 Validate before installing

| Scenario | F-027-12 |
| --- | --- |
| Name | Validate before installing |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-fw-extend" finishes scaffolding |
| Then | it validates the extension's structure, requirements, and feature files |
| And | it reports every problem with the file that has it |
| And | it installs the extension at the chosen scope only when validation passes |

## F-027-13 Share an extension with a team or organisation

| Scenario | F-027-13 |
| --- | --- |
| Name | Share an extension with a team or organisation |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a valid extension |
| And | an organisation config repository is set |
| When | I ask "/aa-fw-extend" to share it |
| Then | it adds the extension to the config repository |
| And | "aa setup" on other machines picks it up at team or enterprise scope |

## F-027-14 Extend an existing extension

| Scenario | F-027-14 |
| --- | --- |
| Name | Extend an existing extension |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a tech-stack pack is installed |
| When | I run "/aa-fw-extend" and choose to add to it |
| Then | it adds the new guidance, step, or requirement to that pack |
| And | it updates the pack's feature files to match |
| And | it does not create a second pack for the same technology |

# F-002 /aa-fw-init bootstraps what needs judgement

| Feature | F-002 |
| --- | --- |
| Name | /aa-fw-init bootstraps what needs judgement |
| Tags | @agent @T-06 @T-11 |
| File | init |

aa init on the CLI lays down files. /aa-fw-init in the agent works through the unmet
requirements that need a decision, with the user's consent, and reports the rest.

## Background

| Step | Text |
| --- | --- |
| Given | the skills and commands are installed in the agent |
| And | I am in a repository initialised with "aa init" |

## F-002-01 Start from health

| Scenario | F-002-01 |
| --- | --- |
| Name | Start from health |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-fw-init" |
| Then | it runs "/aa-fw-health" first |
| And | it works only on requirements reported as unmet |

## F-002-02 Fix what it can, with consent

| Scenario | F-002-02 |
| --- | --- |
| Name | Fix what it can, with consent |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an unmet requirement has a remedy the agent can perform |
| When | I run "/aa-fw-init" |
| Then | it proposes the remedy |
| And | it performs it only after the user agrees |

## F-002-03 A language with no formatter

| Scenario | F-002-03 |
| --- | --- |
| Name | A language with no formatter |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project has a language with no formatter |
| When | I run "/aa-fw-init" |
| Then | it names the language |
| And | it offers the options available in the project's scope, without naming a tool itself |
| And | it lets the user choose |

## F-002-04 A technology with no skill in scope

| Scenario | F-002-04 |
| --- | --- |
| Name | A technology with no skill in scope |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project's stack has a technology with no skill in scope |
| When | I run "/aa-fw-init" |
| Then | it names the technology |
| And | it lists the tech-stack plugins that would cover it |
| And | it lets the user choose |

## F-002-05 Report what it cannot fix

| Scenario | F-002-05 |
| --- | --- |
| Name | Report what it cannot fix |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an unmet requirement that needs the user to act outside the agent |
| When | I run "/aa-fw-init" |
| Then | it lists the requirement and the remedy |
| And | it does not attempt the remedy itself |

## F-002-06 Finish with health

| Scenario | F-002-06 |
| --- | --- |
| Name | Finish with health |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-fw-init" completes |
| Then | it runs "/aa-fw-health" again |
| And | it reports what changed and what remains |

## F-002-07 Ask for the ticket project and knowledge base

| Scenario | F-002-07 |
| --- | --- |
| Name | Ask for the ticket project and knowledge base |
| Kind | Scenario |
| Tags | @O-09 @O-04 @R-22 @R-03 @T-05 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the project config names no ticket project |
| When | I run "/aa-fw-init" |
| Then | it asks which ticket project this repository belongs to and where its knowledge base is |
| And | it accepts a name, a key, or a URL |

## F-002-08 A connector for the named system is in scope

| Scenario | F-002-08 |
| --- | --- |
| Name | A connector for the named system is in scope |
| Kind | Scenario |
| Tags | @T-05 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user answers with a system and a project URL |
| And | the agent has a skill, MCP server, or CLI for that system that is authorised |
| When | "/aa-fw-init" continues |
| Then | it confirms through the connector that the project exists |
| And | it records the project key and URL in the project config |
| And | it does not name any system the user did not name |

## F-002-09 A connector is present but not authorised for the site

| Scenario | F-002-09 |
| --- | --- |
| Name | A connector is present but not authorised for the site |
| Kind | Scenario |
| Tags | @T-05 @T-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user answers with a system and a project URL |
| And | the agent has a connector for that system that is not authorised for that site |
| When | "/aa-fw-init" continues |
| Then | it says the connector was found and is not authorised for the site |
| And | it records the mapping in the project config anyway |
| And | it says health will report R-02 or R-03 unmet until the connector is authorised |

## F-002-10 No connector for the named system is in scope

| Scenario | F-002-10 |
| --- | --- |
| Name | No connector for the named system is in scope |
| Kind | Scenario |
| Tags | @T-05 @T-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user answers with a system and a project URL |
| And | the agent has nothing in scope for that system |
| When | "/aa-fw-init" continues |
| Then | it says nothing in scope reaches that system |
| And | it records the mapping in the project config anyway |
| And | the remedy is for the user to install or authorise a connector |

## F-002-11 The ticket project is checked as soon as it is confirmed

| Scenario | F-002-11 |
| --- | --- |
| Name | The ticket project is checked as soon as it is confirmed |
| Kind | Scenario |
| Tags | @O-26 @R-41 @R-43 @T-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user has named a ticket project and a connector reaches it |
| When | "/aa-fw-init" continues |
| Then | before anything else it reads the project's issue types, workflow, and board |
| And | it reports every gap R-41 and R-43 find, with the steps that would stumble on each |
| And | no discipline step is recommended until the gaps are fixed or the user accepts them |

## F-002-12 Configure the ticket project with consent

| Scenario | F-002-12 |
| --- | --- |
| Name | Configure the ticket project with consent |
| Kind | Scenario |
| Tags | @O-26 @R-43 @T-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project's workflow is missing states, moves, or parent links the life cycle needs |
| When | "/aa-fw-init" proposes the changes, one line each, and the user agrees |
| Then | it makes them through the connector where the user may administer the project |
| And | it records the mapping in the project config |
| And | it runs the R-41 and R-43 probes again and reports the result |

## F-002-13 A ticket project this user cannot configure

| Scenario | F-002-13 |
| --- | --- |
| Name | A ticket project this user cannot configure |
| Kind | Scenario |
| Tags | @O-26 @R-43 @T-10 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the ticket project needs changes the user is not allowed to make |
| When | "/aa-fw-init" continues |
| Then | it lists each change for the project's administrator, in the ticket system's words |
| And | it records the mapping it could make and says health will report R-43 unmet until then |

## F-002-14 A ticket project created during init is configured before it is used

| Scenario | F-002-14 |
| --- | --- |
| Name | A ticket project created during init is configured before it is used |
| Kind | Scenario |
| Tags | @O-26 @R-43 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the user asks "/aa-fw-init" to create the ticket project |
| When | it creates the project with consent |
| Then | it gives the project the states, moves, kinds, parent links, and board places the life cycle needs |
| And | it probes R-41 and R-43 before reporting the project ready |

## F-002-15 Survey the user when the stack cannot be inferred

| Scenario | F-002-15 |
| --- | --- |
| Name | Survey the user when the stack cannot be inferred |
| Kind | Scenario |
| Tags | @O-21 @R-44 @T-01 @T-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the repository has no code, or code that does not settle the stack |
| When | "/aa-fw-init" reaches the tools |
| Then | it asks what is being built, in which languages and frameworks at which versions, for which platforms, deployed where, and built by which pipeline |
| And | it asks nothing the repository already answers |

## F-002-16 Choose, record, and install the tools

| Scenario | F-002-16 |
| --- | --- |
| Name | Choose, record, and install the tools |
| Kind | Scenario |
| Tags | @O-21 @R-44 @R-45 @T-01 @T-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the stack is known |
| When | "/aa-fw-init" works through each category the framework and the stack prescribe |
| Then | for each it proposes the tools in scope or from a tech-stack plugin, and the user chooses |
| And | it records each choice in the project config with its category, minimum version, check command, and install command per platform |
| And | it adds each install to the root initialize script, so a fresh clone gets the same tools |
| And | it installs what is missing on this machine, with consent, and checks each again |

## F-002-17 Install or connect the ticket and knowledge connectors

| Scenario | F-002-17 |
| --- | --- |
| Name | Install or connect the ticket and knowledge connectors |
| Kind | Scenario |
| Tags | @O-03 @O-04 @R-02 @R-03 @T-05 @T-06 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | no connector in scope reaches the ticket system or knowledge base the user named |
| When | "/aa-fw-init" continues |
| Then | it offers the connectors available for that system, a server the agent can load or a command line tool, and the user chooses |
| And | with consent it installs and configures the chosen one for this harness |
| And | it tells the user exactly what to do to authorise it, then probes R-02 or R-03 again |

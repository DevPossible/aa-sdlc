# Discipline Review

**Generated from `src/aa-sdlc/workflow/` by `scripts/Build-DisciplineReview.ps1`. Do not edit by hand; edit the YAML and regenerate.**

Every discipline in SDLC order: its role and bounded responsibilities, its commands, and the guidance the agent follows for each command. Shared guidance is cited by id and expanded inline; step-specific guidance follows it.

## Contents

- 0. [Framework](#0-framework) (`fw`): 3 commands
- 1. [Product Management](#1-product-management) (`pd`): 3 commands
- 2. [Business Analysis](#2-business-analysis) (`ba`): 3 commands
- 3. [UX Design](#3-ux-design) (`ux`): 2 commands
- 4. [Technical Analysis](#4-technical-analysis) (`ta`): 3 commands
- 5. [Security](#5-security) (`sec`): 3 commands
- 6. [Refinement](#6-refinement) (`rf`): 2 commands
- 7. [Project Management](#7-project-management) (`pm`): 3 commands
- 8. [Implementation Planning](#8-implementation-planning) (`ip`): 2 commands
- 9. [Development](#9-development) (`dev`): 6 commands
- 10. [Testing](#10-testing) (`qa`): 5 commands
- 11. [Documentation](#11-documentation) (`doc`): 2 commands
- 12. [Release Management](#12-release-management) (`rel`): 3 commands
- 13. [Operations](#13-operations) (`ops`): 4 commands
- 14. [Support](#14-support) (`sup`): 3 commands

## 0. Framework

**Code:** `fw` | **Id:** `framework` | **Commands:** `/aa-fw-health`, `/aa-fw-init`, `/aa-fw-extend`

### Role

The framework's own work: bootstrapping a project, checking that the environment and repository meet the declared requirements, and growing the framework through extensions. It is not a software delivery discipline; it is what makes the other fourteen runnable.

**Owns**

- Aggregating and probing every declared requirement and reporting the result (T-10, T-11)
- Bringing a repository up to the framework's requirements with the user's consent
- Scaffolding, validating, installing, and sharing extensions (T-02)
- Routing the agent to the right discipline and step for the task at hand

**Does not own**

- Any project artifact; it produces reports, config, folders, and extensions only
- Machine-level installation, which belongs to the aa CLI (aa setup, aa init)
- Fixing a missing tool by choosing one; it names the gap and the project chooses (T-01)

**Hands off to**

- **Business Analysis** when a project is bootstrapped and real work begins with discovery
- **Development** when init has created stub root scripts that a developer must fill in

*Tenets: T-02, T-10, T-11*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-fw-health` | Report health | none | Health report |
| `/aa-fw-init` | Bootstrap a project | none | Bootstrapped project |
| `/aa-fw-extend` | Create an extension | optional | Extension |

### `/aa-fw-health`

Aggregate every requirement declared by the installed skills, plugins, and processes, probe each one, and report what is met, unmet, or not applicable, and what depends on each. Report the install itself. Never block, never change anything.

**Inputs**

- The installed skills and plugins and the requirements they declare
- The merged aa.config.yaml, if a project is in scope
- The agent's own tools: which systems it can actually reach

**Artifacts**

- **Health report** in returned to the user; written to the documents folder only if asked
  - Every declared requirement appears with a status and, if unmet, what depends on it and the remedy
  - The install (scope, version, target, skills, commands, update available) is reported
  - Coverage is reported per discipline and technology, never headcount (T-13)

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Probe by doing, not by looking. To check the ticket system, read a ticket; to check source control, read the remote; to check the build, run the build script. A configuration file that exists proves nothing.
- Report not-applicable as its own status. A requirement that cannot apply here (hooks on a target with no hooks) is not a failure and must not look like one.
- Change nothing. If a probe would need to create, write, or install anything to succeed, report it as unmet and name /aa-fw-init as the remedy.
- Group the report by kind (environment, project, tooling, coverage) and lead with required-and-unmet.

*Requires: R-04, R-07 | Tenets: T-10, T-11, T-13*

### `/aa-fw-init`

Run health, then work through the unmet requirements that need judgement, fixing each with the user's consent, listing what cannot be fixed with its remedy, and running health again.

**Inputs**

- The health report
- The merged aa.config.yaml written by aa init
- The project's detected stack

**Artifacts**

- **Bootstrapped project** in the repository root and the project config
  - Every fixable unmet requirement was proposed and, if agreed, fixed
  - Every unfixable unmet requirement is listed with its remedy
  - A second health report shows what changed and what remains

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Propose, then act. State each fix as a one-line proposal with what it creates or changes, and perform it only after the user agrees. Batch trivial fixes (folders, stubs) into one proposal.
- Never choose a tool for the project. When a language has no formatter or a technology has no skill, name the gap and list what is available in the project's scope or as plugins; the user chooses (T-01).
- Map before you create. If the repository already has an equivalent of a conventional folder, propose the mapping in the project config rather than a second folder.
- Leave stubs honest. A stub root script must say, in its first lines, exactly what it must do when filled in and must exit non-zero until it is.

*Requires: R-04, R-07 | Tenets: T-06, T-11*

### `/aa-fw-extend`

Walk the user from a need the framework does not cover to a valid, installable extension: choose the kind, scaffold it, declare its requirements, write its feature files, validate it against the tenets, and install or share it.

**Inputs**

- What the user needs the framework to know about
- The installed extensions, to add to rather than duplicate
- The organisation config repository, if sharing

**Artifacts**

- **Extension** in plugins/<name>/ for packs; the project's skills location for a project skill; targets/<name>/ for an adapter
  - Has a manifest, declared requirements in its own id range, and feature files
  - Passes validation: changes nothing in core, and core-level guidance names no tool
  - Installed at the chosen scope, or added to the organisation config repository

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Fit the kind to the need before scaffolding. A stack-specific practice is a tech-stack pack; an organisational gate is a process pack; something only this repository needs is a project skill; a new agent is a target adapter. Explain the choice in one sentence.
- Write the feature file first. The extension's behaviour is captured as scenarios before any skill text is written, so the skill has something to be checked against.
- Refuse politely and specifically. When an extension would change core, name the exact core item and offer the nearest allowed alternative.
- Prefer adding to an existing pack over creating a second pack for the same technology or process.

*Requires: R-04, R-05 | Tenets: T-01, T-02, T-11, T-12*

## 1. Product Management

**Code:** `pd` | **Id:** `product-management` | **Commands:** `/aa-pd-define-outcome`, `/aa-pd-prioritise`, `/aa-pd-iterate`

### Role

Decides what to build and why, and in what order. Owns the outcome the software is meant to achieve, the measure of whether it did, and the roadmap that sequences the work. Product Management answers "should we", Business Analysis answers "what exactly".

**Owns**

- The product outcome and success metrics for each initiative, recorded as the anchor epic
- Prioritisation of the backlog by value, risk, and dependency
- Feedback analysis from users, support, and production data, and the roadmap it produces
- The decision to start, pause, or stop an initiative

**Does not own**

- Detailed requirements and scenarios, which belong to Business Analysis
- Breaking work into tickets, which belongs to Refinement
- Estimation and capacity, which belong to Project Management and Implementation Planning

**Hands off to**

- **Business Analysis** when an initiative has an approved outcome and needs its requirements discovered
- **Refinement** when priorities are set and epics must become a well-formed backlog

*Tenets: T-04, T-13 | Opinions: O-03*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-pd-define-outcome` | Define the outcome | optional | Anchor epic |
| `/aa-pd-prioritise` | Prioritise the backlog | optional | Ordered backlog |
| `/aa-pd-iterate` | Analyse feedback and update the roadmap | optional | Product feedback analysis |

### `/aa-pd-define-outcome`

Write down what an initiative is meant to achieve and how we will know. Produces the anchor epic with a measurable outcome, so every later step can answer "does this serve the outcome".

**Inputs**

- The idea, request, or problem statement
- Existing roadmap and outcomes, to avoid duplicates and find conflicts

**Artifacts**

- **Anchor epic** in the ticket system
  - States the outcome as a change in a measure, not a list of features
  - Names the success metric, its current value, and the target
  - Names who benefits and what they can do afterwards that they cannot do now

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Outcome, not output. If the statement can be satisfied by shipping something nobody uses, rewrite it until it cannot.
- Put a number on it. A metric with no baseline is a wish; measure or estimate the current value and say which.
- Say what is out of scope in the same place, so refinement does not have to guess.

*Requires: R-02 | Tenets: T-04, T-07*

### `/aa-pd-prioritise`

Order epics and stories by value against the outcome, risk, and dependency, and record why. The ordered backlog lives in the ticket system; the reasoning lives on the tickets.

**Inputs**

- The backlog as it stands in the ticket system
- Outcomes and metrics from define-outcome
- Dependencies and risks surfaced by Refinement, Technical Analysis, and Security

**Artifacts**

- **Ordered backlog** in the ticket system
  - Every item has a rank and a one-line reason on the ticket
  - Items blocked by a dependency are ranked after what blocks them
  - The top of the backlog is ready or in refinement, not raw ideas

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Rank by outcome contribution first, then risk reduction, then cost. When two items tie, prefer the one that retires an unknown.
- Never reorder silently. Every change of rank is a comment on the ticket saying what moved and why.
- Ask before demoting. If an item someone is working on drops out of the iteration, that is a conversation, not a rank change.

*Requires: R-02 | Tenets: T-04, T-06*

### `/aa-pd-iterate`

Turn what users, support, and production are saying into decisions: what to enhance, what to fix, what to stop. Produces a feedback analysis and a roadmap update, with new tickets where the answer is "build".

**Inputs**

- User feedback, support tickets, incident post-mortems, and production metrics
- Current roadmap and outcomes

**Artifacts**

- **Product feedback analysis** in the knowledge base, linked from the roadmap epic
  - Feedback is grouped by theme with counts and sources, not by who said it loudest
  - Each theme has a decision: enhance, fix, stop, or wait, with a reason
- **Roadmap update** in the ticket system and the knowledge base
  - Every "enhance" or "fix" decision has a ticket; every "stop" has a closed ticket with the reason

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-10** Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Count before you conclude. Compute theme frequencies and metric movements with a tool; do not eyeball a list and call it a trend.
- Separate signal from volume. One report from a critical workflow can outrank twenty from a cosmetic one; say so explicitly when you rank that way.
- Close the loop. Where feedback came from a ticket, comment on it with the decision.

*Requires: R-02, R-03, R-04 | Tenets: T-04, T-07 | Methodology: phase 6 step 6.3*

## 2. Business Analysis

**Code:** `ba` | **Id:** `business-analysis` | **Commands:** `/aa-ba-discover`, `/aa-ba-refine-requirements`, `/aa-ba-uat`

### Role

Turns a business need into requirements the whole team can read and a test can execute. Discovers what stakeholders actually need, closes the gaps, writes it as Gherkin scenarios, and later confirms with those stakeholders that what was built is what they meant.

**Owns**

- Discovery with stakeholders and the initial requirements it produces
- Gap analysis, the question log, and getting questions answered
- Requirements as scenarios in feature files, linked to tickets and pages (T-12, O-01)
- User acceptance testing against those scenarios

**Does not own**

- Deciding whether the need is worth pursuing, which belongs to Product Management
- How the requirement will be built, which belongs to Technical Analysis and Development
- Test coverage beyond the stated requirement, which belongs to Testing

**Hands off to**

- **UX Design** when requirements involve user interaction and need mockups to be understood
- **Technical Analysis** when requirements are stable enough to architect against
- **Refinement** when scenarios exist and must become tickets

*Tenets: T-04, T-07, T-12 | Opinions: O-01*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-ba-discover` | Run discovery | required | Initial requirements |
| `/aa-ba-refine-requirements` | Refine requirements | required | Feature files |
| `/aa-ba-uat` | User acceptance testing | required | UAT test cases |

### `/aa-ba-discover`

Capture what stakeholders need, as they say it and as they mean it. Produces the initial requirements as draft scenarios and a question log of everything not yet answered.

**Inputs**

- The anchor epic and its outcome
- Stakeholder input: a conversation, a transcript, a document, or a session with the user
- Existing system documentation and feature files

**Artifacts**

- **Initial requirements** in the features folder, as draft scenarios tagged with the epic
  - Every stated need is a scenario or an explicit non-requirement
  - Business objectives and scope boundaries appear in the feature description
- **Question log** in the anchor epic, as open questions
  - Every unanswered question has context and an owner

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Write it as Gherkin from the first pass. A requirement captured in prose has to be translated later and loses something each time; a draft scenario can be wrong in a way everyone can see.
- Ask the confirming question, not the leading one. "So when X happens you need Y?" invites agreement; "What happens when X?" invites the truth.
- Record what was not said. Silence on error cases, permissions, and edge conditions is a question, not an assumption.

*Requires: R-02, R-16 | Tenets: T-04, T-06, T-12 | Methodology: phase 1 step 1.1*

### `/aa-ba-refine-requirements`

Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page.

**Inputs**

- Draft scenarios and the question log from discover
- Answers from stakeholders
- Technical constraints from Technical Analysis and Security, if available

**Artifacts**

- **Feature files** in the features folder
  - Every scenario has concrete Given, When, Then steps with no "should work correctly"
  - Every scenario is tagged with its ticket; every feature names its knowledge base page
  - Ambiguities are resolved or recorded as open questions on the ticket
- **Technical constraints document** in the knowledge base, linked from the epic
  - Lists the constraints (platform, integration, compliance, performance) the scenarios must satisfy, each with its source

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- One behaviour per scenario. If a scenario needs "and" in its Then to describe two outcomes that could fail independently, split it.
- Make it executable in principle. Every step must be something a test could observe; if it cannot be observed, it is not a requirement, it is a hope.
- Trace every change. When a scenario changes, the ticket's acceptance criteria and the page follow (T-12); never edit the ticket first.

*Requires: R-02, R-03, R-16 | Tenets: T-07, T-12 | Methodology: phase 1 step 1.2*

### `/aa-ba-uat`

Confirm with the people who asked for it that what was built is what they meant. Walks stakeholders through the scenarios against the built software and records acceptance or the gap.

**Inputs**

- The feature files for the ticket or release
- A deployed environment the stakeholder can use
- The tests Development and Testing wrote, as evidence

**Artifacts**

- **UAT test cases** in the features folder, as the scenarios themselves, plus a walkthrough order on the ticket
  - Every scenario for the ticket is covered by the walkthrough
- **UAT results report** in the anchor ticket, linked from the knowledge base page
  - Each scenario is marked accepted or not, by whom, with the gap described where not
  - Every gap is a new ticket or a scenario change, never a note that fades

**Guidance**

- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Test the scenario, not the demo. Walk the stakeholder through the Given, When, Then as written; if they want something else, that is a requirement change, and it goes through the feature file.
- A gap is not a failure of the build if the scenario was met. Record it as a new requirement so Development is not blamed for a discovery miss.
- Record acceptance by name. "Accepted by the product owner on this date" is evidence; "UAT passed" is not.

*Requires: R-02, R-16 | Tenets: T-06, T-07, T-12 | Methodology: phase 5 step 5.2*

## 3. UX Design

**Code:** `ux` | **Id:** `ux-design` | **Commands:** `/aa-ux-prototype`, `/aa-ux-review-ux`

### Role

Makes requirements tangible before they are built and checks the result against real use afterwards. Produces mockups and prototypes that stakeholders react to, and reviews the built software for how people actually interact with it.

**Owns**

- Mockups and interactive prototypes for requirements with a user interface
- Interaction and flow design: what the user does, in what order, and what they see
- Usability review of built features and the tickets it raises

**Does not own**

- The requirement itself, which belongs to Business Analysis
- Visual brand or design system, which is a plugin or project concern
- Front-end implementation, which belongs to Development

**Hands off to**

- **Business Analysis** when a prototype changes or clarifies a requirement, so the scenarios must change
- **Development** when an approved prototype is ready to build from

*Tenets: T-06, T-07*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-ux-prototype` | Prototype | required | Mockups |
| `/aa-ux-review-ux` | Review interaction | required | Usability findings |

### `/aa-ux-prototype`

Make the requirement visible before it is built. Produces mockups and, where the interaction matters, an interactive prototype that stakeholders can react to, and feeds what they say back into the scenarios.

**Inputs**

- The scenarios for the ticket or epic
- Existing design system or conventions in the project, if any
- The technical constraints document

**Artifacts**

- **Mockups** in the documents folder or the design tool the project uses, linked from the ticket and page
  - Every scenario with a user interface has at least one mockup showing its When and Then
  - Variations are labelled with what question each answers
- **Interactive prototype** in linked from the ticket
  - Covers the primary flow end to end; a stakeholder can complete the scenario's When without help

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Prototype the flow, not the pixels. The question a prototype answers is "is this the right interaction", and polish hides that question.
- Show the unhappy path. A mockup that only shows success leaves the error states to be invented at implementation time.
- Feed changes back through the feature file. If the prototype review changes what the user needs, change the scenario, then the prototype (T-12).

*Requires: R-02, R-16 | Tenets: T-06, T-12 | Methodology: phase 1 step 1.3*

### `/aa-ux-review-ux`

Use the built software the way a user would and record where the interaction fails the scenario, the prototype, or plain sense. Raises tickets for what it finds.

**Inputs**

- The deployed or locally running feature
- The scenarios and the prototype

**Artifacts**

- **Usability findings** in the anchor ticket and the knowledge base page
  - Each finding names the scenario or flow, what was expected, what happened, and the severity
  - Each finding with severity above cosmetic is a ticket

**Guidance**

- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Follow the scenario literally first, then wander. The literal pass finds what was missed; the wander finds what was never imagined.
- Distinguish defect from design. "It does not do what the scenario says" goes to Development; "the scenario was wrong" goes to Business Analysis as a requirement change.

*Requires: R-02, R-16 | Tenets: T-07 | Methodology: phase 5*

## 4. Technical Analysis

**Code:** `ta` | **Id:** `technical-analysis` | **Commands:** `/aa-ta-architect`, `/aa-ta-decide`, `/aa-ta-spike`

### Role

Decides how the system will be shaped and records why. Produces the architecture, the technology choices, and the decision records that let anyone later understand what was considered and rejected. Investigates unknowns with time-boxed spikes rather than guesses.

**Owns**

- System architecture and its diagrams
- Technology stack choices and the constraints they impose
- Decision records for every significant technical decision (G-10)
- Time-boxed spikes to resolve technical unknowns

**Does not own**

- Security threat modelling, which belongs to Security, though it consumes the result
- Implementation planning for a single ticket, which belongs to Implementation Planning
- Infrastructure and pipelines, which belong to Operations

**Hands off to**

- **Security** when an architecture exists and must be threat modelled
- **Refinement** when technical constraints are known and the backlog can be shaped
- **Implementation Planning** when a ticket needs a plan within the agreed architecture

*Tenets: T-01, T-04 | Opinions: O-04*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-ta-architect` | Architect | required | System architecture |
| `/aa-ta-decide` | Record a decision | required | Decision record |
| `/aa-ta-spike` | Spike | required | Spike finding |

### `/aa-ta-architect`

Decide the shape of the system for an epic or initiative: components, boundaries, integrations, data, and the technology stack, each with the reason. Produces the architecture and the decision records that back it.

**Inputs**

- The feature files and technical constraints document
- The existing architecture and decision records
- Organisational standards from the enterprise or team scope

**Artifacts**

- **System architecture** in the documents folder, linked from the knowledge base page and the epic
  - Shows components, their responsibilities, and every integration boundary
  - Every scenario can be traced to the components that satisfy it
- **Technology stack document** in the knowledge base
  - Every technology choice has a decision record
  - Constraints imposed on Development and Operations are explicit

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-10** Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Decide the fewest things that let work start. Every decision made before it is needed is a decision made with the least information.
- Name the alternatives you rejected. An architecture without rejected options is a preference, not a decision (G-10).
- Constrain, do not prescribe. Say what a component must guarantee, not how its code must look; the how belongs to Implementation Planning and the stack.

*Requires: R-02, R-03, R-06 | Tenets: T-01, T-04 | Methodology: phase 1 step 1.4*

### `/aa-ta-decide`

Record one significant technical decision: the context, the options, the choice, and the consequences, so the next person can understand it without asking. Standalone so that decisions made mid-implementation are captured too.

**Inputs**

- The decision to be made or just made, and the anchor ticket it arose from
- Existing decision records that touch the same area

**Artifacts**

- **Decision record** in the knowledge base, or the documents folder as a numbered record, linked from the ticket
  - States context, options considered, the decision, and consequences
  - Is numbered, dated, and immutable once accepted; a reversal is a new record

**Guidance**

- **G-10** Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Short enough to read, complete enough to trust. One screen. If it needs more, the decision is several decisions.
- Record the losing options with the same care as the winner; the next person will ask about them first.
- Write it when it happens. A decision reconstructed a month later is a story, not a record.

*Requires: R-02, R-03 | Tenets: T-04*

### `/aa-ta-spike`

Resolve a technical unknown with a time-boxed investigation that produces an answer, not a product. Throwaway code is expected; the finding is the artifact.

**Inputs**

- The question the spike must answer, stated on the ticket
- The time box

**Artifacts**

- **Spike finding** in the anchor ticket, with a decision record if the finding decides something
  - Answers the stated question, or states why it could not and what would
  - Names what was tried, what was learned, and what to do next
  - Spike code is clearly marked as not for production and is not merged to the main branch

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-10** Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Write the question before the code. A spike without a question becomes a prototype without a purpose.
- Stop at the time box. Report what you have; an unanswered question with evidence is more useful than a late answer.
- Never let spike code become the implementation by accident. If it is good enough to keep, that is a decision to record and a ticket to implement properly.

*Requires: R-02, R-04, R-05 | Tenets: T-07*

## 5. Security

**Code:** `sec` | **Id:** `security` | **Commands:** `/aa-sec-threat-model`, `/aa-sec-security-test`, `/aa-sec-maintain-security`

### Role

Finds what could go wrong before an attacker does. Threat models the architecture, turns the mitigations into requirements, tests the built system for the weaknesses that matter, and keeps dependencies, secrets, and compliance evidence current over the life of the system.

**Owns**

- Threat models and the security requirements they produce as scenarios
- Security testing of the built system and the compliance report
- Dependency and secret hygiene, patching, and compliance audit evidence

**Does not own**

- Fixing the defects it finds, which belongs to Development via tickets it raises
- Infrastructure hardening, which belongs to Operations against Security's requirements
- Functional testing, which belongs to Testing

**Hands off to**

- **Refinement** when mitigations must become tickets on the backlog
- **Development** when a security defect is found and needs a fix
- **Operations** when an infrastructure or pipeline control is required

*Tenets: T-07, T-11*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-sec-threat-model` | Threat model | required | Threat model |
| `/aa-sec-security-test` | Security test | required | Security test results |
| `/aa-sec-maintain-security` | Maintain security and compliance | required | Security patch log |

### `/aa-sec-threat-model`

Work through what could go wrong with the architecture from an attacker's view, decide which threats matter, and turn each mitigation into a security requirement as a scenario and a ticket.

**Inputs**

- The system architecture and technology stack document
- The feature files, for data flows and trust boundaries
- Organisational security standards from the enterprise scope, if any

**Artifacts**

- **Threat model** in the knowledge base, linked from the epic
  - Every trust boundary and data flow in the architecture is considered
  - Every threat is rated and has a decision: mitigate, accept, or transfer, with a reason
- **Security requirements** in the features folder as scenarios, and the backlog as tickets
  - Every mitigation is a scenario a test can verify and a ticket someone can build

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Follow the data. Start from what is valuable and trace how it moves; threats appear at every boundary it crosses.
- Accept explicitly. An accepted risk with a named owner and a reason is a decision; an unmentioned risk is a surprise.
- Make mitigations testable. "Validate input" is not a requirement; "Given a payload over the size limit, then the request is rejected with a logged event" is.

*Requires: R-02, R-03, R-16 | Tenets: T-07, T-11, T-12*

### `/aa-sec-security-test`

Test the built system for the weaknesses the threat model and common weakness classes predict, and produce evidence for the compliance report. Raises tickets for what it finds.

**Inputs**

- The threat model and security scenarios
- The built and deployed system, or the code and dependencies for static checks
- The project's security tooling category: static analysis, dependency scanning, dynamic testing

**Artifacts**

- **Security test results** in the anchor ticket, with the run output in the documents folder or test system
  - Every security scenario has a result; every finding has a severity and a ticket
  - Findings are reproducible from the recorded steps
- **Security compliance report** in the knowledge base
  - Maps each control the organisation requires to the evidence that it is met, or the ticket that will meet it

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Test against the model first, the checklist second. The threat model says what matters here; the checklist says what matters everywhere.
- Never test a production system without written permission on the ticket. Prefer a production-like environment.
- Report findings without drama and without softening. Severity comes from impact and likelihood, not from how it will be received.

*Requires: R-02, R-04, R-11 | Tenets: T-06, T-07 | Methodology: phase 3 step 3.4*

### `/aa-sec-maintain-security`

Keep the system safe after release: patch dependencies, rotate and remove secrets, review access, and keep the compliance evidence current. Recurring; each run anchors on a maintenance ticket.

**Inputs**

- Dependency and vulnerability reports from the project's tooling
- The compliance report and the controls it must evidence
- Secrets and access inventories where the project keeps them

**Artifacts**

- **Security patch log** in the knowledge base, with each patch as a ticket
  - Every known vulnerability above the agreed threshold is patched, accepted with a reason, or ticketed with a date
- **Compliance audit evidence** in the knowledge base
  - Every control has current evidence or an open ticket

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Patch in small, tested steps. A dependency update is a change like any other: branch, test, review, merge (G-08).
- Never commit, log, or paste a secret, including in the report of having found one. Reference where it was, not what it was.
- Treat "no findings" as a finding to verify. Confirm the scanner ran against the current code before reporting clean.

*Requires: R-01, R-02, R-05, R-11 | Tenets: T-07 | Methodology: phase 6 step 6.4*

## 6. Refinement

**Code:** `rf` | **Id:** `refinement` | **Commands:** `/aa-rf-plan-work`, `/aa-rf-refine-ticket`

### Role

Turns requirements and priorities into a backlog of tickets that are ready to plan and build. Every ticket that leaves Refinement has scenarios, acceptance criteria, and a size, and is small enough to finish in one iteration.

**Owns**

- Breaking epics into stories and tasks in the ticket system
- Making a single ticket ready: scenarios linked, acceptance criteria checkable, size agreed
- The definition of ready, and holding tickets to it

**Does not own**

- Priority order, which belongs to Product Management
- Writing new requirements, which belongs to Business Analysis; Refinement links, splits, and clarifies
- Committing tickets to an iteration, which belongs to Project Management

**Hands off to**

- **Project Management** when tickets are ready and an iteration can be planned
- **Implementation Planning** when a ready ticket is picked up for build
- **Business Analysis** when refinement finds a requirement gap that needs discovery, not splitting

*Tenets: T-04, T-08 | Opinions: O-03*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-rf-plan-work` | Break work into tickets | required | Stories and tasks |
| `/aa-rf-refine-ticket` | Make a ticket ready | required | Ready ticket |

### `/aa-rf-plan-work`

Turn an epic and its feature files into stories and tasks in the ticket system, each small enough to finish in one iteration, each linked to the scenarios it delivers.

**Inputs**

- The anchor epic, its outcome, and its feature files
- The architecture and technical constraints
- Priority from Product Management

**Artifacts**

- **Stories and tasks** in the ticket system, as children of the epic
  - Every scenario in the epic's feature files is linked to exactly one story
  - Every story can be finished in one iteration by one person or agent
  - Dependencies between stories are recorded as links, not prose

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Split by scenario, not by layer. A story that delivers one scenario end to end can be tested; a "backend story" and a "frontend story" cannot until both are done.
- Keep the epic's outcome on every story. A story that cannot say which outcome it serves is either mis-filed or unnecessary.
- Do not invent requirements while splitting. A gap found here goes back to Business Analysis as a question, not forward as a guess.

*Requires: R-02, R-16 | Tenets: T-04, T-08, T-12*

### `/aa-rf-refine-ticket`

Bring one ticket to the definition of ready: scenarios linked and complete, acceptance criteria checkable, size agreed, dependencies clear, questions answered or owned.

**Inputs**

- The ticket and its linked scenarios
- Open questions on the ticket
- The team's definition of ready from the project config or knowledge base

**Artifacts**

- **Ready ticket** in the ticket system
  - Meets every item of the definition of ready, or says which item it does not and why it proceeds anyway
  - Acceptance criteria are the scenarios, not a restatement of them
  - Size is recorded with the basis for it

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Read the scenarios before the ticket description. The description is what someone thought; the scenarios are what was agreed.
- Size from the plan, not the title. If sizing needs a plan, run implementation planning first and size from that.
- A ticket with an unanswered question that changes the scope is not ready, however small it looks.

*Requires: R-02, R-16 | Tenets: T-04, T-07*

## 7. Project Management

**Code:** `pm` | **Id:** `project-management` | **Commands:** `/aa-pm-plan-iteration`, `/aa-pm-status`, `/aa-pm-retrospective`

### Role

Keeps the work flowing and visible. Plans iterations against capacity, reports status from the ticket system rather than from memory, and runs retrospectives that turn what happened into what changes next.

**Owns**

- Iteration planning: what is committed, against what capacity
- Status reporting derived from the ticket system and source control
- Retrospectives and the improvement backlog they produce
- Impediment tracking and escalation

**Does not own**

- What to build or in what order, which belongs to Product Management
- Whether a ticket is ready, which belongs to Refinement
- Incident coordination, which belongs to Support

**Hands off to**

- **Implementation Planning** when an iteration is planned and tickets are assigned
- **Product Management** when a retrospective or status report changes priorities or the roadmap

*Tenets: T-04, T-07, T-13 | Opinions: O-03*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-pm-plan-iteration` | Plan an iteration | optional | Iteration plan |
| `/aa-pm-status` | Report status | optional | Status report |
| `/aa-pm-retrospective` | Run a retrospective | optional | Workflow health report |

### `/aa-pm-plan-iteration`

Commit a set of ready tickets to an iteration against known capacity, in priority order, and record the commitment and the risks in the ticket system.

**Inputs**

- The ordered backlog and which tickets are ready
- Capacity for the iteration, whatever unit the team uses
- Carry-over from the previous iteration and its reasons

**Artifacts**

- **Iteration plan** in the ticket system, as the iteration or milestone with its committed tickets
  - Committed size does not exceed capacity, or the overage is explicit and agreed
  - Every committed ticket is ready; none is blocked by an uncommitted one
  - Risks and assumptions are recorded on the iteration

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Fill in priority order and stop at capacity. Do not pull a lower item over a higher one because it is smaller unless the higher one is blocked.
- Capacity is computed, not felt. Use the team's actual completed size from recent iterations, calculated with a tool (G-02).
- Commitment is a proposal until the people doing the work agree; present it and ask.

*Requires: R-02, R-04 | Tenets: T-06, T-07, T-13*

### `/aa-pm-status`

Produce a status report for an iteration, epic, or release from the ticket system and source control, not from memory or opinion: done, in progress, blocked, at risk, and why.

**Inputs**

- The ticket system state for the scope requested
- Source control activity: branches, merge requests, and their state
- The previous status report, for what changed

**Artifacts**

- **Status report** in returned to the user; posted to the knowledge base or the iteration ticket if asked
  - Every claim traces to a ticket or a merge request
  - Blocked and at-risk items name the blocker and who owns unblocking it
  - Says what changed since the last report

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Count with a tool and quote the count. "Most tickets are done" is not status; "14 of 19 committed tickets are done, 3 in review, 2 blocked" is.
- Report the blocked item before the finished ones. The reader can act on a blocker; they cannot act on praise.
- Say what you could not see. If a system was unreachable, the report says so rather than silently omitting it.

*Requires: R-01, R-02, R-04 | Tenets: T-04, T-07*

### `/aa-pm-retrospective`

Look at what actually happened in an iteration, release, or quarter, using the record rather than recollection, and turn it into a small number of concrete improvements with owners and tickets.

**Inputs**

- Ticket system history: cycle times, carry-over, blockers, reopened tickets
- Incident and post-mortem records for the period
- Input from the people involved, where the user provides it

**Artifacts**

- **Workflow health report** in the knowledge base
  - States what the data shows before what people felt, and distinguishes the two
  - Names the top three things to keep and the top three to change
- **Process improvement backlog** in the ticket system
  - Every "change" is a ticket with an owner and a way to tell whether it worked

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-10** Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Measure first, then ask. Present the numbers before opinions so the discussion is about causes, not impressions.
- Three changes, not thirty. An improvement backlog nobody works is a complaint log.
- Check the last retrospective's changes first. If they were not done, that is the first finding.

*Requires: R-02, R-03, R-04 | Tenets: T-07, T-13 | Methodology: phase 6 step meta*

## 8. Implementation Planning

**Code:** `ip` | **Id:** `implementation-planning` | **Commands:** `/aa-ip-plan-implementation`, `/aa-ip-breakdown-tasks`

### Role

Plans how one ticket will be built before anyone builds it. Reads the scenarios, the architecture, and the code that exists, and writes a plan the ticket carries: what changes, where, in what order, with what tests, and what could go wrong.

**Owns**

- The implementation plan on the anchor ticket
- Breaking a plan into tasks when the ticket is too large to plan as one change
- Identifying risks, unknowns, and dependencies before build starts

**Does not own**

- Architecture decisions, which belong to Technical Analysis; a plan works within them
- Writing code, which belongs to Development
- Sizing for prioritisation, which belongs to Refinement; a plan may revise it

**Hands off to**

- **Development** when the plan is written and confirmed
- **Technical Analysis** when planning reveals a decision or unknown bigger than the ticket

*Tenets: T-06, T-07*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-ip-plan-implementation` | Plan an implementation | required | Implementation plan |
| `/aa-ip-breakdown-tasks` | Break a plan into tasks | required | Tasks |

### `/aa-ip-plan-implementation`

Before building a ticket, write down how: which files and components change, in what order, what tests prove each step, what could go wrong, and what is still unknown. The plan lives on the ticket and is confirmed before build starts.

**Inputs**

- The ready ticket and its scenarios
- The architecture, decision records, and technical constraints
- The current code, read, not remembered

**Artifacts**

- **Implementation plan** in the anchor ticket
  - Lists the changes in build order, each with the test that proves it
  - Names the risks and unknowns, and how each will be resolved or accepted
  - Says which tiers of test the change touches (O-07)
  - Confirmed by the user or the ticket owner before implement runs

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Read the code you will change before planning the change. A plan written from the architecture diagram alone will meet the real code and lose.
- Plan the tests with the steps. A step with no test is a step you cannot know is done.
- Prefer the plan that can be abandoned halfway. Order changes so that stopping after any step leaves the system working.
- If the plan is longer than the change, the ticket is too big; hand it back to Refinement to split.

*Requires: R-02, R-05, R-16 | Tenets: T-06, T-07*

### `/aa-ip-breakdown-tasks`

When a confirmed plan is too large to build as one change, split it into tasks on the ticket, each independently buildable and testable, with their order and dependencies.

**Inputs**

- The confirmed implementation plan

**Artifacts**

- **Tasks** in the ticket system, as children or a checklist of the anchor ticket
  - Each task maps to one or more plan steps and names its test
  - Order and dependencies are explicit
  - The sum of the tasks is the whole plan; nothing is left implicit

**Guidance**

- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- A task is done when its test passes and its change is committed, not when its code exists.
- Keep tasks at a size where the first commit is an hour away, not a day.

*Requires: R-02 | Tenets: T-07*

## 9. Development

**Code:** `dev` | **Id:** `development` | **Commands:** `/aa-dev-setup-environment`, `/aa-dev-implement`, `/aa-dev-fix-bug`, `/aa-dev-review`, `/aa-dev-finish-branch`, `/aa-dev-optimize`

### Role

Builds the software and proves it meets the requirement. Every change ships with the tests that show its scenarios pass, is reviewed, and is merged on a branch that references its ticket. Development owns "it works"; Testing owns "and here is what we did not think of".

**Owns**

- Application code, schema, migrations, and integration code for a ticket
- Proving the requirement is met, with unit tests, integration tests, and happy-path end-to-end tests for every scenario the ticket delivers (O-08, G-20)
- Code review and merge
- Defect fixes, reproduced before fixed
- Performance optimisation of existing code

**Does not own**

- Test coverage beyond the requirement (negative and edge-case end-to-end, boundaries, states, concurrency, exploratory), which belongs to Testing
- Deciding what a ticket means, which belongs to Business Analysis and Refinement
- Deploying to production, which belongs to Release Management

**Hands off to**

- **Testing** when a ticket's tests pass and the suite should be extended beyond the requirement
- **Release Management** when merged work is ready to be included in a release
- **Documentation** when a change affects user or developer documentation

*Tenets: T-04, T-05, T-07 | Opinions: O-02, O-06, O-07, O-08*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-dev-setup-environment` | Set up the development environment | required | Repository structure |
| `/aa-dev-implement` | Implement a ticket | required | Application code |
| `/aa-dev-fix-bug` | Fix a defect | required | Reproducing test |
| `/aa-dev-review` | Review code | required | Review findings |
| `/aa-dev-finish-branch` | Finish a branch | required | Merge request |
| `/aa-dev-optimize` | Optimise performance | required | Optimisation implementation report |

### `/aa-dev-setup-environment`

Make a fresh clone buildable and testable: fill in the root scripts, configure the tools the stack needs, and record anything a new developer must do by hand.

**Inputs**

- The technology stack document and constraints
- The stub root scripts from aa init, or the existing scripts
- Tech-stack plugins in scope

**Artifacts**

- **Repository structure** in the repository root
  - Follows the conventional structure or maps to it in the project config (O-05)
- **Working root scripts** in the repository root
  - initialize, build, test, and pack each run to completion on a fresh clone (O-06)
  - test accepts a tier parameter and each tier has a home (O-07)
- **Development environment configuration** in the documents folder
  - Anything not automated by initialize is written down as a step with a reason

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- Prove it on a clean clone. Clone to a temporary folder and run initialize, build, test, and pack there before calling it done.
- Automate before documenting. A manual step in the documentation is a bug in initialize until it is proven to be impossible to automate.
- Do not choose tools the project has not chosen. Use what the stack document, plugins, and existing config name; where nothing does, ask.

*Requires: R-05, R-10, R-11, R-18, R-19, R-20, R-21 | Tenets: T-01, T-07 | Opinions: O-05, O-06, O-07 | Methodology: phase 2 step 2.1*

### `/aa-dev-implement`

Build what the anchor ticket asks for, with the tests that prove it, on a branch that references the ticket, following the confirmed plan.

**Inputs**

- The anchor ticket and its scenarios in the feature files
- The confirmed implementation plan and tasks
- The current code, read before it is changed

**Artifacts**

- **Application code** in source folder, on a branch named per the ticket convention
  - Builds with the root build script
  - Every scenario for the ticket has a passing unit test, integration test, and happy-path end-to-end test, as the change warrants each tier
  - Follows the plan, or the deviation is recorded on the ticket with the reason
- **Tests that prove the requirement** in unit tests with the project; integration and happy-path end-to-end tests under tests/
  - Happy paths, general permutations, and obvious negative cases are covered (G-20)

**Guidance**

- **G-01** Always format the code for the changed files before committing, but do not format files that were not changed.
- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-09** Reference the anchor ticket in the branch name and every commit message.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-17** After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation.
- **G-20** When implementing a ticket, write the automated tests that prove it: unit and integration tests for every happy path, the general permutations and cases, and the obvious negative cases, plus a happy-path end-to-end test for each scenario. The ticket is not done until they exist and pass.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- Write the failing test for the scenario before the code that passes it. Then the code has one job.
- Commit at every green. Small commits that each pass the tests are the plan's checkpoints made real.
- When the plan meets reality and loses, stop and update the plan on the ticket before continuing. Do not improvise silently.
- Do not widen the change. Adjacent problems become tickets, not fixes on this branch.

*Requires: R-01, R-02, R-04, R-05, R-09, R-10, R-11, R-21 | Tenets: T-04, T-07 | Opinions: O-08 | Methodology: phase 2 step 2.2, 2.3, 2.4*

### `/aa-dev-fix-bug`

Reproduce a reported defect with a failing test, find the cause, fix the cause, and prove it with the test now passing, on a branch that references the ticket.

**Inputs**

- The defect ticket: symptoms, environment, steps to reproduce, severity
- The scenario the defect violates, if one exists

**Artifacts**

- **Reproducing test** in the test tier where the defect is observable
  - Fails before the fix and passes after; committed with the fix
- **Fix** in source folder, on a branch named per the ticket convention
  - Addresses the cause, not the symptom; the ticket says what the cause was
  - No existing test was weakened or skipped to make it pass

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-09** Reference the anchor ticket in the branch name and every commit message.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-17** After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- No reproduction, no fix. If it cannot be reproduced, the ticket gets what was tried and goes back for more information.
- Find the cause before touching code. Form a hypothesis, test it, and record the result on the ticket; three hypotheses without evidence means stop and reassess (G-17).
- If the defect violates no scenario, one is missing. Add it to the feature file with the fix so the requirement is now stated.

*Requires: R-01, R-02, R-04, R-05, R-11, R-16 | Tenets: T-07, T-12*

### `/aa-dev-review`

Review a merge request against its ticket, its scenarios, its plan, and the project's conventions, and record findings on the merge request where the author will see them.

**Inputs**

- The merge request and its diff
- The ticket, scenarios, and implementation plan
- The build and test results for the branch

**Artifacts**

- **Review findings** in the merge request, as comments, with a summary on the ticket
  - Each finding names the file and line, says what is wrong and why, and is marked blocking or not
  - The review states whether every scenario has a test and whether the plan was followed
  - The review says what it did not check

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- Read the ticket and scenarios before the diff. A diff reviewed without its purpose is proofread, not reviewed.
- Run it. Build and test the branch yourself; do not trust a green badge you did not see produced.
- Blocking findings are about correctness, security, and the requirement. Style is a non-blocking comment, or a formatter's job (G-01).
- Report faithfully: "approved" means every scenario has a passing test that you saw run.

*Requires: R-01, R-02, R-10, R-11 | Tenets: T-07*

### `/aa-dev-finish-branch`

Take a branch from "the tests pass" to merged: format changed files, rebase or merge from the target branch, run the full test suite, open or update the merge request linked to the ticket, and transition the ticket.

**Inputs**

- The branch and its ticket
- The project's branch, commit, and merge conventions from the project config

**Artifacts**

- **Merge request** in source control, linked from and to the ticket
  - Title and description reference the ticket and summarise the change and its tests
  - Changed files are formatted; unrelated files are untouched (G-01)
  - Full test suite passes on the branch as it will be merged
- **Ticket transition** in the ticket system
  - The ticket moves to the state the project uses for "in review" or "done", with the merge request linked

**Guidance**

- **G-01** Always format the code for the changed files before committing, but do not format files that were not changed.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-09** Reference the anchor ticket in the branch name and every commit message.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Format only what you changed. Reformatting untouched files hides the change and creates conflicts for everyone else.
- Bring the branch up to date before the final test run, and run the whole suite, not the tier you were working in.
- Never bypass a hook or a protected-branch rule. If a gate blocks, fix the cause or tell the user (G-14).
- Merge only if the project's conventions let you; otherwise open the request and stop (G-13).

*Requires: R-01, R-02, R-05, R-08, R-09, R-11 | Tenets: T-06, T-07*

### `/aa-dev-optimize`

Improve the performance of existing code against a measured baseline: profile, change the thing the profile says, measure again, and keep the change only if the measurement improved without breaking a test.

**Inputs**

- The performance ticket with the target metric and baseline from performance-test
- Profiling tools the project uses

**Artifacts**

- **Optimisation implementation report** in the anchor ticket
  - Baseline, change, and after measurement are recorded with the method used
  - The change is on a branch with all tests passing

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- No baseline, no optimisation. Measure first, with a tool, and record the number.
- Change one thing per measurement. Two changes measured together teach nothing.
- A faster wrong answer is a defect. Every optimisation runs the full suite before it is kept.

*Requires: R-01, R-02, R-04, R-05, R-11 | Tenets: T-07 | Methodology: phase 6 step 6.2*

## 10. Testing

**Code:** `qa` | **Id:** `testing` | **Commands:** `/aa-qa-test-strategy`, `/aa-qa-generate-tests`, `/aa-qa-e2e-tests`, `/aa-qa-performance-test`, `/aa-qa-explore`

### Role

Makes the test suite as comprehensive as is reasonable. Starts from the scenarios and the tests Development wrote, then applies general testing strategies to find what the requirement did not say. Every gap it finds becomes a question on the ticket and a scenario in the feature file.

**Owns**

- The test strategy for an epic or release
- Tests beyond the stated requirement at every tier: boundaries, states, errors, concurrency, interaction sequences (G-21)
- End-to-end and visual regression suites
- Performance and load testing and the baseline it establishes
- Exploratory testing and the defects and gaps it raises

**Does not own**

- The unit, integration, and happy-path end-to-end tests that prove a ticket meets its requirement, which belong to Development
- Fixing defects, which belongs to Development via tickets
- Security testing, which belongs to Security
- Production validation, which belongs to Operations

**Hands off to**

- **Business Analysis** when a gap is a missing requirement rather than a missing test
- **Development** when a defect is found
- **Release Management** when the suite passes and coverage is judged sufficient for a release

*Tenets: T-07, T-12 | Opinions: O-01, O-07, O-08*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-qa-test-strategy` | Write a test strategy | required | Test strategy |
| `/aa-qa-generate-tests` | Extend the test suite | required | Extended test suite |
| `/aa-qa-e2e-tests` | Build end-to-end tests | required | End-to-end test suite |
| `/aa-qa-performance-test` | Performance and load test | required | Performance test suite |
| `/aa-qa-explore` | Exploratory testing | required | Session notes |

### `/aa-qa-test-strategy`

For an epic or release, decide what will be tested at which tier, what will be automated, what needs exploratory or manual attention, what environments and data are needed, and what will not be tested and why.

**Inputs**

- The feature files and architecture for the scope
- The risk view from Security and Technical Analysis
- Existing suites and their coverage

**Artifacts**

- **Test strategy** in the knowledge base, linked from the epic
  - Every scenario is assigned a tier and an approach
  - Risks are ranked and the highest have the most attention
  - Out-of-scope items are listed with the reason

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Push tests down. Prove it at the lowest tier that can observe it; end-to-end tests are for what only end-to-end can see.
- Name the risks the requirement does not mention. Concurrency, data volume, partial failure, and permissions rarely appear in scenarios and usually appear in incidents.

*Requires: R-02, R-03, R-16 | Tenets: T-07*

### `/aa-qa-generate-tests`

Start from the scenarios and the tests Development wrote, then apply general testing strategies to find and test what the requirement did not say. Every gap becomes a question on the ticket and a scenario in the feature file.

**Inputs**

- The ticket's scenarios and the tests already written for them
- The test strategy for the epic
- The built code, read for branches and states the scenarios do not mention

**Artifacts**

- **Extended test suite** in unit tests with the project; integration and e2e under tests/
  - Adds tests for boundaries, state transitions, error and recovery paths, concurrency, and realistic interaction sequences where relevant
  - Does not duplicate Development's tests
- **Gaps as scenarios and questions** in the features folder and the anchor ticket
  - Every behaviour found that the requirement did not specify is a question on the ticket and a pending scenario in the feature file

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-07** Write business-facing behaviour as Gherkin scenarios in the features folder before the change, and technical behaviour as executable tests alongside it.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- Read Development's tests first and say what they cover. Your job starts where theirs stops.
- Test the seams. The boundaries between components, between tiers, and between the system and its dependencies are where the requirement was vaguest.
- A pending scenario is a real scenario with a tag saying it awaits an answer. Do not leave gaps as comments in test code.

*Requires: R-02, R-11, R-16, R-21 | Tenets: T-07, T-12 | Opinions: O-08 | Methodology: phase 3 step 3.1*

### `/aa-qa-e2e-tests`

Automate the scenarios that can only be proven through the whole system as the user sees it, and where a user interface exists, the visual regression suite that catches what functional tests cannot.

**Inputs**

- The scenarios assigned to the end-to-end tier by the strategy
- The deployed or locally running system and its test environment
- The project's end-to-end and visual testing tool categories

**Artifacts**

- **End-to-end test suite** in tests/e2e
  - Runs from the root test script with the e2e tier
  - Each test maps to a scenario by tag; flaky tests are quarantined with a ticket, not retried into green
- **Visual regression suite** in tests/e2e
  - Baselines are versioned and reviewed when they change

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- Drive the system the way a user does, through its real entry points; do not reach into internals to make a test pass.
- Own the test data. Every end-to-end test creates what it needs and cleans up; a test that depends on leftover state will lie eventually.
- A flaky test is a defect in the test or the system. Quarantine it with a ticket; never wrap it in a retry to hide it (G-06).

*Requires: R-02, R-11, R-16, R-21 | Tenets: T-07 | Methodology: phase 3 step 3.2*

### `/aa-qa-performance-test`

Establish how the system behaves under expected and peak load against stated targets, record the baseline, and raise tickets where targets are missed.

**Inputs**

- Performance targets from the technical constraints and scenarios
- A production-like environment and the project's load testing tool category

**Artifacts**

- **Performance test suite** in tests/e2e or the location the project config names for performance tests
  - Reproducible: environment, data volume, and load profile are recorded with the suite
- **Performance baseline report** in the knowledge base, linked from the ticket
  - Reports each target with the measured value, the method, and pass or fail
  - Every miss is a ticket with the measured gap

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- No target, no test. If the requirement has no number, get one from the ticket owner before running anything; "fast" is not a target.
- Measure with a tool and report the distribution, not the average. The slowest 5 percent is what users complain about.
- Record the environment with the result. A number without the machine, data volume, and load profile cannot be compared to anything later.

*Requires: R-02, R-03, R-04, R-11 | Tenets: T-07 | Methodology: phase 3 step 3.3*

### `/aa-qa-explore`

A time-boxed session using the system with a charter and a testing lens (boundaries, states, errors, interruptions, roles), recording every surprise as a defect, a question, or a new scenario.

**Inputs**

- A charter: what area, what lens, what time box
- The running system and its scenarios

**Artifacts**

- **Session notes** in the anchor ticket
  - Records what was tried, what surprised, and what was concluded
  - Every surprise is a ticket, a question, or a pending scenario

**Guidance**

- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- Follow the charter until the time box, then follow the most interesting surprise. Both halves matter.
- Interrupt things. Cancel midway, lose the connection, double-submit, go back; the scenarios almost never say what should happen.

*Requires: R-02, R-16 | Tenets: T-07*

## 11. Documentation

**Code:** `doc` | **Id:** `documentation` | **Commands:** `/aa-doc-document-feature`, `/aa-doc-maintain-docs`

### Role

Keeps what is written true. Documents each feature for the people who will use and maintain it, keeps the knowledge base aligned with the feature files and the code, and periodically audits the whole for drift.

**Owns**

- User-facing and developer-facing documentation for a feature
- The knowledge base pages that back feature files, and their alignment (T-12)
- Documentation health audits and the tickets they raise

**Does not own**

- Decision records, which belong to Technical Analysis
- Requirements, which belong to Business Analysis; Documentation explains, never defines
- Release notes, which belong to Release Management

**Hands off to**

- **Business Analysis** when documenting reveals a requirement that is unclear or contradicted
- **Development** when documentation reveals a defect

*Tenets: T-04, T-12, T-13 | Opinions: O-04*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-doc-document-feature` | Document a feature | required | Feature documentation |
| `/aa-doc-maintain-docs` | Maintain documentation | required | Up-to-date documentation |

### `/aa-doc-document-feature`

Write or update the user-facing and developer-facing documentation for a ticket, from its scenarios and its implementation, in the places the project keeps each kind.

**Inputs**

- The ticket, its scenarios, and the merged change
- The project's documentation locations from the config or knowledge base

**Artifacts**

- **Feature documentation** in the documents folder for developer docs; the knowledge base or the project's user documentation location for user docs
  - A user can do what the scenarios describe by following the user documentation
  - A developer can find where the feature lives and how it is tested from the developer documentation
  - Linked from the ticket and the feature's knowledge base page

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Write from the scenarios, verify against the software. The scenarios say what should happen; run the feature to confirm the documentation is describing what does.
- Document the unhappy path. Users read documentation when something went wrong.
- Never duplicate a scenario in prose. Link to it, or embed it; two copies drift.

*Requires: R-02, R-03, R-06, R-16 | Tenets: T-12, T-13*

### `/aa-doc-maintain-docs`

Audit the documentation and knowledge base for drift from the feature files and the code, fix what is wrong, and raise tickets for what needs an owner. Recurring; each run anchors on a maintenance ticket.

**Inputs**

- The feature files, the knowledge base, and the documents folder
- Changes merged since the last audit

**Artifacts**

- **Up-to-date documentation** in wherever it lives; changes on a branch linked to the ticket
  - Every feature file has a knowledge base page that matches it (T-12)
  - No documented behaviour contradicts a scenario or the running software
- **Documentation health report** in the knowledge base
  - Lists what was checked, what was fixed, and what is ticketed for someone else

**Guidance**

- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Start from the feature files and walk outward. They are the truth; every page and document is checked against them, never the reverse.
- Delete confidently. Documentation for something that no longer exists is worse than none; remove it and say so in the report.
- A contradiction between a page and a scenario is a conflict to surface, not a page to quietly fix (T-12).

*Requires: R-02, R-03, R-06, R-16 | Tenets: T-12 | Methodology: phase 6 step 6.5*

## 12. Release Management

**Code:** `rel` | **Id:** `release-management` | **Commands:** `/aa-rel-prepare-release`, `/aa-rel-release`, `/aa-rel-rollback`

### Role

Gets built, tested software into production deliberately and gets it back out if it must. Owns the version, the release notes, the go/no-go decision, the production deployment record, and rollback. Release Management never asks what to release; it asks whether it is ready.

**Owns**

- Versioning and the release notes generated from tickets and commits
- The change record and go/no-go checklist for a release
- Production deployment and its verification record
- Rollback and its record

**Does not own**

- The pipeline and infrastructure that perform the deployment, which belong to Operations
- Deciding scope, which belongs to Product Management
- Post-release monitoring, which belongs to Operations and Support

**Hands off to**

- **Operations** when a release is verified and enters routine monitoring
- **Support** when a release causes an incident
- **Product Management** when release notes and outcomes feed the roadmap

*Tenets: T-06, T-07 | Opinions: O-02, O-06*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-rel-prepare-release` | Prepare a release | required | Version and release notes |
| `/aa-rel-release` | Release to production | required | Production deployment record |
| `/aa-rel-rollback` | Roll back a release | required | Rollback record |

### `/aa-rel-prepare-release`

Assemble a release: decide the version, generate release notes from the tickets and commits since the last release, write the change record, and run the go/no-go checklist. Produces everything needed to say "ready" or "not yet".

**Inputs**

- Merged changes and their tickets since the last release tag
- Test results across all tiers, security test results, and UAT results
- The project's versioning and release conventions

**Artifacts**

- **Version and release notes** in source control as a tag and notes file; the ticket system as the release; the knowledge base
  - Version follows the project's scheme and is justified by the changes
  - Every included ticket appears in the notes; nothing appears that is not included
  - Written for the audience the project names: users, operators, or both
- **Change record and go/no-go checklist** in the release ticket
  - Every checklist item has evidence linked or is marked not applicable with a reason
  - The decision and who made it are recorded

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Generate the notes from the record, then edit for the reader. Tickets and commits say what changed; a person says what it means.
- Never mark a checklist item done on someone's word. Link the test run, the approval, the scan.
- A release with an unexplained change in it is not ready. Every commit since the last tag traces to a ticket or gets one.

*Requires: R-01, R-02, R-03, R-04, R-05, R-11, R-20 | Tenets: T-06, T-07*

### `/aa-rel-release`

Deploy a prepared release to production using the pipeline Operations provides, verify it did what the release notes say, and record the deployment. Stops and asks before the irreversible step.

**Inputs**

- The prepared release with a "go" decision
- The deployment pipeline and runbook from Operations
- The verification checks defined in the release

**Artifacts**

- **Production deployment record** in the release ticket and the knowledge base
  - Records what was deployed, when, by whom, with which pipeline run
- **Deployment verification report** in the release ticket
  - Every verification check has a result; any failure triggers rollback or an incident, recorded

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Ask before you deploy, every time, unless the user granted this deployment in advance. Production is the irreversible step (G-13).
- Use the pipeline, not your hands. A deployment done outside the pipeline is unrecorded and unrepeatable.
- Verify before you announce. The release is not done when the pipeline is green; it is done when the checks pass in production.
- If verification fails, the default is rollback, not investigation in production.

*Requires: R-01, R-02, R-20 | Tenets: T-06, T-07 | Methodology: phase 4 step 4.3*

### `/aa-rel-rollback`

Return production to the previous known-good release using the pipeline, verify it, record what was rolled back and why, and hand the cause to Support or Development.

**Inputs**

- The release to roll back and the previous known-good release
- The rollback runbook from Operations
- The incident or verification failure that triggered it

**Artifacts**

- **Rollback record** in the release ticket and the incident, if any
  - Records what was reverted to, when, by whom, and the trigger
  - Verification after rollback is recorded
  - A ticket exists for the cause

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Roll back first, understand later. The goal is to restore service; the cause is a ticket.
- Confirm the rollback target is actually known-good, not just previous. Check its verification record.
- Data changes may not roll back with code. Say so explicitly and involve Operations before proceeding.

*Requires: R-01, R-02, R-20 | Tenets: T-06, T-07*

## 13. Operations

**Code:** `ops` | **Id:** `operations` | **Commands:** `/aa-ops-setup-infrastructure`, `/aa-ops-setup-pipeline`, `/aa-ops-observability`, `/aa-ops-validate-production`

### Role

Provides and runs the environments the software lives in. Infrastructure as code, the pipeline that delivers to it, the observability that shows what it is doing, and the validation that production behaves as the release claimed.

**Owns**

- Infrastructure as code and deployment runbooks
- The delivery pipeline and deployment strategy
- Monitoring, dashboards, alerting, and the observability requirements on the code
- Production validation after a release

**Does not own**

- The decision to deploy, which belongs to Release Management
- Incident triage and response, which belong to Support; Operations acts on their requests
- Application code changes, which belong to Development

**Hands off to**

- **Support** when monitoring detects an incident
- **Development** when validation or observability reveals a defect
- **Security** when an infrastructure control needs a security requirement clarified

*Tenets: T-01, T-07 | Opinions: O-06*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-ops-setup-infrastructure` | Set up infrastructure | required | Infrastructure code |
| `/aa-ops-setup-pipeline` | Set up the delivery pipeline | required | Deployment pipeline configuration |
| `/aa-ops-observability` | Set up observability | required | Monitoring dashboards |
| `/aa-ops-validate-production` | Validate production | required | Production validation results |

### `/aa-ops-setup-infrastructure`

Define the environments the system runs in as code, with runbooks for the operations that are not automated, meeting the constraints from architecture and the controls from security.

**Inputs**

- The architecture, technical constraints, and security requirements
- The organisation's platform standards from the enterprise scope
- The project's infrastructure tooling category

**Artifacts**

- **Infrastructure code** in the source folder, as its own project, on a branch linked to the ticket
  - Every environment is reproducible from the code with no manual steps beyond the runbook
  - Security controls from the threat model are implemented or ticketed
- **Deployment runbooks** in the documents folder
  - Every manual operation has a runbook with preconditions, steps, verification, and rollback

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- Everything as code, reviewed and tested like code. An environment changed by hand is an environment nobody can rebuild.
- Least privilege by default. Every credential, role, and network path is the narrowest that works, and widening one is a decision record.
- Ask before creating anything that costs money or is hard to delete.

*Requires: R-01, R-02, R-05, R-06 | Tenets: T-01, T-06, T-07 | Methodology: phase 4 step 4.1*

### `/aa-ops-setup-pipeline`

Build the pipeline that takes a merged change to production: build, every test tier, security checks, packaging, deployment per environment, and the deployment strategy that makes a release safe to ship and to roll back.

**Inputs**

- The root scripts (build, test, pack) and the infrastructure code
- The release and deployment conventions
- The project's pipeline tooling category

**Artifacts**

- **Deployment pipeline configuration** in the repository, in the location the pipeline tool expects
  - Calls the root scripts rather than duplicating their logic (O-06)
  - Runs every test tier and fails on any failure; no skipped stages without a recorded reason
  - Deploys to each environment with the same artifact
- **Deployment strategy documentation** in the documents folder
  - States the strategy (for example staged, canary, blue-green) and how rollback works for it

**Guidance**

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-08** One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- The pipeline calls the scripts; the scripts do the work. Logic in pipeline configuration cannot be run locally and will drift.
- One artifact, promoted. Build once, deploy the same artifact everywhere; never rebuild for production.
- A pipeline that can be bypassed is not a pipeline. Protect the branches it deploys from.

*Requires: R-01, R-02, R-05, R-10, R-11, R-20 | Tenets: T-07, T-09 | Opinions: O-06 | Methodology: phase 4 step 4.2*

### `/aa-ops-observability`

Make the running system visible: the dashboards, alerts, logs, and traces that show whether the scenarios are being met in production, and the requirements on the code to emit them.

**Inputs**

- The scenarios, for what "working" means
- The architecture, for where signals come from
- The project's observability tooling category

**Artifacts**

- **Monitoring dashboards** in the observability tool, linked from the knowledge base
  - Show the outcome metrics from define-outcome and the health of each component
- **Alert configuration** in as code in the repository where the tool allows; otherwise documented
  - Every alert has a runbook, an owner, and a threshold with a reason
  - No alert fires that nobody acts on

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-11** Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Alert on what users feel, not on what machines do. Latency and error rate at the edge before CPU in the middle.
- Every alert has a runbook or it is noise. Write the runbook before enabling the alert.
- Observability is a requirement on the code. If a scenario cannot be observed in production, raise a ticket for the signal.

*Requires: R-01, R-02, R-03, R-05 | Tenets: T-07 | Methodology: phase 5 step 5.1*

### `/aa-ops-validate-production`

After a release, confirm from production evidence that the system is doing what the release claimed: run the production validation checks, compare metrics to the baseline, and report.

**Inputs**

- The release, its verification checks, and its notes
- Dashboards, metrics, and logs since the release
- The performance baseline

**Artifacts**

- **Production validation results** in the release ticket
  - Every check has a result with evidence
- **Production metrics report** in the knowledge base
  - Compares key metrics before and after, computed with a tool, with any regression ticketed

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Compare, do not glance. Compute before-and-after for each metric over a stated window; a dashboard that "looks fine" is not evidence.
- Validation is read-only. Never change production to make a check pass; a failing check is an incident or a rollback.

*Requires: R-02, R-03, R-04 | Tenets: T-07, T-10 | Methodology: phase 5 step 5.3*

## 14. Support

**Code:** `sup` | **Id:** `support` | **Commands:** `/aa-sup-triage`, `/aa-sup-respond-incident`, `/aa-sup-postmortem`

### Role

Is the front door for what goes wrong in production. Triages incoming incidents and requests into tickets with the right priority, coordinates response until the impact is contained, and runs the post-incident review that turns an incident into prevention.

**Owns**

- Incident and request intake, triage, and prioritisation
- Incident response coordination, timeline, and mitigation until resolved
- Post-incident review and the prevention tickets it raises
- User-facing follow-up

**Does not own**

- Fixing the root cause, which belongs to Development
- Infrastructure changes, which belong to Operations
- Deciding whether a request becomes a feature, which belongs to Product Management

**Hands off to**

- **Development** when an incident's root cause is a defect
- **Operations** when mitigation needs an infrastructure or configuration change
- **Release Management** when mitigation is a rollback
- **Product Management** when a request is a feature, not a defect

*Tenets: T-04, T-07, T-13 | Opinions: O-03, O-04*

### Commands

| Command | Step | Anchor | Primary artifact |
|---------|------|--------|------------------|
| `/aa-sup-triage` | Triage | optional | Triaged ticket |
| `/aa-sup-respond-incident` | Respond to an incident | required | Incident timeline |
| `/aa-sup-postmortem` | Post-incident review | required | Post-incident review |

### `/aa-sup-triage`

Take an incoming incident, defect report, or request and turn it into a ticket with the right type, severity, priority, and owner, or link it to the existing ticket it duplicates.

**Inputs**

- The incoming report from whatever channel the project uses
- Existing open tickets and known issues
- The project's severity and priority definitions

**Artifacts**

- **Triaged ticket** in the ticket system
  - Has a type, severity, priority, and owner, each per the project's definitions
  - Has enough to act on: environment, steps, expected, actual, impact
  - Duplicates are linked, not created

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Severity is impact, priority is order. Do not let a loud reporter set either.
- Ask for what is missing once, precisely. A ticket that cannot be reproduced from its content goes back with the exact questions.
- Check for duplicates before creating. Search by symptom, not by the reporter's title.

*Requires: R-02 | Tenets: T-04, T-13 | Methodology: phase 6 step 6.1*

### `/aa-sup-respond-incident`

Coordinate an active incident: keep a timeline, contain the impact, pull in Operations, Development, or Release Management as needed, communicate status, and close the incident when service is restored.

**Inputs**

- The incident ticket with severity and current impact
- Dashboards and alerts from observability
- Runbooks and the rollback option

**Artifacts**

- **Incident timeline** in the incident ticket
  - Every action and observation is timestamped as it happens
  - Communications sent are recorded with their audience
- **Mitigation** in the incident ticket, with links to any rollback or change
  - Service is restored, verified with evidence, and the ticket says how
  - A post-incident review is scheduled

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Contain first, diagnose second. Rollback, feature flag, or scale before root cause.
- Write the timeline as you go. A timeline reconstructed afterwards is fiction with timestamps.
- Say what you know and what you do not, at a stated cadence. Silence during an incident is the worst status update.

*Requires: R-02, R-03 | Tenets: T-06, T-07*

### `/aa-sup-postmortem`

After an incident is closed, review what happened using the timeline and the evidence, find the contributing causes without blame, and raise the tickets that will prevent recurrence or shorten the next response.

**Inputs**

- The incident timeline and mitigation record
- Related tickets, releases, and changes

**Artifacts**

- **Post-incident review** in the knowledge base, linked from the incident
  - States impact, detection time, response time, and time to restore, computed from the timeline
  - Lists contributing causes; names systems and decisions, not people
- **Prevention tickets** in the ticket system
  - Every action item is a ticket with an owner; the review links them

**Guidance**

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-10** Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket.
- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- Compute the times from the timeline with a tool; do not estimate them.
- Ask "what made this reasonable at the time" for every decision in the timeline. Blame finds a person; this finds a cause.
- Prefer one action that removes the cause over five that add checks around it.

*Requires: R-02, R-03, R-04 | Tenets: T-07*


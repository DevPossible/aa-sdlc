# AA-SDLC Opinions

**Status:** working draft. Last updated 2026-09-21.

The framework is opinionated, and we say so up front. An opinion is a deliberate stance the
framework takes where reasonable alternatives exist, chosen so that every project using the
framework does it the same way (T-08). Tenets say how the framework is designed; guidance says
how a step is done; an opinion says which of several defensible options the framework picks, and
why.

If you disagree with an opinion, the framework is probably not for you, and we would rather you
know that before `aa setup` than after. Opinions are few. Each has a stable ID, states the
alternatives it rejects, and says what would change the framework's mind.

---

**O-01 Requirements are written in Gherkin.**
*The stance:* every requirement lives in the repository as a scenario in a feature file, and
those feature files are the source of truth for what the software must do (T-12).
*Why:* Gherkin is structured natural language. Stakeholders can read it, agents process it
without translation, and it executes as a test with no second artifact. One format serves the
business analyst, the developer, the tester, and the model.
*Rejected:* prose requirements documents (drift from the code and cannot execute); acceptance
criteria held only in tickets (no history, no review, not in the repository); user stories as
the unit of truth (a story is a promise to have a conversation, not a specification).
*Would change our mind:* a structured natural-language format with equal or better executor
support across stacks and equal readability for non-technical stakeholders.
*Requirements:* R-16, R-17.

**O-02 All good development uses source control.**
*The stance:* every project is under source control from its first file, with a remote, and
source control is the only output that counts (T-04). Work that is not committed did not happen.
*Why:* history, review, revert, and collaboration all depend on it, and every practice in the
Development discipline assumes it. There is no serious alternative in 2026.
*Rejected:* shared folders, versioned zip files, "I will commit it when it is done."
*Would change our mind:* nothing foreseeable.
*Requirements:* R-01, R-05.

**O-03 All good projects use a ticket manager.**
*The stance:* every unit of work anchors on a ticket, and the ticket system is the state store
for the process (T-04). Every step reads its context from the ticket and writes its outcome back.
*Why:* a ticket gives work an owner, a history, a place to record outcomes, and a link between
requirement, code, and release. An agent with no ticket has no memory of why it is doing what it
is doing. The framework owns no state of its own precisely because the ticket system already
holds it.
*Rejected:* to-do lists in documents; task tracking in chat; tickets as an afterthought created
when work is finished; process state held in files the framework owns.
*Would change our mind:* nothing foreseeable. The framework degrades gracefully without a
ticket system (T-05) but does not consider that a supported way to work.
*Requirements:* R-02, R-08.

**O-04 All projects need a knowledge repository.**
*The stance:* every project has a wiki or notes system that the agent can read and write, and it
is the memory for decisions, rationale, and explanation (T-04). Tickets say what happened;
the knowledge repository says why.
*Why:* decisions made in a conversation are lost when the conversation ends. Code shows what
was built, not what was considered and rejected. A project without a knowledge repository
repeats its own mistakes, and an agent joining it has nothing to read.
*Rejected:* knowledge held only in people's heads; decisions recorded only in ticket comments;
a documents folder as the sole store (acceptable as a fallback per R-06, not as the design).
*Would change our mind:* nothing foreseeable.
*Requirements:* R-03, R-06.

**O-05 All repositories share one folder structure, whatever they contain.**
*The stance:* every repository uses the same top-level layout regardless of stack or purpose: a
documents folder, a features folder, a scripts folder, a source folder with one subfolder per
project, a tests folder, and root scripts. A single-file utility and a polyglot monorepo look the
same from the root.
*Why:* an agent, a new team member, and the tooling should be able to find things without
reading a README. Consistency is the product (T-08), and it starts at the repository root.
Stack-specific layout lives inside each project's own subfolder, where the stack's tooling
expects it.
*Rejected:* per-stack root layouts (a Node root, a .NET root, a Python root); letting the first
contributor's habits define the structure; stack templates that own the root.
*Would change our mind:* a stack whose tooling cannot be made to work from a subfolder. None
found so far.
*Requirements:* R-18.

**O-06 Every repository has root scripts for initialize, build, test, and pack.**
*The stance:* four scripts at the repository root, in the shell the project chooses, with the
same names everywhere: `initialize` (bootstrap the environment and seed data as needed),
`build`, `test`, and `pack`. Each takes general parameters for filtering and conditional
switches as the project needs, such as a test tier, a project filter, or a configuration.
*Why:* the agent and the pipeline need one way to do each thing that works on a fresh clone.
The scripts are the contract between the repository and everything that runs it; what they call
underneath is the project's business. This is what makes "a single build command" (R-10) and "a
single test command" (R-11) true for every repository, not just the ones that happen to have
them.
*Rejected:* build instructions in a README; per-stack commands the caller must know; IDE-only
builds; scripts that assume tools are already installed.
*Would change our mind:* nothing foreseeable. The shell is the project's choice; the verbs and
their presence are not.
*Requirements:* R-10, R-11, R-19, R-20.

**O-07 Every repository has unit, integration, and end-to-end tests.**
*The stance:* three tiers, each with a home in the repository and each selectable from the root
test script. Unit tests live with the project they test, integration and end-to-end tests live
in the tests folder. A tier may be nearly empty for a small repository; it may not be absent.
*Why:* each tier catches what the others cannot. Unit tests prove logic, integration tests prove
the pieces fit, end-to-end tests prove the user gets what the feature file promised. A repository
missing a tier has a class of defect it cannot see, and an agent working in it has no way to
prove that class of change.
*Rejected:* unit tests only; end-to-end tests only; tests that exist but cannot be run by tier.
*Would change our mind:* nothing foreseeable.
*Requirements:* R-11, R-21.

**O-08 Development proves the requirement; Testing goes beyond it.**
*The stance:* the Development discipline is responsible for the automated tests that show a
requirement is met: every happy path, the general permutations and cases, and the obvious
negative tests, across unit, integration, and end-to-end tiers as the change warrants. A ticket
is not done until those exist and pass; they are part of meeting the requirement, not a separate
task. The Testing discipline is responsible for making the suite as comprehensive as is
reasonable: starting from the feature files, then applying general testing strategies to find
what the requirement did not say, including gaps in understanding and in how users actually
interact with the system. Every gap Testing finds becomes a question on the ticket and a new
scenario in the feature file.
*Why:* a developer who does not write the tests does not know if the code works. A tester who
only checks the stated requirement finds only the defects someone already imagined. Splitting the
responsibility this way gives each discipline a job the other cannot do, and keeps "done" honest
(T-07).
*Rejected:* throwing code over the wall to a test team; a test team that only automates the
acceptance criteria; treating tests as a phase after development rather than part of it.
*Would change our mind:* nothing foreseeable.
*Requirements:* R-11, R-16, R-21. *Guidance:* G-20, G-21.

---

Opinions O-02, O-03, and O-04 name the three systems the framework builds on. Together with
O-01 they define what the framework treats as the truth for each kind of information:

| Kind of information | Source of truth |
|---------------------|-----------------|
| What the software must do | feature files in the repository (O-01) |
| What was built | source control (O-02) |
| What is happening, and what happened | the ticket system (O-03) |
| Why, and what was decided | the knowledge repository (O-04) |

The tooling keeps the links between them current (T-12). No one of them holds another's truth.

Opinions O-05, O-06, and O-07 describe the shape of every repository, and O-08 describes who
proves what. Together they are what `aa init` lays down and `/aa-health` checks for.

## Candidates

- **Decisions are recorded as decision records.** Short, numbered, immutable once accepted, in
  the knowledge repository or the documents folder. Widely held already; likely to be promoted.
- **One ticket per branch, one concern per commit.** Currently guidance G-08; may be an opinion
  since branching models are a real choice.
- **Commit messages follow a conventional, machine-readable format.** Enables release notes and
  versioning from history. Not yet discussed.

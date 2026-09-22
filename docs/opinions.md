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
requirement is met: unit tests and integration tests covering every happy path, the general
permutations and cases, and the obvious negative tests, plus a happy-path end-to-end test for
each scenario. A ticket
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

**O-09 One repository, one ticket project.**
*The stance:* every repository maps to exactly one ticket system project (or group, whatever
the system calls its unit of ownership). Many repositories may point at the same project; a
single repository never manages tickets across two. The mapping is recorded once, in the
project config, and every step anchors within it.
*Why:* the ticket system is the state store (O-03), and a state store split across two projects
has two truths. One mapping per repository means every ticket id resolves without a qualifier,
every branch and commit reference is unambiguous, `aa init` can write the mapping and
`/aa-fw-health` can check it, and a step never has to ask which project it is working in.
Work that spans repositories is coordinated by tickets that link to each other, not by one
repository reaching into another project.
*Rejected:* per-branch or per-folder ticket projects; a repository with tickets in several
projects "depending on the team"; unqualified ticket ids that the agent must disambiguate;
recording the mapping anywhere but the project config.
*Would change our mind:* nothing foreseeable. A monorepo whose subfolders genuinely belong to
different products should be split, or should treat the ticket project as the product's and
link outward.
*Requirements:* R-02, R-07, R-22. *Guidance:* G-27.

**O-10 A size is grounded in implementation thinking.**
*The stance:* no unit of work carries a size or an effort estimate that is not backed by
written thought about how it will be built: which parts change, what is unknown, what could go
wrong. The depth matches the stakes. A sentence is enough for a small change; a large or risky
one warrants a full implementation plan. Whatever the depth, the reasoning is on the ticket and
the size cites it. The framework does not say when this thinking happens or who does it
(T-03, T-13); it says that a number without it is a guess, given as a labelled range if it must
be given at all, and never recorded as the size or used to commit an iteration.
*Why:* an estimate made from a title or a description measures how the work sounds, not what
it involves. You cannot size what you have not thought about building, and the act of writing
down even a few lines of how surfaces the unknowns that make the difference between a small
ticket and a large one. Agents make this worse, not better: shown a title, they produce a
confident number instantly. Grounding every size in recorded reasoning makes it traceable to
evidence (T-07), lets iteration capacity be computed from real completions (G-02), and gives
the eventual implementation plan something to check the size against.
*Rejected:* sizing a story from its title and description; relative sizing against "similar"
tickets whose own sizes had no reasoning behind them; committing an epic to a date before
anyone has thought about how its stories will be built; recording an ungrounded number "to be
refined later"; demanding a full implementation plan for every ticket before it may be sized.
*Would change our mind:* evidence that ungrounded estimates match grounded ones in accuracy
over a sustained period. Rough, labelled ranges for early prioritisation remain acceptable
precisely because they are not recorded as sizes.
*Requirements:* R-02, R-23. *Guidance:* G-28.

**O-11 Every pipeline step runs locally, exactly.**
*The stance:* every step the delivery pipeline performs can be reproduced exactly, on the
machine of whoever needs it, from the command line or a local tool, with the same script, the
same arguments, and the same inputs. The pipeline configuration calls scripts and commands that
live in the repository; it never holds logic of its own. A step that exists only in the
pipeline is a defect.
*Why:* when a pipeline step fails, whoever must fix it needs to run that step, see the same
failure, change something, and run it again. If the step lives only in the pipeline, the only
way to try a fix is to push and wait, and the only people who can look inside are those with
access to the pipeline system. That turns every pipeline failure into a queue and a dependency
on someone else, which the framework does not accept (T-13). Steps that run locally are also
steps an agent can run, observe, and quote (T-07), which is what makes "prove it before you
say it is done" possible for the delivery path and not just for the code.
*Rejected:* logic written in pipeline configuration; steps that depend on state, secrets, or
tools present only on the pipeline runner without a local equivalent; "it only fails in the
pipeline" accepted as a category of problem; debugging by pushing commits.
*Would change our mind:* nothing foreseeable. A step that genuinely cannot run locally (a
signing key held in hardware, a production-only gate) is recorded as such, with a local
stand-in that exercises everything up to the point of difference.
*Requirements:* R-10, R-11, R-20, R-24. *Guidance:* G-29.

**O-12 End-to-end tests run against containers.**
*The stance:* the end-to-end tier starts the system and its dependencies in containers, from
definitions committed to the repository, wherever the stack allows. The same definitions serve
the developer's machine and the pipeline, so the e2e tier is one command everywhere (O-06) and
the environment it runs in is part of the repository, not something that must be arranged.
*Why:* end-to-end tests are only as trustworthy as the environment they run in. A shared test
environment is owned by someone else, changed by someone else, and busy when you need it; a
test that passes there and fails locally, or the reverse, proves nothing. Containers make the
environment a build artifact: reproducible from a clean clone, disposable after the run, and
identical in the pipeline (O-11). They also make the happy-path end-to-end tests Development
owes for every scenario (O-08) something a developer can run before pushing rather than after.
*Rejected:* a shared, long-lived test environment as the default target for the e2e tier;
mocking every dependency in end-to-end tests, which makes them integration tests with a longer
name; end-to-end tests that can only run in the pipeline; environments assembled by hand from a
wiki page.
*Would change our mind:* a dependency that cannot be containerised or faithfully stood in for
is recorded as such and reached in a shared environment, and the tests that need it are marked.
That is the exception the stance already allows; a stack where it is the rule would be a reason
to revisit.
*Requirements:* R-11, R-21, R-25, R-26. *Guidance:* G-30.

**O-13 A refined ticket is checked against the repository before work starts.**
*The stance:* refinement has a shelf life. A ticket records the repository revision its
scenarios and its plan were checked against, and no work starts on it until someone has
compared that revision with the repository as it is now: what changed in the feature files
the ticket links, and in the code the plan names, and whether the requirement and the plan
still hold. The result is recorded on the ticket. A conflict goes back to refinement as a
question; it is never absorbed silently, and work never starts on it without saying so. The
framework does not gate on this (T-03); the step that picks the ticket up performs the check
as its first act, the way it reads the ticket first (G-22).
*Why:* a ticket is refined against the repository of that day. Between then and the day it is
picked up, other tickets merge, feature files change, and the code the plan named may no
longer exist. The scenarios and the plan on the ticket do not know this; they read exactly as
they did. An agent or a person who starts from them builds against a repository that is gone,
and discovers it either mid-change or in review. Agents are especially exposed: they take the
plan on the ticket as true and execute it faithfully. Recording the revision makes the check
mechanical and cheap; a diff between two points, filtered to what the ticket touches. It is
T-12 applied over time: a change that reaches the ticket only by the repository moving is
surfaced as a conflict, not silently absorbed.
*Rejected:* treating "ready" as a permanent state; starting from the plan without reading the
repository it was written against; discovering drift in code review; re-refining every ticket
before every iteration regardless of whether anything it touches changed.
*Would change our mind:* nothing foreseeable. A repository where nothing merges between
refinement and start passes the check trivially and pays nothing for it.
*Requirements:* R-01, R-02, R-05, R-16, R-27. *Guidance:* G-31, G-32.

**O-14 Commit messages are Conventional Commits.**
*The stance:* every commit in a source code repository is written in the Conventional Commits
form: a type from the project's list, an optional scope, an imperative subject, a body that
says why, and footers that carry the ticket reference and any breaking change. The project
config names the allowed types and scopes; `aa init` writes the default set. One concern per
commit (G-08) is what makes the type honest: a commit that cannot name its type is two commits.
*Why:* the history becomes data. Release notes are generated by grouping commits by type and
ticket, the version bump is derived from the types since the last tag, and a breaking change is
declared at the commit that makes it rather than discovered by a consumer. An agent reading the
history can tell a fix from a refactor from a feature without reading every diff, and can write
a message the tooling will accept without being told the house style. The cost is a prefix.
*Rejected:* free-text commit messages; per-team or per-repository formats; squashing a branch
into one message that hides the concerns it carried; a format checked only in the pipeline,
where a bad message is found after the push (O-11); the format as documentation nobody reads
rather than a convention the tooling reads.
*Would change our mind:* a machine-readable commit format with equal or wider support in
release, versioning, and changelog tooling. None is in sight.
*Requirements:* R-01, R-05, R-08, R-28. *Guidance:* G-08, G-09, G-33, G-34.

**O-15 A requirement starts with written goals; the mock-up comes after.**
*The stance:* no requirement begins as a screenshot or a mock-up. It begins as written goals:
the outcome, then the scenarios, refined until they are unambiguous and testable. Only then is
a mock-up produced, and it is produced from the scenarios and names the ones it renders. When
a screenshot or mock-up arrives first, as they do, it is evidence of what someone wants, not a
requirement: the goals and scenarios it implies are written from it, what it does not show is
recorded as questions, and once those are confirmed a mock-up is made from them. The step
that receives a picture still runs (T-03); it changes what it treats the picture as.
*Why:* a picture shows one state of one screen and says nothing about why, about what happens
when it goes wrong, or about what the user could do afterwards that they could not before.
Requirements written from a picture inherit its silences and its accidents: the placeholder
text becomes a rule, the missing error state is never built. Agents make this worse: shown a
mock-up, they reproduce it faithfully and invent the behaviour between the pixels. Goals first
gives the mock-up something to be checked against (T-07) and keeps the feature file the source
of truth (O-01, T-12); a mock-up that shows behaviour no scenario states is a question, not a
specification.
*Rejected:* "build this" with a screenshot attached as the whole requirement; scenarios
reverse-engineered from a finished design and never questioned; the design tool as the source
of truth for behaviour; prototypes that run ahead of the scenarios and pull them along.
*Would change our mind:* nothing foreseeable. A mock-up is a good way to discover a
requirement and a good way to communicate one; it is not a way to state one.
*Requirements:* R-02, R-16, R-29. *Guidance:* G-35, G-36.

**O-16 Version everything needed to build and operate the software.**
*The stance:* the repository holds everything required to build, deploy, and run the system:
the code, the configuration templates for every environment with every key named and no
secret values, the schema and data migrations, the automation (root scripts, pipeline and
infrastructure definitions, container definitions, alert configuration), and the documentation
that operates it (runbooks, the development environment configuration, developer docs). The
test is a fresh clone: with the repository and the secrets its documentation names, a person or
an agent can build, deploy, and operate the software. Anything that test needs and cannot find
in the repository is missing from it. Secrets are the one thing never committed; their
templates always are.
*Why:* source control is the only output that counts (O-02), and a repository that builds but
cannot be deployed or operated without a file on someone's machine, a page in a wiki, or a
setting typed into a console is an output that cannot be reproduced. Every such gap is invisible
until the person who knows it is unavailable, and an agent cannot know it at all. Versioning
it all gives every change to how the system is built and run a history, a review, and a way
back (O-11, O-12, and "everything as code" in `setup-infrastructure` are this opinion applied
to one artifact each). The knowledge base still holds why (O-04); the repository holds how.
*Rejected:* configuration that lives only on the server; migrations run by hand from a script
kept elsewhere; a runbook in a wiki with no copy in the repository, where it drifts from the
scripts it describes; "ask the person who set it up"; documentation that describes how to
operate the system but is not versioned with the version of the system it describes.
*Would change our mind:* nothing foreseeable. An artifact that genuinely cannot be versioned
(a secret, a licence file) is represented by a template and a documented way to obtain it.
*Requirements:* R-05, R-06, R-19, R-30. *Guidance:* G-11, G-37, G-38.

**O-17 Small, cohesive commits, made by the user.**
*The stance:* every commit is one understandable change: one concern, one ticket, a subject
that says what and a body that says why, small enough to review in one sitting. And the agent
never makes the commit unless the user asked for that commit. The agent does everything up to
it: stages the change, writes the message, presents the staged diff and the message, and stops.
A request to implement, fix, finish, or run a step is not a request to commit. Reviewing the
change before it is committed is the primary point at which a person directs the work, and the
framework does not let an agent take it away.
*Why:* small cohesive commits are what make review possible, bisecting meaningful, and revert
safe; a commit that needs a tour is three commits. The second half is about who is in charge.
An agent that commits on its own turns the history into a record of what it did rather than
what the user accepted, and moves the human's review from before the commit, where a change
can be shaped, to after, where it can only be undone. The agent proposes; the human decides
(T-06). Commits made under the user's identity, at the user's request, keep the history honest
about who is accountable for it, which is also why no commit carries an agent attribution.
*Rejected:* "commit at every green" performed by the agent; agents committing under their own
identity or with attribution trailers; a standing permission to commit granted once and never
revisited; squashing a day's work into one commit at the end; review after the fact as a
substitute for review before the commit.
*Would change our mind:* nothing foreseeable about who commits. On size, a repository whose
tooling cannot bisect or revert would lose one benefit and keep the rest.
*Requirements:* R-01, R-05, R-31. *Guidance:* G-08, G-39, G-40.

**O-18 Decisions are decision records.**
*The stance:* every significant decision, technical, product, or process, is recorded as a
decision record: one screen, numbered next in one sequence per repository, dated, stating the
context, the options considered, the decision, and its consequences. A record is immutable
once accepted. A change of mind is a new record that supersedes the old one and links back to
it; the old one is never edited. Records live in the knowledge repository (O-04) or the
documents folder (R-06), whichever the project config names, and every record is linked from
the ticket the decision arose on. The record is written when the decision is made, by whoever
makes it, and the `decide` step exists so that a decision made mid-implementation is captured
as readily as one made in an architecture session.
*Why:* the knowledge repository holds why (O-04), and a decision record is the smallest unit
of why that can be found, cited, and checked later. Numbering makes it citable; dating makes
it placeable; immutability makes it trustworthy, because a record that can be edited after the
fact tells you what someone now wishes had been decided. Recording the rejected options is
what lets the next person, or the next agent, avoid re-litigating them, and it is what makes
"we considered that" a fact rather than a memory. Extending the form to product and process
decisions gives a reprioritisation, a scope cut, or a retrospective action the same standing
as a technology choice, which is what they deserve.
*Rejected:* decisions recorded only in ticket comments or chat; a single living architecture
document edited in place as decisions change; decision records for architecture only, with
product and process decisions left to memory; records long enough that nobody reads them;
editing a record to match what was eventually done.
*Would change our mind:* nothing foreseeable. The form is old, small, and has no serious
competitor for the job.
*Requirements:* R-02, R-03, R-06, R-32. *Guidance:* G-10, G-41.

**O-19 Every change traces back to its purpose.**
*The stance:* every change to the repository can be followed back to why it was made: the
commit names a ticket, the ticket links to the scenarios it satisfies or to the decision record
or page that explains it, and the scenario is tagged with the ticket. The chain runs in both
directions, so from a line of code you can reach the requirement and from a requirement you
can reach the code. A change that cannot name its purpose is either a ticket to create first or
work not to do. "Documented explanation" is the third kind of purpose, for work that no
scenario states and no ticket would naturally carry: a decision record (O-18) or a knowledge
base page (O-04) that says why.
*Why:* the framework already holds each link of this chain somewhere: the ticket in the
branch and commit (G-09), the ticket tag on the scenario (G-19), the links in both directions
(G-26), the feature to ticket to page relationship the tooling maintains (T-12), and every
commit since the last tag tracing to a ticket before a release (`prepare-release`). This
opinion says the chain is the point, not the links. Work that cannot say why it exists cannot
be reviewed against anything, cannot be released with notes that mean something, cannot be
reverted with confidence, and cannot be understood by the next person or agent to open the
file. Agents in particular will improve, tidy, and refactor whatever they touch unless the
question "what is this for" is asked of every hunk.
*Rejected:* "while I was in there" changes with no ticket; tidy-up commits that reference
nothing; tickets whose only content is a title; scenarios with no ticket tag; explanations that
exist only in the merge request conversation; requiring a ticket for a one-line fix and then
leaving the ticket empty, which satisfies the letter and none of the purpose.
*Would change our mind:* nothing foreseeable. The cost is a reference in a footer and a link
on a ticket, and the framework's tooling maintains most of it.
*Requirements:* R-01, R-02, R-08, R-16, R-33. *Guidance:* G-09, G-19, G-26, G-42.

**O-20 The simplest design that meets the scenarios.**
*The stance:* the design of a system, a component, or a change is the simplest one that
satisfies the scenarios that exist. Nothing is added for a scenario that does not exist yet:
no speculative feature, no abstraction with one implementation, no extension point nobody
extends, no configuration option nobody sets. Every component, boundary, and extension point in
the architecture names the scenario that requires it or the decision record that justifies it
(O-18). When a new scenario arrives, the design changes to meet it; that is what the feature
files, the tests, and small commits (O-17) are for.
*Why:* a design built for requirements that do not exist yet is built with the least
information anyone will ever have about them, and it is paid for now, in code to read, test,
and keep working, against a benefit that may never come. Abstractions chosen before the second
case are usually wrong for it. Agents make this worse in a specific way: asked for one thing,
they produce a general mechanism with the one thing as its first use, because that reads as
thorough. The scenarios are the source of truth for what the software must do (O-01, T-12);
a design that goes beyond them has no truth to be checked against (T-07), and a change that
serves no scenario traces to nothing (O-19).
*Rejected:* frameworks, plugin systems, and configuration surfaces built in advance of a
second use; "we will need it later" as a design justification; abstraction for its own sake;
designing to a roadmap rather than to the scenarios refined so far; the opposite error too,
where "simple" means copying the same code a fourth time rather than naming the thing.
*Would change our mind:* nothing foreseeable. A decision record can always justify an
exception, which is precisely why the exception must be recorded.
*Requirements:* R-16, R-34. *Guidance:* G-43.

**O-21 Conventions are enforced by tools, not by people.**
*The stance:* every project follows consistent coding conventions, and those conventions live
as formatter and linter configuration committed to the repository, not in a document or a
reviewer's head. Formatting is automated and runs on changed files before a change is
presented (G-01). Linting is enforced: every language with a known linter has one configured,
the root build runs it, the pipeline calls the same script (O-11), and a finding is fixed or
suppressed with a reason beside it (G-06), never ignored. A formatter is required (R-09); a
linter is recommended (R-12), because not every language has a usable one, and where none is
known the project says so once in its development environment configuration and health warns
rather than blocks (T-10). Style is never argued in review.
*Why:* conventions that live in a document are followed by the people who read it and
forgotten by everyone else, including every agent that arrives later. Conventions that live in
tool configuration are followed by everyone, cost nothing to apply, and free review for what
matters: correctness, security, and the requirement. Agents in particular produce plausible but
inconsistent style, and left unchecked will reformat what they touch; a formatter on changed
files makes both problems disappear. A linter catches the class of mistake that reads fine and
is wrong, before a person has to. Enforcement where the target allows (T-09) makes the rule
the same for humans and agents.
*Rejected:* style guides as prose; style comments in code review; formatting the whole
repository as a side effect of a change (G-01); a linter that runs only in the pipeline, where
its findings arrive after the push (O-11); suppressing findings without a reason; blocking a
project because its language has no linter.
*Would change our mind:* nothing foreseeable. The formatter or linter for a given language is
the project's or a tech-stack plugin's choice (T-01); the opinion is that one is configured and
runs.
*Requirements:* R-09, R-12, R-15, R-35. *Guidance:* G-01, G-06, G-44.

**O-22 Dependencies change through the package manager, never by hand.**
*The stance:* a dependency is added, updated, or removed only through the ecosystem's package
manager, using its commands, so that it resolves conflicts, surfaces warnings, updates the
transitive dependencies, and regenerates the lock file in one operation. A version in a
manifest or a lock file is never edited by hand. If the tool refuses a change, the refusal is
the finding: it goes on the ticket and is resolved, not bypassed by editing the file. The
manifest and lock file changes are committed together, as their own commit (G-39), and the
lock file is always committed (O-16).
*Why:* a manifest states what the project asked for; a lock file records what the resolver
concluded, for the whole transitive graph, under the constraints of every other dependency.
Editing one by hand breaks that relationship silently: the two files disagree, the transitive
graph is not re-resolved, conflicts and deprecation warnings that the tool would have raised
are never seen, and the next clean install produces a different tree from the one that was
tested. Agents do this readily, because editing a number in a file looks like the smallest
possible change; it is the largest one, made blind. The package manager exists precisely to
make this change correctly, and using it costs one command.
*Rejected:* editing a version number in a manifest; editing or deleting a lock file to make a
conflict go away; committing a manifest change without its lock file change; pinning a
transitive dependency by hand instead of letting the resolver do it; bypassing a tool refusal
by any means.
*Would change our mind:* nothing foreseeable. An ecosystem with no package manager has no
dependencies in this sense, and the opinion does not apply to it.
*Requirements:* R-04, R-05, R-36. *Guidance:* G-06, G-39, G-45.

**O-23 Tests are deterministic and independent.**
*The stance:* every test, at every tier, produces the same result every time it runs, alone or
with any other tests in any order. To make that true, a test controls the four things that
make results vary: time is injected or frozen, randomness is seeded or injected, state is
owned by the test that needs it and cleaned up after, and external dependencies are replaced
by a container (O-12), a fake, or a recorded response. A test that fails intermittently is a
defect in the test or the system; it is quarantined with a ticket the same day and is never
retried into green (G-06). The root test script can run one test alone and can run a tier in
a shuffled order, and both give the same answer as the full run.
*Why:* a test suite is evidence (T-07) only while its results mean something. One flaky test
teaches everyone to re-run the suite, and from then on a real failure looks like noise and a
retry hides a real defect. Order dependence means a test proves nothing on its own and a
failure cannot be reproduced by running it. Hidden time, randomness, shared state, and live
dependencies are the four sources of variance in practice, and each has a known control. Agents
write flaky tests readily, because a sleep or a live call is the shortest path to green, and
they will happily add a retry when asked to fix one; naming the four controls and forbidding
the retry is what keeps the suite honest.
*Rejected:* retry-on-failure as a test setting; tests that pass only in a fixed order; a shared
test database or environment that tests mutate and do not restore; sleeps as synchronisation;
live calls to external services from unit or integration tests; skipping a flaky test without
a ticket.
*Would change our mind:* nothing foreseeable. Tests that must exercise genuine nondeterminism
(property-based, chaos, soak) record their seed or their run and live where the strategy puts
them, outside the tiers a change must pass.
*Requirements:* R-11, R-21, R-25, R-37. *Guidance:* G-06, G-46.

**O-24 Build once; promote the same artifact.**
*The stance:* a release artifact is built once, from one commit, and given an immutable
identity tied to that commit: a digest, or a version the pipeline will never reuse. That same
artifact, under that same identity, is what every successive environment deploys, from the
first test environment to production. Nothing is rebuilt for a later environment.
Environment-specific configuration is supplied at deploy time from the committed templates
(O-16), never baked into the artifact. The release records the identity (O-14, G-34), and
validation in each environment confirms that what is running is that identity.
*Why:* the point of testing an artifact in one environment is to learn something about the
artifact that will run in the next. A rebuild breaks that inference: a different compiler
invocation, a dependency resolved a minute later, a flag set differently, and the thing in
production is not the thing that was tested, however reproducible the build claims to be. One
identity through the whole path is also what makes rollback exact (return to the previous
identity, not "rebuild the previous tag"), makes "what is running" a question with a checkable
answer (T-07), and lets the pipeline call the root `pack` script once (O-06, O-11) instead of
once per environment.
*Rejected:* a build stage per environment; environment-specific builds that differ by flag,
target, or embedded configuration; rebuilding "the same tag" for production; artifacts
identified by a mutable label such as `latest`; promoting by rebuilding from the same commit
and hoping the result is identical.
*Would change our mind:* nothing foreseeable. A platform that forces a per-environment build
step is a platform to configure around, and the exception is a decision record (O-18).
*Requirements:* R-20, R-30, R-38. *Guidance:* G-47.

**O-25 Environment settings and functional settings live apart.**
*The stance:* configuration is split by what varies. Settings that differ between deployed
environments, such as connection strings, service endpoints, resource names, and credentials,
live in an environment file or the platform's equivalent: one per environment, with a
committed template that names every key and holds no secret value (O-16, G-38), supplied to
the artifact at deploy time (O-24). Settings that are the same in every environment, such as
timeouts, limits, retry counts, and feature behaviour, live in the application configuration,
committed once with the code. No key appears in both places. If a functional setting must
differ for one environment, that is a decision record (O-18) and a deliberate override, not a
second copy of the whole configuration.
*Why:* the two kinds of setting change for different reasons, by different people, at
different times. An endpoint changes when infrastructure changes; a timeout changes when the
code's behaviour is tuned. Mixing them in one file per environment means every functional
change must be made three or four times and is missed in one, environments drift apart in
behaviour nobody intended, and the diff between environments, which should be a short list of
endpoints and names, is buried in hundreds of identical lines. Keeping them apart makes the
environment file the whole answer to "what is different about production", makes the
functional configuration part of the tested artifact, and gives an agent one obvious place to
put each new setting.
*Rejected:* one complete configuration file per environment, copied and edited; functional
settings in environment files; endpoints or credentials in the committed application
configuration; overriding functional settings per environment without a record of why; a
single flat settings store where the two kinds are told apart by naming convention alone.
*Would change our mind:* nothing foreseeable. The file format and the platform mechanism are
the project's choice (T-01); the separation is not.
*Requirements:* R-30, R-39. *Guidance:* G-38, G-48.

---

Opinions O-05, O-06, and O-07 describe the shape of every repository, O-08 describes who
proves what, O-09 ties each repository to its one ticket project, O-10 says when a ticket may
be sized, O-11 and O-12 keep the delivery path and the end-to-end tier runnable on any
machine, O-13 keeps a refined ticket honest against a repository that has moved, O-14 makes
the history readable by tooling, O-15 keeps the feature file ahead of the mock-up, and O-16
makes the repository sufficient to build and operate the system, O-17 keeps the commit in the
user's hands, O-18 gives every decision a record, O-19 ties every change to its purpose, and
O-20 keeps the design no larger than the scenarios, O-21 hands conventions to the tools, and
O-22 hands dependency changes to the package manager, O-23 keeps every test deterministic and
independent, O-24 promotes one built artifact through every environment, and O-25 keeps what
varies by environment apart from what does not. Together they are what `aa init` lays down and
`/aa-fw-health` checks for.

## Candidates

None at present. Propose one with `/aa-fw-new-opinion`.

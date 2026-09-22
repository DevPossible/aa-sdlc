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

## Candidates

- **Decisions are recorded as decision records.** Short, numbered, immutable once accepted, in
  the knowledge repository or the documents folder. Widely held already; likely to be promoted.
- **One ticket per branch, one concern per commit.** Currently guidance G-08; may be an opinion
  since branching models are a real choice.
- **Commit messages follow a conventional, machine-readable format.** Enables release notes and
  versioning from history. Not yet discussed.

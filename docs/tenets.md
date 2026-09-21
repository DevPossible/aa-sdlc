# AA-SDLC Tenets

**Status:** working draft, under active brainstorming. Last updated 2026-09-21.

Tenets are the principles that govern how the SDK and everything in it is designed. They are
few and stable. Every discipline, process, step, and piece of guidance must be consistent with
them. Practical, step-level advice is **guidance**, not a tenet; see [guidance.md](guidance.md)
and the [vocabulary](vocabulary.md).

Each tenet has a stable ID so design decisions, skills, and reviews can cite it. Ten govern the
shape of the content (T-01 to T-10); T-11 governs how the framework keeps that content honest.

---

**T-01 Describe the process, not the tool.**
Every step and every piece of guidance is written against what must happen and what must be
produced, never against a named product or language. The agent infers the tool later, from the
broader scope of the project it is working in. If a core skill has to name a tool, the skill is
wrong.

**T-02 Rough in the framework; expect others to supply the specifics.**
The core defines the shape of the work: disciplines, processes, steps, artifacts, and guidance.
Tech-stack packs, process packs, the project's own skills, and the tooling already in the agent's
scope supply the details. Extensibility is a requirement of every core skill, not a feature
added later.

**T-03 Describe the workflow; do not enforce it.**
Processes are opinionated and complete, but every step stands alone and can be run at any time,
in any order. The SDK never refuses a step because an earlier one was skipped. Consistency comes
from every step producing the same artifact in the same place, not from gating.

**T-04 The project's own systems hold the state.**
The ticket system is the state store, the knowledge base is the memory, source control is the
output. Every step anchors on a ticket, reads what it needs, does its work, and writes results
back. The SDK owns no process state of its own.

**T-05 Use what is already in scope; never wrap it.**
If the agent already has an MCP server, connector, or CLI for a system, skills use it by stating
intent in plain language. The SDK adds no layer over external systems. Where a system is absent,
the step still runs and produces its artifact locally.

**T-06 Guide the agent and the human together.**
Every step guides both toward best practice. Guidance exists to compensate for what agents and
humans each reliably get wrong. The agent proposes; the human decides what is irreversible.

**T-07 Evidence, not claims.**
A step is done when its artifact exists and its verification has been observed, not when the
agent says so. Outcomes are reported exactly, including failures, skips, and partial work.

**T-08 Same artifact, same place, same name.**
Consistency is the product. Two teams using the SDK produce work of recognisably the same shape,
linked the same way. The workflow defines each artifact once; steps use that definition without
variation.

**T-09 Guide first; enforce where the target allows.**
Every practice is taught through a skill so it works on every target. Where a target supports
hooks, the practices that can be checked mechanically may also be enforced. The practice is the
same either way.

**T-10 Report health; never block on it.**
One command enumerates and checks the SDK's expectations of the install, the environment, and
the project. It tells the user what is missing. Nothing else in the SDK checks for, or fails on,
a missing system.

**T-11 Declare every dependency; never assume one.**
Guidance written at the category level creates gaps: "format before committing" is useless in a
project with no formatter. So anything that depends on a capability declares it as a
requirement, the framework aggregates those declarations, health checks them, and init fills the
gaps it can. Bootstrapping a project to meet its requirements is part of the framework's job,
not something the agent works out the first time a step runs.

---

## Candidates

- **Small, reviewable increments.** Strongly held, but may be guidance on the Development
  discipline rather than a framework tenet.
- **One source of truth per fact.** Overlaps T-04 and T-08; may fold in.

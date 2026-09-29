---
name: init
description: Bootstrap a project inside the agent. Run health, then work through the unmet requirements that need judgement, fixing each with the user's consent, asking for the ticket project and knowledge base and finding a connector for them, listing what cannot be fixed with its remedy, and running health again.
aa:
  discipline: framework
  step: init
  guidance_sets: [every-step]
  guidance: [G-13, G-50]
  requires: [R-07, R-14, R-15, R-41, R-42, R-43]
---

# /aa-fw-init

`aa init` on the command line lays down files. This command does the part that needs
judgement or a conversation: the ticket project and knowledge base, the languages with no
formatter, the technologies with no skill in scope, the conventions the project already has
under other names. It proposes, acts only with consent, and never chooses a tool for the
project (T-01, T-06).

## Precondition

A repository. If `aa init` has not been run here, say so and run the equivalent of what it lays
down as the first proposals (config, folders, root script stubs), with consent.

## Procedure

1. **Run `/aa-fw-health` first** and work only from its report. Every unmet requirement it
   lists is a candidate; nothing it reports as met or not applicable is touched.
2. **Ask for the ticket project and knowledge base** if the project config does not name them
   (R-22, R-03). Ask in plain words: "Which ticket project does this repository belong to?" and
   "Where is its knowledge base?" Accept whatever the user gives: a name, a key, a URL.
   - When the answer names a system, search the agent's own scope for a skill, MCP server, or
     CLI for that system (T-05). Do not name any system the user did not name.
   - If one is in scope and usable, use it to confirm the project or space exists and record
     the key and URL in the project config.
   - If one is in scope but not authorised for that site, say exactly that, record the mapping
     anyway, and note that health will report R-02 or R-03 unmet until it is authorised.
   - If nothing is in scope, say so, record the mapping anyway, and name the remedy: the user
     installs or authorises a connector. The mapping is never blocked on the connector (T-10).
   - If the user asks for a new ticket project, create it with consent and configure it as step
     3 describes before reporting it ready.
3. **Check the ticket project now, before anything else** (O-26, R-41, R-43). As soon as a
   connector reaches the project, read its issue types, its workflow states and the moves
   between them, the parent links it allows, and its board. A project that cannot carry the life
   cycle otherwise surfaces hours later, in the middle of another step's work. Then:
   - Propose how each framework kind and state maps to the project's names (R-41), for the user
     to confirm, and record the mapping in the project config.
   - Check the project can carry the life cycle (R-43): seven distinct workflow states for the
     seven life-cycle states, with no two sharing one; a move from each state to the next and
     from In review back to In progress; an epic able to parent a story and a story a task; and,
     where the project has a board, a place on it for every mapped state. A new project's
     default workflow usually has too few states.
   - Propose each missing state, move, parent link, or board place as one line, naming the step
     that would stumble without it. With consent, make the change through the connector where
     the user may administer the project. Where they may not, list the changes for the
     project's administrator in the ticket system's own words and record what could be mapped.
   - Probe R-41 and R-43 again and say whether the project is ready. Recommend no discipline
     step while either is unmet, unless the user accepts the gap.
4. **Propose each fixable unmet requirement** as one line: what it creates or changes, and why
   (the requirement id and what depends on it). Batch trivial fixes such as folders and stubs
   into one proposal. Perform a fix only after the user agrees (G-13).
5. **For a language with no formatter or static analyser**, name the language and list what is
   available in the project's scope or as a tech-stack plugin; the user chooses. A static
   analyser needs a rule set as well as the tool: offer `/aa-dev-setup-environment` to choose
   one from a published baseline (G-50). If they choose nothing, record that no analyser is
   known for the language in the development environment configuration so health reports it as
   not applicable (O-21).
6. **Match the knowledge base to the framework** (O-27). Read the knowledge base space's
   top-level pages and offer to create any of the six sections that is missing, or to map it to
   an existing page (R-42); create nothing without consent.
7. **For a technology with no skill in scope**, name the technology and list the tech-stack
   plugins that would cover it; the user chooses (R-13).
8. **Map before you create.** If the repository already has an equivalent of a conventional
   folder or script under another name, propose the mapping in the project config rather than a
   second copy (O-05).
9. **Leave stubs honest.** A root script stub says in its first lines exactly what it must do
   when filled in, and exits non-zero until it is.
10. **List what cannot be fixed here** with the requirement, what depends on it, and the remedy
   the user must perform outside the agent. Do not attempt those.
11. **Run `/aa-fw-health` again** and report what changed and what remains, requirement by
   requirement.
12. **Stage and present.** Stage every file you created or changed as one change set and present
    the summary with a Conventional Commit message such as `chore(aa): bootstrap the project`.
    Commit only if the user asked for the commit (O-17, G-40). No attribution trailers.

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-50** Start each language's static analyser rule set from a published best-practice baseline for the language, framework version, and kind of application, or from a widely used alternative the user picks, or from the user's stated preferences; tailor it in the rule set file rather than with suppressions in code, and record the baseline, its version, and every departure with its reason in a decision record.
- Propose, then act. State each fix as a one-line proposal with what it creates or changes, and perform it only after the user agrees. Batch trivial fixes (folders, stubs) into one proposal.
- Never choose a tool for the project. When a language has no formatter or a technology has no skill, name the gap and list what is available in the project's scope or as plugins; the user chooses (T-01).
- Map before you create. If the repository already has an equivalent of a conventional folder, propose the mapping in the project config rather than a second folder.
- Leave stubs honest. A stub root script must say, in its first lines, exactly what it must do when filled in and must exit non-zero until it is.
- The ticket project and knowledge base are a conversation, not a lookup. Ask the user; when they name a system and paste a URL, search the agent's own scope for a skill, MCP server, or CLI for that system (T-05), confirm the project through it, and record the mapping. If the connector is absent or unauthorised, say exactly that, record the mapping anyway, and let health report R-02 or R-03. Never name a system the user did not name (T-01).
- Check the ticket project the moment it is confirmed, before anything else. Read its workflow, the moves between states, the parent links, and the board, and hold them to R-41 and R-43; propose each missing piece with the step that would stumble on it, make it with consent where the user may administer the project, and otherwise list it for the administrator. A project that cannot carry the life cycle is found hours later, in the middle of other work, when it is not checked first.

## Report

The second health report, then: what was proposed and accepted, what was proposed and
declined, what was recorded as not applicable and why, and what remains for the user. If a
connector was looked for, say which system, whether one was found, and whether it was usable.
Say whether the ticket project can carry the life cycle (R-41, R-43), and list any change still
waiting on its administrator.

---
name: init
description: Bootstrap a project inside the agent. Run health, then work through the unmet requirements that need judgement, fixing each with the user's consent, asking for the ticket project and knowledge base and finding a connector for them, listing what cannot be fixed with its remedy, and running health again.
aa:
  discipline: framework
  step: init
  guidance_sets: [every-step]
  guidance: [G-13]
  requires: [R-07, R-14, R-15]
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
3. **Propose each fixable unmet requirement** as one line: what it creates or changes, and why
   (the requirement id and what depends on it). Batch trivial fixes such as folders and stubs
   into one proposal. Perform a fix only after the user agrees (G-13).
4. **For a language with no formatter or linter**, name the language and list what is
   available in the project's scope or as a tech-stack plugin; the user chooses. If they choose
   nothing, record that no linter is known for the language in the development environment
   configuration so health's warning is expected (O-21).
5. **For a technology with no skill in scope**, name the technology and list the tech-stack
   plugins that would cover it; the user chooses (R-13).
6. **Map before you create.** If the repository already has an equivalent of a conventional
   folder or script under another name, propose the mapping in the project config rather than a
   second copy (O-05).
7. **Leave stubs honest.** A root script stub says in its first lines exactly what it must do
   when filled in, and exits non-zero until it is.
8. **List what cannot be fixed here** with the requirement, what depends on it, and the remedy
   the user must perform outside the agent. Do not attempt those.
9. **Run `/aa-fw-health` again** and report what changed and what remains, requirement by
   requirement.
10. **Stage and present.** Stage every file you created or changed as one change set and present
    the summary with a Conventional Commit message such as `chore(aa): bootstrap the project`.
    Commit only if the user asked for the commit (O-17, G-40). No attribution trailers.

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- Propose, then act. State each fix as a one-line proposal with what it creates or changes, and perform it only after the user agrees. Batch trivial fixes (folders, stubs) into one proposal.
- Never choose a tool for the project. When a language has no formatter or a technology has no skill, name the gap and list what is available in the project's scope or as plugins; the user chooses (T-01).
- Map before you create. If the repository already has an equivalent of a conventional folder, propose the mapping in the project config rather than a second folder.
- Leave stubs honest. A stub root script must say, in its first lines, exactly what it must do when filled in and must exit non-zero until it is.
- The ticket project and knowledge base are a conversation, not a lookup. Ask the user; when they name a system and paste a URL, search the agent's own scope for a skill, MCP server, or CLI for that system (T-05), confirm the project through it, and record the mapping. If the connector is absent or unauthorised, say exactly that, record the mapping anyway, and let health report R-02 or R-03. Never name a system the user did not name (T-01).

## Report

The second health report, then: what was proposed and accepted, what was proposed and
declined, what was recorded as not applicable and why, and what remains for the user. If a
connector was looked for, say which system, whether one was found, and whether it was usable.

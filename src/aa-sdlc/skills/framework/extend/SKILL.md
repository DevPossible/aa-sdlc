---
name: extend
description: "Walk the user from a need the framework does not cover to a valid, installable extension: choose the kind, scaffold it, declare its requirements, write its feature files, validate it against the tenets, and install or share it."
aa:
  discipline: framework
  step: extend
  guidance_sets: [every-step, anchored-step]
  requires: [R-05]
---

# /aa-fw-extend

Walk the user from a need the framework does not cover to a valid, installable extension: choose the kind, scaffold it, declare its requirements, write its feature files, validate it against the tenets, and install or share it.

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- What the user needs the framework to know about
- The installed extensions, to add to rather than duplicate
- The organisation config repository, if sharing

## Procedure

1. **Anchor and read what exists.** When a ticket is given, read it, its linked scenarios, and
   its page (G-22); otherwise work locally and say so. Ask what the user needs the framework to
   know about, then read the installed extensions at every scope and the organisation config
   repository if one is set, so you add to what exists rather than duplicate it.
2. **Fit the kind to the need.** A stack-specific practice is a tech-stack pack; an
   organisational gate is a process pack; something only this repository needs is a project
   skill; a new agent is a target adapter; a single practice or capability is added guidance or
   an added requirement. Explain the choice in one sentence and confirm it with the user before
   scaffolding. Where an existing pack covers the same technology or process, add to it rather
   than create a second.
3. **Refuse what would change core, by name.** If the need would redefine a core skill, step,
   tenet, or opinion, name the exact core item, say why an extension cannot change it, and
   offer the nearest allowed alternative: added guidance, a new step in a process pack, or one
   of the framework authoring commands in the aa-sdlc repository.
4. **Write the feature file first.** Capture the extension's behaviour as scenarios in its own
   features folder, tagged with the framework ids they realise, before any skill text is
   written (T-12). The scenarios are what the skill is checked against.
5. **Scaffold the extension** in the location its kind names: plugins/<name>/ for a pack, the
   project's skills location for a project skill, targets/<name>/ for an adapter. Write the
   manifest and, for each step it extends, a skill whose frontmatter names the step. Only a
   tech-stack pack may name tools; core-level guidance may not (T-01).
6. **Declare its requirements** in the extension's own numbered id range (T-11): every tool,
   system, or capability its guidance depends on, named in the manifest, so health can
   aggregate and check them once it is installed.
7. **Validate before installing.** Check the structure, the manifest, the requirement ids, and
   the feature files; check that it changes nothing in core and that no core-level guidance
   names a tool. Report every problem with the file that has it, quote the validator output
   (G-15), and go no further until it passes.
8. **Install or share.** Install at the scope the user chose, or add the extension to the
   organisation config repository so setup on other machines picks it up. Run health and quote
   the lines that mention the extension.
9. **Stage and present.** Stage the extension's files as one change set with a Conventional
   Commit message; commit only if the user asked (O-17, G-40). Update the ticket, when one was
   given, with what was produced and where (G-12).

## Artifacts

**Extension** in plugins/<name>/ for packs; the project's skills location for a project skill; targets/<name>/ for an adapter. Done when:

- Has a manifest, declared requirements in its own id range, and feature files
- Passes validation: changes nothing in core, and core-level guidance names no tool
- Installed at the chosen scope, or added to the organisation config repository

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- Fit the kind to the need before scaffolding. A stack-specific practice is a tech-stack pack; an organisational gate is a process pack; something only this repository needs is a project skill; a new agent is a target adapter. Explain the choice in one sentence.
- Write the feature file first. The extension's behaviour is captured as scenarios before any skill text is written, so the skill has something to be checked against.
- Refuse politely and specifically. When an extension would change core, name the exact core item and offer the nearest allowed alternative.
- Prefer adding to an existing pack over creating a second pack for the same technology or process.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).

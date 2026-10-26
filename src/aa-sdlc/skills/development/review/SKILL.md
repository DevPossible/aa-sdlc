---
name: review
description: "Review an identified candidate against its ticket, scenarios, brief and conventions; record actionable findings on its authorized merge request or local review record."
aa:
  discipline: development
  step: review
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-33, G-39, G-42, G-43, G-44, G-45, G-46, G-48, G-57, G-59]
  requires: [R-01, R-09, R-10, R-11, R-12, R-28, R-31, R-33, R-34, R-35, R-36, R-37, R-39, R-48]
---

# /aa-dev-review

Review an identified candidate against its ticket, scenarios, brief and conventions; record actionable findings on its authorized merge request or local review record.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

## Inputs

- The identified candidate and diff, with its merge request or authorized local review record
- The ticket, its scenarios pulled from their feature pages, and the implementation plan
- The feature files on the branch
- The build and test results for the branch

## Procedure

**Review the implemented candidate independently.** Use a separate reviewer/context when
authorized by the user or project; installed agent definitions alone do not authorize delegation.
Give the reviewer the brief, scenarios, exact candidate, and evidence index. A self-review is
labeled as such and does not replace required independent acceptance. Challenge authority,
money, schema/wire parsing, lifetime/quiescence, and race invariants with concrete adversarial
cases where applicable; do not turn every private helper into another predevelopment approval.
When remote review is outside scope, record findings against the local candidate and ticket.

1. **Read the purpose before the diff.** Pull the feature pages the ticket links to (G-54): their
   Approved scenarios into the features folder as feature files with their provenance header.
   With a documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features>`; with a knowledge base, read each page and
   convert it with `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the
   ticket, its scenarios, and its plan. A diff reviewed without its purpose is proofread, not
   reviewed. A scenario whose page moved on since the branch pulled it is a finding: the branch
   was built against a requirement that is no longer the one agreed.
2. **Verify the independent candidate gate.** Execute the affected build, lint and relevant
   tiers, or validate a still-current independently executed combined-candidate run for the
   same scope (G-59). Record its executor and independence; author-only results do not replace
   required independent proof. Keep actual output and do not trust a green badge. Run the
   feature-file check on the branch (G-56): `scripts/aa-sdlc/Test-FeatureProvenance.ps1
   -FeaturesRoot <features>` for any knowledge base, or `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features> -Check` for a documents-folder one, and
   quote its output. A feature file that fails it, with no provenance header, a checksum that
   does not match, or no page that generates it, is a blocking finding: the fix is to change the
   page and pull it, never to edit the file.
   For local work-in-progress integration, run the affected build/lint and relevant tiers on
   the combined candidate with real collaborators. One independently executed candidate gate
   can serve both reviewer and integrator; record exact source/dependency identity and output.
   Reference unchanged predecessor proof instead of recopying it. Re-run when relevant inputs
   or evidence validity change. This scoped approval does not replace the full-suite
   finish-branch gate or release checks.
3. **Walk the diff hunk by hunk** and ask of each what it is for. A hunk that traces to no
   scenario of the ticket and no stated reason is a finding (O-19). Structure that serves no
   scenario, an abstraction with one implementation, an option nobody sets, is a finding
   (O-20); so is a fourth copy of the same code. A test that depends on order, real time,
   unseeded randomness, shared state, or a live dependency, or a retry added to a test, is
   blocking (O-23). A manifest changed without its lock file, or a lock file edited by hand, is
   blocking (O-22). A setting in the wrong place is a finding (O-25). Style is never a comment;
   if a style issue reached review, the finding is that the tools did not run (O-21).
4. **Check the commits.** Each is a Conventional Commit with the ticket in its footer (G-33)
   and one concern (G-39); one that bundles concerns gets a finding that says how to split it.
5. **Check the proof.** Every scenario the ticket delivers has a test at the tiers the change
   warrants (G-20); the plan was followed or the deviation is recorded on the ticket with its
   reason.
6. **Record the findings** on the authorized review surface: the merge request, or the local
   candidate and ticket when remote review is outside scope. Include file, line,
   what is wrong, why, and blocking or not. Blocking is correctness, security, and the
   requirement. Put a summary on the ticket (G-12) and say what you did not check.
   When delegation is already authorized, route an actionable fix to its owner and ensure
   the follow-up activates an idle worker. A notification alone may only queue a message;
   verify that work starts instead of waiting for a worker that is not running. This is
   delivery of existing findings, not another approval or authorization to delegate.
7. **Report faithfully.** State the review scope and the independent run observed or validly
   referenced under G-59. All required scenarios must have passing proof; author verification,
   self-review and independent acceptance remain distinct (G-15).

## Artifacts

**Review findings** in the authorized merge request or local review record, with a summary on the ticket. Done when:

- Each finding names the file and line, says what is wrong and why, and is marked blocking or not
- The review states whether every scenario has a test and whether the plan was followed
- Every hunk in the diff traces to a scenario of the ticket or a stated reason; one that does not is a finding (O-19)
- A manifest changed without its lock file, or a lock file edited by hand, is a blocking finding (O-22)
- A test that depends on order, real time, unseeded randomness, shared state, or a live dependency, or a retry added to a test, is a blocking finding (O-23)
- A setting in the wrong place, an endpoint in the application configuration or a timeout in an environment file, is a finding (O-25)
- A feature file that fails the feature-file check (no provenance header, a checksum mismatch, or no page that generates it) is a blocking finding; the fix is to change the page and pull it (G-56)
- The review says what it did not check

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** During development run focused checks; before review run the affected build, lint and relevant test tiers, retaining actual output and declaring the scope. At actual branch finish run full build, lint, provenance and every test tier; at release satisfy the release checks. Instruction-only changes use the framework's applicable structural validation rather than claiming product behavior.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- **G-44** Let the tools decide style: conventions live in the repository as formatter configuration and a static analyser rule set, the formatter runs on changed files and the analyser runs from the root build before a change is presented, and every finding is fixed or suppressed with a reason beside it. Never argue style in review; where a language has no known linter, record that once in the development environment configuration and expect the health warning.
- **G-45** Change dependencies only through the ecosystem's package manager: add, update, and remove with its commands so it resolves conflicts, surfaces warnings, and updates transitive dependencies and the lock file together, and stage the manifest and lock file changes as their own commit (G-39). Never edit a version in a manifest or lock file by hand; if the tool refuses, record the refusal on the ticket and resolve it, never bypass it.
- **G-46** Make tests deterministic and independent: control time, randomness, owned state and external dependencies, and clean up. Retain intermittent failures with their affected claims and a distinguishing experiment; quarantine requires explicit authorization and a defect ticket, never makes affected acceptance green, and never silently skips or retries a failure into green.
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- **G-57** Before writing or approving an outcome, a scenario, an architecture, a decision record, an order of the backlog, or a merge request, read the product's doctrines and check the work against each doctrine and non-goal, and cite the doctrine it serves or is bounded by (`D-nn`). When the work conflicts with one, name the doctrine and the conflict and do not go on with that part until the user decides: change the work, or propose an amendment (G-58). Never absorb a conflict silently. Where there are no doctrines, say the check was made against nothing.
- **G-59** Keep one proportionate evidence index on the ticket or its linked durable record: candidate and dependency identity, executor and independence, requirement/environment identity, commands and actual results, required coverage, findings and owned-resource cleanup. One independently executed combined-candidate gate may serve reviewer and integrator for its named scope; reference unchanged proof, rerun affected proof when relevant inputs or evidence validity changes, and never relabel scoped integration as full branch finish or release.
- Read the ticket and scenarios before the diff. A diff reviewed without its purpose is proofread, not reviewed.
- Independently execute the candidate's affected gate, or reference a still-valid independently observed combined-candidate run for that same scope (G-59); author-only results cannot replace required independent proof.
- Run the feature-file check on the branch every time. A feature file with no provenance header, a checksum that does not match, or no page that generates it was not pulled from the knowledge base; it blocks the change until the page is changed and pulled (G-56).
- Blocking findings are about correctness, security, and the requirement. Style is the formatter's and linter's job, never a review comment (O-21); if a style issue reached review, the finding is that the tools did not run.
- Check the commit messages as well as the diff. A commit that does not follow the configured format is a non-blocking finding that names the pattern (O-14).
- Report faithfully: "approved" means every scenario has a passing test that you saw run.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).

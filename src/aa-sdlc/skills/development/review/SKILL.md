---
name: review
description: "Review a merge request against its ticket, its scenarios, its plan, and the project's conventions, and record findings on the merge request where the author will see them."
aa:
  discipline: development
  step: review
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-33, G-39, G-42, G-43, G-44, G-45, G-46, G-48]
  requires: [R-01, R-09, R-10, R-11, R-12, R-28, R-31, R-33, R-34, R-35, R-36, R-37, R-39]
---

# /aa-dev-review

Review a merge request against its ticket, its scenarios, its plan, and the project's conventions, and record findings on the merge request where the author will see them.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The merge request and its diff
- The ticket, its scenarios pulled from their feature pages, and the implementation plan
- The feature files on the branch
- The build and test results for the branch

## Procedure

**Hand the independent part to a separate context where you can** (decision record 0015). If this
harness can run the `aa-dev` subagent, give it steps 2 to 5 (run it and the feature-file check, walk
the diff, check the commits, check the proof), with the ticket, its scenarios, its plan, and the
branch, and record what it returns in step 6, saying the findings came from the agent. Otherwise do
those steps yourself, reading the change as if you had not written it.

1. **Read the purpose before the diff.** Pull the feature pages the ticket links to (G-54): their
   Approved scenarios into the features folder as feature files with their provenance header.
   With a documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features>`; with a knowledge base, read each page and
   convert it with `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the
   ticket, its scenarios, and its plan. A diff reviewed without its purpose is proofread, not
   reviewed. A scenario whose page moved on since the branch pulled it is a finding: the branch
   was built against a requirement that is no longer the one agreed.
2. **Run it yourself.** Build and test the branch with the root scripts, lint switch included,
   and keep the output; do not trust a green badge you did not see produced (G-04). Run the
   feature-file check on the branch (G-56): `scripts/aa-sdlc/Test-FeatureProvenance.ps1
   -FeaturesRoot <features>` for any knowledge base, or `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features> -Check` for a documents-folder one, and
   quote its output. A feature file that fails it, with no provenance header, a checksum that
   does not match, or no page that generates it, is a blocking finding: the fix is to change the
   page and pull it, never to edit the file.
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
6. **Record the findings** on the merge request where the author will see them: file, line,
   what is wrong, why, and blocking or not. Blocking is correctness, security, and the
   requirement. Put a summary on the ticket (G-12) and say what you did not check.
7. **Report faithfully.** "Approved" means every scenario has a passing test that you saw run
   (G-15). Anything less is stated as what it is.

## Artifacts

**Review findings** in the merge request, as comments, with a summary on the ticket. Done when:

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
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- **G-44** Let the tools decide style: conventions live in the repository as formatter configuration and a static analyser rule set, the formatter runs on changed files and the analyser runs from the root build before a change is presented, and every finding is fixed or suppressed with a reason beside it. Never argue style in review; where a language has no known linter, record that once in the development environment configuration and expect the health warning.
- **G-45** Change dependencies only through the ecosystem's package manager: add, update, and remove with its commands so it resolves conflicts, surfaces warnings, and updates transitive dependencies and the lock file together, and stage the manifest and lock file changes as their own commit (G-39). Never edit a version in a manifest or lock file by hand; if the tool refuses, record the refusal on the ticket and resolve it, never bypass it.
- **G-46** Make every test deterministic and independent: inject or freeze time, seed or inject randomness, give each test its own state and clean it up, and replace external dependencies with a container, a fake, or a recorded response; never depend on test order, on state another test left, or on a sleep. A test that fails intermittently is a defect: quarantine it with a ticket the same day, never retry it into green or skip it without one (G-06).
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- Read the ticket and scenarios before the diff. A diff reviewed without its purpose is proofread, not reviewed.
- Run it. Build and test the branch yourself; do not trust a green badge you did not see produced.
- Run the feature-file check on the branch every time. A feature file with no provenance header, a checksum that does not match, or no page that generates it was not pulled from the knowledge base; it blocks the change until the page is changed and pulled (G-56).
- Blocking findings are about correctness, security, and the requirement. Style is the formatter's and linter's job, never a review comment (O-21); if a style issue reached review, the finding is that the tools did not run.
- Check the commit messages as well as the diff. A commit that does not follow the configured format is a non-blocking finding that names the pattern (O-14).
- Report faithfully: "approved" means every scenario has a passing test that you saw run.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).

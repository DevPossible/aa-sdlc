# Plan: Pivot the Website

**Status:** drafted, awaiting review. Started 2026-09-22.

Design [section 10](design.md#10-website-pivot) sets the destination: the landing page leads
with the SDK, the workflow page becomes the methodology, the current landing page becomes the
business case, and navigation is Home, Methodology, Business Case, Repo. This plan is how that
gets built. It was deliberately left out of
[plan-framework-gaps.md](plan-framework-gaps.md), which closes the framework's own gaps; this is
its sibling and can run alongside that plan from Phase C onward.

The website is a separate repository, `website-aasdlc-com`, deployed to Cloudflare Pages from
`site/` by GitLab CI. It is four hand-written files and has no build step.

## Scope

| # | Gap | Phase |
|---|-----|-------|
| 1 | The landing page sells the methodology; the pivot leads with the SDK | H |
| 2 | `workflow.html` is prose that predates the workflow data: 6 phases and 23 steps against today's 6 processes, 15 disciplines, and 52 steps | M |
| 3 | Nothing stops the site and the workflow data drifting; today they already have | M, V |
| 4 | Navigation is section anchors on one long page, not the four-page site the pivot needs | W |
| 5 | The site brands itself "AASDLC"; the brand, package, CLI, and commands are `AA-SDLC`, `aa-sdlc`, `aa`, `/aa-<code>-<step>` (decision 15) | W |
| 6 | The hero asserts 70% cost reduction, 10x delivery, and 95% quality improvement with no source (T-07) | C |
| 7 | Nothing on the site carries T-13: one person or fifteen, the same framework (decision 33) | H |
| 8 | The site does not say where the methodology ends and the SDK begins | C, H |
| 9 | The website repository has no decision record and no plan of its own | W |

Out of scope here: adopting O-05, O-06, and O-07 in the website repository (no build step is
needed while the site is four static files, O-20); a static site generator; any content beyond
the four pages.

## Working agreements while executing this plan

- One task, one commit, in the repository the task names. The agent stages and presents; the
  user commits (O-17, G-40).
- Tasks touching both repositories are split so each commit lands in one repository.
- Every task that changes the generator or the workflow data ends with `./test.ps1 -Tier unit`
  green in `aa-sdlc`.
- Generated files are committed to the website repository and never hand-edited. The banner at
  the top of each says so, as `discipline-review.md` does.
- Sizes are relative (S, M, L) and grounded in the tasks listed (O-10).

## Phase W: foundation

Both repositories. Do this first: every later task renders inside the chrome it sets, and
depends on the decision in W1.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| W1 **decide** how the site is generated | Record the choice: the generator lives in `aa-sdlc/scripts/`, reads `src/aa-sdlc/workflow/`, and writes HTML that is **committed** to the website repository; the website repository keeps no build step and its CI is unchanged; a check mode run in the `aa-sdlc` unit tier fails when the committed HTML is stale. Record also that the website repository shares ticket project AA rather than taking its own (O-09 permits many repositories to one project), and why a vendored snapshot and a merged repository were rejected. | `docs/decisions/0005-website-generated-from-workflow-data.md`, `docs/design.md` §10 | Record accepted; design §10 names the mechanism and the generator script; §9's "should be generated from it, or at least checked against it" is replaced by the decided answer | S |
| W2 Brand and navigation | Across all pages: brand `AA-SDLC`, titles, meta description, footer. Replace the per-section anchor menu in the nav with the site nav (Home, Methodology, Business Case, Repo) and move the business case's section anchors into a page-level table of contents. Keep the alpha banner on every page. | `site/*.html`, `site/styles.css` (website repo) | Every page carries the same four-item nav and the alpha banner; no visible text reads "AASDLC" unhyphenated; the business case's existing section links all still work | M |
| W3 Shared styles and script | Add the classes the new pages need: status block, discipline grid, step card, command chip, the two-column solo/team layout. Scope `script.js` so the scroll-spy and section behaviour no-op on pages without those sections instead of erroring. | `site/styles.css`, `site/script.js` | No console errors on any page; the business case behaves exactly as it does today; new classes render at phone width without horizontal scroll | M |

## Phase M: the methodology page, generated

The workflow data is the source of truth (design §9). This phase makes the site read from it.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| M1 **decide** what the generated page loses and keeps | The website's `docs/workflow.md` carries **Actors**, **Reference Sources**, and **Tooling** per step; the step YAML does not, and its tooling lists ("Slack/MS Teams") are exactly what T-01 forbids in core. Recommended: drop tooling (T-01), drop actors (the step's discipline is the actor, and naming people cuts against T-13), and keep `docs/workflow.md` in the website repository as the historical record of the pre-SDK methodology, linked from the methodology page as such. The alternative, adding `actors:` and `tooling:` to all 52 step YAML files, is the thing to reject explicitly. | `docs/decisions/0006-*.md` | Record accepted; it names every field the old page had that the new one will not | S |
| M2 Generator | `scripts/Build-WebsiteMethodology.ps1 -SitePath <website repo>/site` following `Build-DisciplineReview.ps1`: same `Read-YamlFolder`, same guidance-set expansion, same generated-file banner. Emits `methodology.html`: the six processes in order with summary and exit condition, and for each step its name, discipline, command, summary, anchor, inputs, artifacts with acceptance criteria, and expanded guidance. Also emits the discipline reference H4 needs. `-Check` returns non-zero when output differs from what is committed. | `scripts/Build-WebsiteMethodology.ps1`, `site/methodology.html` (website repo) | Two consecutive runs are byte-identical; all 52 step ids appear exactly once; every command rendered matches `/aa-<code>-<step>` for its discipline's code; the page uses only classes W3 defined | L |
| M3 Currency check in the unit tier | Run `-Check` from the unit tier when the website repository is present at the sibling path the workspace file already assumes, and skip with a stated reason when it is not. | `scripts/Test-WorkflowStructure.ps1` or new `scripts/Test-WebsiteCurrency.ps1`, `test.ps1` | Editing a step YAML without regenerating makes `./test.ps1 -Tier unit` fail and name the stale file; the tier still passes on a clone without the website repository, reporting the skip | M |
| M4 Retire `workflow.html` | Replace it with a redirect to `methodology.html` so existing links survive. Add the per-step callout design §10 asks for: each step names its skill and command and links to the repository (H5 gates the repository link). | `site/workflow.html`, `site/methodology.html` (website repo) | `/workflow.html` reaches the methodology page; no internal link still points at `workflow.html` | S |

## Phase H: the home page

The pivot's substance. It leads with the SDK and says honestly what exists.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| H1 The page and its message | New `index.html`: what the SDK is, the honest status block (H2), how it installs when it ships, the disciplines (H4), the phase-to-step map linking into the methodology page, the opinions as their seven groups, the solo and team paths (H3), the extension model, and links to methodology, business case, and repository. | `site/index.html` (website repo) | The T-13 message appears in the first screen of content; the install block is labelled as planned, not as a command to run; every factual claim on the page is checkable against this repository | L |
| H2 Generated status block | The counts rot if hand-written. The generator writes the block between HTML comment markers in `index.html`: disciplines, processes, steps defined as workflow data, skills present, feature files, and the state of the CLI. `-Check` covers it. | `scripts/Build-WebsiteMethodology.ps1`, `site/index.html` | Adding a skill and regenerating changes the number on the page; `-Check` fails on a stale count; the hand-written parts of `index.html` are untouched by regeneration | M |
| H3 Solo path and team path | Two columns following one ticket through the same steps, once as a solo developer and once across a team, from the same workflow data but written by hand as narrative. Design §10 requires neither audience to think the framework is for the other. | `site/index.html` | Both columns name the same steps and the same artifacts, differing only in who performs them | M |
| H4 Disciplines and commands | Generated reference: 15 disciplines with code, purpose, what each owns, and its commands, from `disciplines/*.yaml`. It is the same data `discipline-review.md` prints, so it belongs to the generator, not to hand-written HTML. | `scripts/Build-WebsiteMethodology.ps1`, `site/index.html` or a generated fragment | Every discipline and every command in the workflow data appears; a new step added to a discipline appears after regeneration | M |
| H5 The Repo nav item | **Blocked.** Design §12 leaves public hosting and the licence open. Until both are settled the item cannot link anywhere. Either omit it from the nav and link the repository nowhere, or point it at a short page saying the repository is not public yet. Decide when §12 resolves; do not ship a dead link. | `site/*.html` | The nav has no item that does not resolve; if the repository is not public, the site says so once rather than linking to nothing | S |

## Phase C: the business case

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| C1 Move and retitle | Current `index.html` becomes `business-case.html`, retitled "The Business Case for AA-SDLC". Content is kept. Add the page table of contents W2 moved out of the nav. | `site/business-case.html` (website repo) | Every section id survives the move; the ten sections are all reachable from the page contents | M |
| C2 The hero numbers | 70%, 10x, and 95% have no source on the page and none in this repository. Under T-07 they are claims, not evidence. Recommended: move them into the cost section as figures the page's own model produces, with the model's assumptions stated next to them, and replace the hero with what the framework actually asserts. Needs the user's call on whether any measurement exists behind them. | `site/business-case.html` | No number appears on the site without either a stated source or the assumptions that produce it | S |
| C3 Where the methodology ends and the SDK begins | Add the paragraph design §10 requires: the methodology describes AI in meetings and similar roles; the SDK implements the coding-agent slice of it. It belongs on the business case, where the meeting-agent narrative lives, and in one line on the home page. | `site/business-case.html`, `site/index.html` | A reader of either page can say which parts of the methodology the SDK implements today | S |

## Phase V: verification and launch

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| V1 Content check | Extend the currency check: every internal link on the site resolves to a file, every command named on the site exists in the workflow data, and every `T-`, `O-`, `G-`, and `R-` id cited on the site exists in its registry. Runs in the unit tier with M3. | `scripts/Test-WebsiteCurrency.ps1` | A seeded bad link, a seeded unknown command, and a seeded unknown id each fail the tier and are named in the failure | M |
| V2 Accessibility and responsive pass | Re-check what the new pages and the nav change affect: contrast on the status block and the command chips, keyboard navigation of the new nav, the discipline grid and the two-column layout at phone width. | `site/styles.css` | No horizontal scroll at 320px; every interactive element reachable by keyboard; contrast meets WCAG AA on the new components | M |
| V3 Deploy and verify | CI is unchanged; `wrangler` deploys `site/`. Verify on the live domain: the four pages, the `workflow.html` redirect, the alpha banner on every page, and the generated pages matching the workflow data at the deployed commit. | none | All four pages live; the redirect works; the deployed methodology page regenerates byte-identically from the workflow data at that commit | S |

## Dependencies and order

```
W1 ──> W2 ──> W3 ──┬──> M1 ──> M2 ──> M3 ──> M4 ──┐
                   │                              │
                   ├──> H1 ──> H2, H3, H4 ────────┼──> V1 ──> V2 ──> V3
                   │           (H2 and H4 need M2) │
                   └──> C1 ──> C2, C3 ────────────┘

H5 is blocked on design §12 (public hosting and licence) and joins before V3.
```

W first. M before H, because H2 and H4 are emitted by M2's generator. C is independent of M and
H once W3 lands and can run in parallel. V last, and V1 needs every page to exist before it can
check them.

## What this plan does not settle

- **Public hosting and the licence** (design §12). H5 is blocked on it.
- **Whether any measurement backs the hero numbers.** C2 assumes none and reframes them; if
  evidence exists, C2 becomes a citation task instead.
- **Whether the website repository later adopts O-05, O-06, and O-07.** Deliberately out of
  scope while the site is four static files (O-20). Revisit when it needs a build step of its
  own.
- **The website's own ticket project.** W1 records that it shares AA; a separate project is a
  later decision if the site's work stops being framework work.

## A note on sequencing

The home page will lead with an SDK that is a specification: 52 steps exist as workflow data, 7
skills exist, and the CLI is a decision record without an implementation
([plan-framework-gaps.md](plan-framework-gaps.md) phases C through F). The chosen approach
handles this by stating it on the page rather than implying otherwise, which keeps T-07 intact.
The alternative was to ship this plan's Phases W, M, and C now and hold Phase H until the CLI
ships. That remains available if the status block reads as thinner than the page around it.

## Progress

| Phase | Task | Status |
|-------|------|--------|
| W | W1 to W3 | not started |
| M | M1 to M4 | not started |
| H | H1 to H5 | not started |
| C | C1 to C3 | not started |
| V | V1 to V3 | not started |

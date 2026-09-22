# 0007: The website's methodology page and status block are generated from the workflow data and committed

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

Design section 9 says the website's methodology page "should be generated from" the workflow
data "or at least checked against it". The site's `workflow.html` predates the workflow data:
six phases and 23 steps against today's 6 processes, 15 disciplines, and 52 steps, so the two
have already drifted. The website is a separate repository (`website-aasdlc-com`), four static
files deployed to Cloudflare Pages by its own CI with no build step. Plan task W1 in
plan-website-pivot.md.

## Options

- **A. A generator in `aa-sdlc/scripts/` reads `src/aa-sdlc/workflow/` and writes HTML that is
  committed to the website repository; a check mode in the `aa-sdlc` unit tier fails when the
  committed HTML is stale.** The website keeps no build step and its CI is unchanged; the
  workflow data stays the single source of truth. Chosen.
- **B. Vendor a snapshot of the workflow data into the website repository and render it there.**
  Two copies of the truth, and the website would need a build step.
- **C. Merge the website into the framework repository.** Different release cadence and
  audience; O-05 does not require it and the site is four files (O-20).

## Decision

Option A. `scripts/Build-WebsiteMethodology.ps1 -SitePath <website repo>/site` writes
`methodology.html` in full and replaces the generated blocks of `index.html` between HTML
comment markers (`<!-- aa:status:begin -->` and `<!-- aa:disciplines:begin -->` with their
matching end markers), leaving the hand-written parts untouched. Every generated region starts
with a banner saying it is generated and must not be edited by hand. The output contains
nothing volatile (no dates, no commit ids), so two runs are byte-identical. With `-Check` the
script writes nothing and returns the names of stale files. `scripts/Test-WebsiteCurrency.ps1`
runs that check from the unit tier when the website repository is present at the sibling path
`../../Websites/website-aasdlc-com` (or the path in `AA_WEBSITE_PATH`), and reports a skip
with the reason when it is not.

The website repository shares ticket project AA rather than taking its own: O-09 permits many
repositories to one project, and the site's work is framework work.

## Consequences

- Editing a step, discipline, or process without regenerating and committing the site fails
  the `aa-sdlc` unit tier on any machine that has the website repository checked out.
- The website's CI stays a one-line deploy of `site/`.
- The generated HTML uses only classes defined in `site/styles.css`; the generator does not
  emit styles.
- Design sections 9 and 10 now name this mechanism.

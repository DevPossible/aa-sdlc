# Guidance set `test-writing`

What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

Generated from `src/aa-sdlc/workflow/guidance-sets/test-writing.yaml` and `docs/guidance.md` by `scripts/Sync-SkillGuidance.ps1`; do not edit by hand.

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-46** Make every test deterministic and independent: inject or freeze time, seed or inject randomness, give each test its own state and clean it up, and replace external dependencies with a container, a fake, or a recorded response; never depend on test order, on state another test left, or on a sleep. A test that fails intermittently is a defect: quarantine it with a ticket the same day, never retry it into green or skip it without one (G-06).

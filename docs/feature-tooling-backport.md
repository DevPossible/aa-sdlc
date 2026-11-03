# Agent Possible feature-tooling backport

Local anchor for the eleven numbered changes approved by Richard on 2026-11-02.
Framework baseline: `c4b36d0`; project helper baseline: `761cae17^`.
The initial approval covered local implementation and validation, without a remote
issue, release, publication or installation refresh.

On 2026-11-03 Richard authorized committing, pushing and merging the AA-SDLC
backport. This extends the original local-only scope to source publication and
merge through the configured GitLab checks. A supporting generated website
index correction is committed locally at `07fac61`; its live-site deployment
pipeline is outside this source merge. No package release or project installation
refresh is requested.

## Approved scope and proof

1. MCP-exported headings and empty table headers: preserve complete scenario output.
2. Strict feature-page validation: reject malformed or unconsumed requirement tables.
3. Validate synchronization before mutation: invalid batches preserve existing bytes.
4. Versioned module manifests: declare public exports and PowerShell requirements.
5. Offline Confluence snapshot import: use configured knowledge space and URL.
6. Named HTML entities: preserve one reference layer, refuse unsupported entities.
7. Simple preamble lists: retain order and links, refuse unsupported structures.
8. Snapshot import/check command: preserve source, version, checksum and existing files.
9. Exact Approved selection: validate the full source and preserve source order.
10. Full-source checksum: bind projections and refuse conflicting destination metadata.
11. Reconcile this record and Agent Possible's historical backport ledger.

Authoritative source is `src/aa-sdlc/scripts/`; tests are under `tests/unit/`.
Update the feature page under `docs/knowledge/Requirements/framework/` before
generating its feature file. Port the project's regression fixtures, generalize
the importer, then exercise real helper installation through the built CLI.
Use existing `powershell-yaml` support for the command's explicit config file;
the converter module takes the configured space and URL as explicit arguments.

Invariants: only Approved scenarios generate; selection never hides malformed
source; errors before synchronization mutation preserve the whole batch; snapshot
import does not replace edited files, downgrade source versions or silently change
projection membership; no network or credentials are needed to import a snapshot.
The batch prevalidation is not a filesystem transaction for subsequent I/O failure.

## Evidence

The candidate implements all eleven approved items. The source map below also
maps each behavior to its approved F-093 scenario; item 11 is record upkeep.

| Item | Scenario | Agent Possible source history | Framework source / proof |
| --- | --- | --- | --- |
| 1 | F-093-01 | `cb519652` | `AaFeatures.psm1`; conversion regression catalog |
| 2 | F-093-02 | `cb519652` | `AaFeatures.psm1`; malformed/unconsumed source cases |
| 3 | F-093-03 | `cb519652` | `Sync-FeatureFiles.ps1`; batch and byte-preservation cases |
| 4 | F-093-04 | `cb519652`, `c065590a`, `b151803e` | Both manifests; configuration and installed-payload tests |
| 5 | F-093-05 | `c065590a` | `ConfluenceFeatureImport.psm1`; generalized space/URL tests |
| 6 | F-093-06 | `2a63457d`, `40264e7d` | Entity conversion; named/numeric/escaped reference cases |
| 7 | F-093-07 | `92dbd7e2`, `6d15a5f2` | Preamble lists; order, links and rejected structures |
| 8 | F-093-08 | `c065590a` | `Import-ConfluenceFeatureSnapshot.ps1`; destination guards |
| 9 | F-093-09 | `586fd04e` | Converter/importer/command exact selection cases |
| 10 | F-093-10 | `95971084` | Full Markdown checksum and projection metadata cases |
| 11 | n/a | Project backport ledger | This record and `docs/aa-sdlc-backport-log.md` in Agent Possible |

The two stock-refresh failures were reproduced before implementation at parser
scenario accounting and rejection of unconsumed Confluence tables. The ported
catalogs now pass **73 conversion/synchronization checks** and **125 snapshot
checks**. The original AP fixture retains its independently recorded default-byte
checksum; additional AS/PROJECT2 fixtures prove generalized configuration.

Author verification:

- Final `pwsh -NoProfile -File build.ps1 -Lint`: passed; 39 scripts and 488 text files.
- Focused Pester run of `AaFeatures.Tests.ps1`, `FeatureTooling.Tests.ps1` and
  `ConfluenceConfiguration.Tests.ps1`: **35 passed, zero failed/skipped**.
- Pester command coverage over `AaFeatures.psm1`, `ConfluenceFeatureImport.psm1`,
  `Sync-FeatureFiles.ps1` and `Import-ConfluenceFeatureSnapshot.ps1`: **92.05%**
  against the **80%** target, 994 analyzed commands. XML report:
  `.aitemp/feature-tooling-coverage.xml` (local generated evidence).
- Installed-helper integration Pester suite: **3 passed, zero failed/skipped**.
  A real built CLI initializes a disposable project, installs exact helper bytes,
  imports/checks selected output and restores a changed helper through update.
  Project configuration is preserved, temporary output files are absent and
  Pester cleans the disposable project; the inherited `AA_HOME` is restored.

Additional completed verification:

- `go test ./...` in `src/aa-sdlc-cli`: all packages passed.
- `GOFLAGS=-v ./test.ps1 -Tier integration`: **63 scenarios / 302 steps passed**
  under strict checking, followed by **3 installed-helper Pester tests passed**.
  Log: `.aitemp/feature-tooling-integration.log` (absolute path in the invocation).
- `./pack.ps1 -Version 0.6.1-backport.0 -Targets windows/amd64 -SkipTests`:
  produced local candidate tarballs after the separately recorded test gates.
  This is a disposable test version; the repository's release version is unchanged.
- `./test.ps1 -Tier e2e`: **6 passed, zero failed/skipped**, installing those
  actual npm tarballs into a disposable prefix/home. The added case uses packed
  helpers to import and check selected output with configured provenance.
- The installed-helper test was rerun after sharing its snapshot fixture with
  the package E2E case: **3 passed**. Fixture sharing and fully spelled scenario
  IDs change only test artifacts; product helper source remains at `27485f4`.
- Final combined Pester run over `tests/unit` and the installed-helper integration
  suite: **38 passed, zero failed/skipped** after spelling every scenario ID in full.

Candidate packages identify source `27485f4`. SHA256 digests:

- `aa-sdlc-0.6.1-backport.0.tgz`:
  `cfa948f0be0b991a3db5a8f8135771299e773df70c8c0d73edecfb97c7bc570f`.
- `devpossible-aa-sdlc-cli-win32-x64-0.6.1-backport.0.tgz`:
  `78828d209964b5b7d696eddc4c911ba23d43ff5519a1a16f749c7746cfa6b767`.

The first full unit attempt stopped at the separate website's committed index:
counts need 92/820 to 93/830 and its older displayed version needs 0.5.1 to 0.6.0.
A generated preview is under `.aitemp/feature-tooling-website-preview/`. The
two-line local website commit `07fac61` now supplies the required committed
index; `scripts/Test-WebsiteCurrency.ps1` passes against it.
All other structural checks in that invocation passed. The separate Go package
and complete unit Pester runs above passed; that full root unit invocation
was blocked at website currency and is not retrospectively reported as green.
The newly authorized branch-finish run verifies the complete candidate below.

## Branch-finish verification (2026-11-03)

After fetching `origin/main`, the backport already contains the target's `c4b36d0`
and needs no conflict resolution. The root build with lint and the full root
`./test.ps1` run pass: all Go packages, **35 unit Pester tests**, **63 strict CLI
scenarios / 302 steps**, **3 installed-helper integration tests**, and **6 packed
E2E tests**. Generated-feature currency/provenance and website currency pass.
The inherited Go commit-hook test initially skips because `sh` is not on PATH;
an explicit rerun with Git's installed `sh.exe` available passes that actual test.
No test is weakened to clear this environment condition.

Commands and output: `.aitemp/feature-tooling-finish.log` and
`.aitemp/feature-tooling-hook.log` (local generated evidence). The default full
test tier excludes the opt-in external-agent Docker harness by its existing
contract; no external-agent integration is claimed. `src/aa-sdlc/scripts/` is
unchanged from package-tested implementation `27485f4`, verified with Git, so
the recorded candidate tarballs and coverage remain applicable. This follow-up
changes only the approval/verification record. GitLab merge-request and target
pipeline results are recorded on the merge request rather than duplicated here.

The first full integration attempt had a **reporting setup failure**: a relative
Tee-Object log path resolved after the runner changed into `tests/integration`.
It did not establish a test result. The maintained invocation uses an absolute
log path and `GOFLAGS=-v`; the completed result is recorded above. An earlier new-test
fixture also shared an output path between Pester cases; unique per-case roots
correct that setup, and the final configuration suite passes. No failure was
quarantined, skipped or retried without a changed cause.

Validation at this boundary is author verification and self-review. No independent
worker has been authorized. Snapshot fixtures and command integration need no
live wiki, network, accounts or application host. Publication/activation and the
project's stock-helper refresh remain separate from this source merge.

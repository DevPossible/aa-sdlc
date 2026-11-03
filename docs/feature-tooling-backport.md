# Agent Possible feature-tooling backport

Local anchor for the eleven numbered changes approved by Richard on 2026-11-02.
Framework baseline: `c4b36d0`; project helper baseline: `761cae17^`.
The approval covers local implementation and validation. No remote issue, release,
publication or installation refresh is part of this candidate.

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

Author checks observed so far:

- `pwsh -NoProfile -File build.ps1 -Lint`: passed; 38 scripts and 487 text files.
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

Full unit/CLI-integration and packaged checks are still pending in this record.
The first full unit attempt stops at the separate website's committed index:
counts need 92/820 to 93/830 and its older displayed version needs 0.5.1 to 0.6.0.
A generated preview is under `.aitemp/feature-tooling-website-preview/`; separate
permission is pending for that repository's two-line local commit.

The first full integration attempt had a **reporting setup failure**: a relative
Tee-Object log path resolved after the runner changed into `tests/integration`.
It did not establish a test result. The maintained invocation uses an absolute
log path and `GOFLAGS=-v`; its result will be recorded below. An earlier new-test
fixture also shared an output path between Pester cases; unique per-case roots
correct that setup, and the final configuration suite passes. No failure was
quarantined, skipped or retried without a changed cause.

Validation at this boundary is author verification and self-review. No independent
worker has been authorized. Snapshot fixtures and command integration need no
live wiki, network, accounts or application host. Publication/activation and the
project's stock-helper refresh remain separate from this local candidate.

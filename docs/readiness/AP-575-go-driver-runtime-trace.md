# AP-575: Go driver runtime-trace initialization blocker

Anchor: [AP-575](https://devpossible.atlassian.net/browse/AP-575), following
[AP-571](AP-571-go-driver-tail.md) and
[AP-572](AP-572-go-test-input-fanout.md). Investigation on 2026-11-10 Chicago
time. PM owns Jira, independent review, merge and evidence preservation.

The proposed runtime-stack experiment stopped before admission. In the installed
Go 1.26.7 source, `go test` parses its custom flags **after** the driver's only
runtime-trace initialization check. The undocumented `-debug-runtime-trace`
flag is registered and can be accepted syntactically, but that late assignment
does not start runtime tracing for this command. The action trace has separate
late initialization and therefore does not establish that runtime tracing starts.

This is a static observability blocker, not a measured driver hotspot. **No Go
test experiment or runtime-stack capture ran in AP-575.** There is no new native
PASS/NONPASS result, trace-decoding result, CPU allocation or causal finding.
`search.InDir`/EvalSymlinks metadata work versus cache storage/locking remains
unresolved. PM confirmed report-only scope after the blocker was found; no
alternate implementation, load, extraction, Go build or toolchain change was
admitted.

## Question, authority and inputs

Question: can direct driver runtime stacks or available syscall transitions
distinguish containment/input metadata processing from cache storage/locking
during the unfinished package actor? Such evidence could select a precise next
diagnosis; its absence leaves the cause open. Before consuming the one proposed
experiment, the brief required verifying both the flag and actual initialization.
That check found the blocker described here.

The packet started at 23:33 CT and was bounded by
2026-11-11T00:00:00-06:00. The AP-575 ticket snapshot was updated
2026-11-11T05:33:18Z and contained no linked requirement pages/scenarios. The
explicit PM cross-repository AP-575 anchor overrides `aa.config.yaml`'s default
AA project. Repository conventions, design, Tenets, Opinions, vocabulary and
spike guidance were read. This evidence-only report serves T-07/T-13; it changes
no product requirement and makes no product or framework Decision record.

- Preparation source was `fd03efd51941ff839d3c4e04e31216f337c14490`, tree
  `efa27086a8dfab78c98f1e9b1db5c0f74757b439`, clean tracked source. After AP-572
  merged, the one authorized catch-up rebase moved the report branch to main
  `52f522a2afc8ad4cbe90e5a548d9f063b1f28cf2`. This did not run a test/reprobe.
- Native Windows/amd64; PowerShell 7.6.10; normal Go 1.26.7 binary SHA-256
  `5463FE58FA999D74420F00EE1B36D31C3DA90A57FF204159F159859567AD61FC`.
  Installed source snapshots, source hashes, reference search and selected
  binary/module identities are retained privately. The finding is from source
  control flow, not dynamic confirmation that the binary executed that path.
- The copied candidate wrapper's metadata-only preflight loaded retained normal
  worker PATH/PATHEXT and the existing Git-shell helper only inside its process.
  Git/sh resolved under `C:/Program Files/Git/bin`, Go under its normal installation.
  Effective GOFLAGS/GODEBUG/GOCACHEPROG were empty, GOENV absent, GOWORK/GOTMPDIR
  empty. No shared settings, keys or configuration were edited.
- Selected cache identity was the normal `C:/Users/richa/AppData/Local/go-build`
  and module cache `C:/Users/richa/go/pkg/mod`; retained trim marker `1794345480`
  had last-write 2026-11-10T21:18:00.9681006Z. This is a location/marker snapshot,
  not immutable cache contents or a new observation of cache activity.
- Generated embed data was absent. No refresh/build/test ran, so there is no new
  generated-input or test-binary identity to compare with prior experiments.
- The first low-impact SSH preflight used explicit native OpenSSH, the existing
  config, lowercase `devtest`, BatchMode=yes and ConnectTimeout=10. `hostname`
  returned `DevTest`, exit 0. No DevTest container or service was changed.

## Installed-source evidence

All paths below are relative to `C:/Program Files/Go/`. Exact snapshots include
the surrounding functions, not only the quoted lines.

| Order | Installed source | Observed control flow |
| --- | --- | --- |
| Registration | `src/cmd/go/internal/test/testflag.go:33` and `internal/work/build.go:358` | Test initialization calls AddBuildFlags, which registers DebugRuntimeTrace with an empty default. |
| Custom command | `src/cmd/go/internal/test/test.go:50` | CmdTest sets CustomFlags to true. |
| Early dispatch | `src/cmd/go/main.go:313-321` | CustomFlags commands skip SetFromGOFLAGS and Flag.Parse here; only the argument slice changes. |
| Runtime initializer | `src/cmd/go/main.go:324-335` | If DebugRuntimeTrace is nonempty, create the file and call runtime/trace.Start; this check occurs before cmd.Run at line 342. |
| Late parsing | `src/cmd/go/internal/test/test.go:686`, `testflag.go:230,246` | runTest calls testFlags, which applies GOFLAGS and parses command flags through cmdflag.ParseOne. |
| Action initializer | `src/cmd/go/internal/test/test.go:689-701` | After parsing, runTest explicitly starts the action trace only; it has no equivalent runtime-trace initializer. |

The complete `cmd/go` reference search finds the DebugRuntimeTrace declaration
in `internal/cfg/cfg.go:107`, its empty-default registration in work/build.go,
and its sole runtime initialization in main.go. There is no second initializer
after testFlags. The custom parser eventually setting a registered string value
cannot retroactively execute the earlier check. Setting the same flag through
GOFLAGS would also occur in testFlags here; no settings workaround was attempted.

This explains the difference between discovering a flag and verifying it is
effective for the target command. AP-572's unexecuted proposal identified the
main.go initializer but did not establish that `go test` populated its value
before that point. AP-575 qualifies that proposal without changing AP-572's
measured fanout, original outcomes or accepted report.

| Key installed source | SHA-256 |
| --- | --- |
| `src/cmd/go/main.go` | `6EC309762D4A003ED4EC4965DD1010A06ED2CE29069F36C90330CB117AC29BAF` |
| `src/cmd/go/internal/test/test.go` | `3DFACCD644F4AC97129B3112834018216EBA50FD8359D831B103633656E2314C` |
| `src/cmd/go/internal/test/testflag.go` | `03DF0C3BE3EA79CAB3C4561B9034ECD047214E1E7491DA48EF7A11EB7D7622BE` |
| `src/cmd/go/internal/work/build.go` | `08741DC7C7502E6525FB54929AA0237919A7E096C7E0192A1F1B21BC19D19A3C` |

## Unexecuted candidate and cleanup boundary

The prepared command, from `src/aa-sdlc-cli`, was never admitted or executed:

```text
go test -json ./... -timeout=90s -debug-trace=<private-packet>/driver-trace.json -debug-runtime-trace=<private-packet>/runtime.trace
```

Relative to AP-571 this would add driver runtime tracing; relative to AP-572 it
would also omit `-work`. The private candidate copied the reviewed native job
bytes, SHA-256
`6A82D5C4493459B7186B6D648FDA96A9878C1E07B167B765AC0B988DE53ED9F1`:
suspended creation, assignment to a no-breakaway KILL_ON_JOB_CLOSE job, timer
before resume, driver 150s and outer 175s plus max 5s cleanup. These are prepared
controls, not executed containment/cleanup receipts for AP-575. The candidate
was withheld once source inspection showed the requested trace would not start.

No CPU SLOT was requested/admitted and no native experimental job/owned WORK
was created. Consequently there is no experimental jobzero/PID-absence or
DONE-CPU receipt to claim. No raw runtime/action trace exists to decode; extraction
was not run. Original prior streams/truncated traces were neither repaired nor
overwritten. No cache clear, extension, retry-to-green, matrix, installation,
administrator action, whole-system trace or kill by process name occurred.

## AP-572 interpretation qualifier and retained outcomes

AP-572's 370,767 stat/open records and 366,325 normalized lexical-outside
candidates are full-log analysis aggregates. Its lowercase/slash-normalized
grouping is an analysis convention. Installed `cmd/go/internal/str/path.go:34`
documents HasFilePathPrefix as case-sensitive beyond volume names. Thus those
groups are not exact Go lexical-containment classifications, fast/slow-path
counts, eventual `InDir` outcomes or driver replay progress. Symlink resolution
and errors further affect actual containment. No new fanout/case-variance matrix
or recomputation was performed here. The conditional component-visit model does
not become an observed syscall count or time allocation.

AP-571 remains driver exit 124 / NONPASS. AP-572 remains driver exit 124 / NONPASS
and original wrapper exit 1 / capture setup failure; its separately admitted postterminal capture
repair succeeded without a Go rerun. The prior successful service CI is separate
and changes none of those native outcomes. Metadata fanout remains a plausible
candidate; no actual stack in this packet chooses it over cache storage/locking.

The next work must establish functioning driver observability for the actual
test command before admitting another replay. No alternate profiling route was
validated or assigned here. Any new method, driver/toolchain implementation,
settings change, bounded extraction budget or load requires a separately scoped
plan and admission. PM retains the precise-hotspot/cause remainder; there is no
fix, product-code authorization, promotion or release claim.

## Evidence and validation

The single [evidence index](../../.aitemp/pm/ap575/evidence-index.md) and real
recursive SHA-256/length inventory are private under
`C:/Dev/ado/devpossible/OpenSource/aa-sldc-wt/ap575/.aitemp/pm/ap575/`.
They identify authority, ticket snapshot, source snapshots/search, selected
tool/cache/preflight inputs, withheld harness, prior canonical references and
report checks. Raw command/path/settings details stay private. AP-572 was first
read at its frozen worker head `18e32ac1`; after PM retired that worker, references
were verified against canonical `aa-sldc/.aitemp/pm/ap572-merged/`. No canonical
or other worker artifact was edited.

Only this report is tracked. Author checks cover report UTF-8/LF/final newline,
no tabs/trailing whitespace and `git diff --check`, plus matching retained
source snapshots to their recorded hashes. Full local build/lint/test tiers
were deliberately not run under the confirmed report-only scope. Normal
automatic MR service CI, if present, is separate delivery evidence; no manual
retry is authorized. Independent review, merge and durable proof preservation
belong to PM.

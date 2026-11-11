# AP-572: Go test-input metadata fanout

Anchor: [AP-572](https://devpossible.atlassian.net/browse/AP-572), following
[AP-571](AP-571-go-driver-tail.md) and
[AP-553](https://devpossible.atlassian.net/browse/AP-553). Author investigation
on 2026-11-10 Chicago time; PM owns independent review, Jira and merge.

The retained logs **support metadata-input fanout as a plausible contributor**
to the Windows Go driver's large OtherIO count. They contain 370,767 stat/open
records, including 366,325 paths lexically outside the CLI module. Those outside
paths are significant: installed Go checks containment with `search.InDir`,
which can resolve symlinks for both the input path and module root before
excluding an input. This supplies a concrete multiplicative metadata-work
candidate beyond the smaller set of in-module stat/hash operations.

This is not a measured stack, syscall hotspot, cache cause or fix. The single
Go experiment ended **driver exit 124 / NONPASS** at its 150-second deadline.
The original capture wrapper exited 1 because it expected `WORK=` on stderr,
while this Go version emitted it as a JSON build-output event on stdout. A
separately authorized postterminal repair recovered the original logs and
cleaned only the verified owned WORK. That salvage does not change either
original failure outcome. No second Go experiment ran.

## Question, scope and exact inputs

Question: does one retained pair of `plugincmd`/`updatecmd` test-input logs show
enough repetition/fanout to support AP-571's large OtherIO observation? Support
would prioritize direct observation of containment/input metadata processing;
otherwise cache storage/locking or another phase would remain the next target.
The precise cause remains unresolved in either case until directly observed.

The packet's time box was 45 minutes from 23:12:57 CT, with an owner cutoff at
midnight. The ticket snapshot was updated 2026-11-11T05:12:44Z and had no linked
requirement pages or scenarios. The assigned brief and explicit PM admission
define the investigation. PM authorized AP-572 as the cross-repository anchor
despite the default AA project configuration. Repository conventions, design,
Tenets, Opinions, vocabulary and spike guidance were read. This evidence-only
report serves T-07/T-13 and makes no product decision requiring a Decision record.

- Source: `fd03efd51941ff839d3c4e04e31216f337c14490`, tree
  `efa27086a8dfab78c98f1e9b1db5c0f74757b439`, clean tracked source at admission.
  The full tree differs from AP-553/AP-571 through the merged AP-571 report.
  The comparison across `src/aa-sdlc-cli`, `src/aa-sdlc`, embed-generation script,
  requirement features and registry is empty. No product or Go source changed.
- Generated embed inputs started absent and were refreshed once using the
  existing `Sync-EmbeddedContent.ps1`, then recorded by file length/SHA-256
  before Go. A new worktree and new build-info metadata affect cache identity.
  This is not an identical historical binary/input/cache snapshot.
- Native Windows/amd64, PowerShell 7.6.10, Go 1.26.7. The normal Go binary SHA-256
  remained `5463FE58FA999D74420F00EE1B36D31C3DA90A57FF204159F159859567AD61FC`.
  Git and sh resolve to the normal Git/bin binaries. The wrapper alone loads
  retained AP-553 worker PATH/PATHEXT and applies the existing Git-shell helper.
  Selected tool, installed Go source and module-file hashes are retained.
- The normal shared Go build/module cache identities and trim marker are
  recorded in selected preflight metadata. Effective GOFLAGS, GODEBUG and
  GOCACHEPROG were empty; GOENV was absent; GOWORK/GOTMPDIR were empty. No global
  cache inventory, cache clearing, environment edit, override or upgrade occurred.
- The first read-only DevTest SSH attempt failed authentication. PM authorized
  one correction using the native OpenSSH absolute binary, explicit existing
  config and lowercase alias; it returned DevTest/Docker 29.9.3 and three
  existing running containers. Nothing was started or changed there. The native
  experiment used only the exclusive Titan CPU admission; AP566 was untouched.

From `src/aa-sdlc-cli`, the sole experimental command was:

```text
go test -json ./... -timeout=90s -work -debug-trace=<packet>/driver-trace.json
```

Relative to AP-571, `-work` retains the build directory and changes cleanup
behavior; the trace path is task-local. Action tracing and sampling have
overhead. No timing difference between packets is treated as an improvement.

## Native bound and original terminal outcomes

The private native harness is byte-identical to AP-571's independently reviewed
`OwnedJob.cs`. It starts the driver suspended, assigns a no-breakaway native job
with KILL_ON_JOB_CLOSE, arms its independent deadline, then resumes. Sampling
queries only this job. The outer supervisor retains the exact wrapper handle:
175 seconds plus at most five seconds to force/join it, max 180 seconds total
including the original capture/cleanup attempt. No process-name kill was used.

Exact admitted SHA-256 identities:

| Private input | SHA-256 |
| --- | --- |
| `OwnedJob.cs` | `6A82D5C4493459B7186B6D648FDA96A9878C1E07B167B765AC0B988DE53ED9F1` |
| `probe.ps1` | `5AAB67E0503F08768E97ADD04AC13276E7551B641AFA783F9B74A5B97268A851` |
| `supervise.ps1` | `B1451CCF5E04E630207EABF4464E8390E0C718BE9D56CE80D29DDAFFB1C9E9BD` |
| Corrected `capture-cleanup.ps1` | `7F917A9B96EB7D5DE2533771F0CBCAEEADC9BE34695194628C7C418FF27B857F` |

PM held the first capture version before any experiment, requiring both unique
target logs and identifying test mains to be copied/hash-verified before WORK
deletion, and rejection of reparse points before capture reads/copies. That
private setup correction and its old hashes are retained. The corrected bytes
above were admitted; they were not changed during the experiment.

All terminal times below are UTC on 2026-11-11:

| Receipt | Actual result |
| --- | --- |
| Wrapper | PID 51416, start 05:17:44.5859422Z |
| Driver | PID 37156, creation FILETIME `134388478677077633`, start receipt 05:17:47.7113398Z |
| Driver deadline | 05:20:17.7136219Z, owned job terminated with exit 124 |
| Driver join/jobzero | 05:20:17.7288850Z, joined, active 0; final members empty |
| Original WORK capture | Failed: expected stderr ownership receipt absent; no capture read/copy/deletion occurred |
| Wrapper join | 05:20:17.8694929Z, exit 1, 153.4103563 seconds; outer deadline did not fire |
| External exec session | 70863 joined exit 0, reporting supervisor completion only |
| Independent absence | 05:20:27.1144975Z; all 28 observed PID/creation pairs including wrapper absent |

The 90-second Go timeout bounds individual test execution, not the full driver.
The original wrapper failure and supervisor exit 0 are not suite success.

## Reproduced package tail

All 72 individual test/subtest PASS events appeared, with zero individual
failures/skips. Five no-test packages emitted skips. Package-pass events appeared
for `config`, `tools`, `targets`, `initcmd` and `updatecmd`; `plugincmd` remained
unfinished. The incomplete 13,365-event action trace has its package test-run
span open, alongside the enclosing builder/command spans. Logical trace IDs
are not native PIDs/threads. The raw trace was never completed on disk.

| Package | Printed `ok` UTC | Package-pass UTC | Delay after printed `ok` |
| --- | --- | --- | --- |
| `updatecmd` | 05:18:03.8625377 | 05:19:36.3012493 | 92.4387116 seconds |
| `plugincmd` | 05:18:17.1538925 | Absent at stop | 120.5597294 seconds to deadline |

The final silent sampled interval, 05:19:37.1931681Z to 05:20:17.7302396Z,
spans 40.5370715 seconds:

| Owned driver counter delta | Value |
| --- | --- |
| Kernel / user CPU | 39.375 / 1.796875 seconds |
| OtherIO operations / bytes | 3,019,971 / 68,025,612 |
| Read/write operations and bytes | All zero |

All 41 live samples in that interval contained only the verified driver and
console host. Sampling can miss short children; jobzero covers contained
descendants at terminal cleanup. These counters cannot name a syscall/path or
prove where the CPU ran. The full-driver cumulative OtherIO total was 14,966,637;
it is not interchangeable with the final interval delta. The unchanged trim
marker supplies no cache-storage/locking diagnosis.

## Capture failure and separately admitted salvage

The original stdout's first event, zero-based index 0, is the unique
`build-output` event containing `WORK=`. It has no Time/Package fields. Stderr
was empty. Installed `work/action.go:318` prints through the shell's printer;
`load/printer.go:49-53` selects JSON stdout for build JSON. Assuming a stderr
line was a capture setup error, not evidence of absent WORK.

A read-only observation during the run recorded the exact newly created root's
creation FILETIME `134388478681747377`, after driver creation. The candidate was
a direct numeric go-build child of the expected normal temporary directory,
with no root reparse point. No global Temp/cache enumeration or guessed path
cleanup occurred. The admitted capture failed safely and retained that directory.

After all original processes were absent, PM separately authorized one
postterminal capture repair with a 60-second total bound. A new ownership receipt
explicitly cites the original stdout SHA-256 and event index; it does not create
the missing stderr receipt or rewrite the original failure. Separate script and
receipt names preserve that history. Before reading/copying, the repair checked
exact root/prefix/creation and rejected reparse points. It required exactly one
target WORK directory per package and all four identifying-main/log copies,
hash-verified again before native PowerShell removal of only that exact WORK.

Repair wrapper PID 48884, creation FILETIME `134388481577749614`, started
05:22:37.7749614Z and joined exit 0 at 05:22:39.1838800Z in 1.4269393 seconds.
Its retained handle was verified; its 55-second deadline plus max five-second
join did not fire. A separate receipt verifies its absence. Exact WORK creation
was rechecked at 05:22:39.0259050Z; removal/absence completed at
05:22:39.1248384Z. No deletion rejection, retry or workaround occurred. The
original stream/trace/outcome/failure hashes and lengths remained unchanged.
This was a separately admitted capture salvage, not an extension or rerun of Go.

## Distinguishing input fanout

Both recovered test logs have the expected header and final newline. These are
test-operation records, not timestamps or a driver progress trace:

| Aggregate | `plugincmd` | `updatecmd` |
| --- | ---: | ---: |
| Raw log bytes | 16,081,385 | 5,743,656 |
| `stat` records | 281,454 | 74,998 |
| `open` records | 5,454 | 8,861 |
| `getenv` records | 792 | 206 |
| `chdir` records | 0 | 0 |
| Lexically in-module stat / open | 3,531 / 12 | 896 / 3 |
| Lexically outside-module stat / open | 277,923 / 5,442 | 74,102 / 8,858 |
| In-module operation/path groups | 296 | 309 |
| Outside operation/path groups, count only | 22,395 | 19,098 |
| Maximum outside group repetition | 84 | 114 |

The parser resolves relative names from each package's initial directory,
replaying chdir in order if present. It groups by operation and SHA-256 of
lowercase slash-normalized module-relative path. Outside names become aggregate
counts only. No environment names/values or raw outside paths are exported;
logged external paths were not read, statted or enumerated during analysis.

For example, the single in-module open group in each package has the following
hash/count; the full stat/open hash-group aggregate remains private in the packet:

| Package / operation | Module-relative path SHA-256 | Count |
| --- | --- | ---: |
| `plugincmd` / open | `D488963E103F00E87980B56C48567654CFD4758624D82A484384D2D2B909C030` | 12 |
| `updatecmd` / open | `21D266C1F9F532D48BB1F0733CB439CCEE13529877D3A72782421267C412638B` | 3 |

Independent Python and PowerShell static parsers agree on every operation,
lexical category and hashed in-module group, plus raw lengths/hashes and outside
group count/max repetition. This is an independent computation by the author,
not independent reviewer acceptance. Verification caught Windows device-name
normalization of relative NUL opens by .NET; the final parser uses Go-compatible
lexical joining for the observed path shapes. Initial derivations and verification
failures are retained separately. No raw log was changed to make parsing pass.

## What the fanout supports, and what it does not

Installed Go 1.26.7 source establishes this conditional mechanism:

- `test/test.go:2008-2064`: `computeTestInputsID` walks the recorded operations.
  Before stat/open hashing it calls `search.InDir(name, a.Package.Root)`.
- `search/search.go:549-594`: lexical containment returns quickly. Otherwise
  `InDir` evaluates symlinks for the input, then for the root unless an earlier
  canonicalized containment succeeds. Thus an ultimately excluded external
  input can still incur repeated metadata work.
- `path/filepath/symlink.go:16-105`: the walker calls Lstat per ordinary path
  component. On Windows, `symlink_windows.go:26-38,108-118` adds case
  normalization using FindFirstFile/FindClose. These are static call paths,
  not observed syscall counts or sampled stacks.

There are 366,325 lexically external stat/open candidates in the two complete
logs. The module root has eight components below its drive. **Conditionally**,
if one traversal reaches every candidate and root resolution follows its ordinary
eight-component path, repeated root walks alone model 2,930,600 component visits,
before input-path resolution and Windows name normalization. This establishes
plausible multiplicative scale; it does not equate those visits to OtherIO
operations or allocate them to the final silent interval.

No log timestamp says how far the terminated driver got, which entries it
replayed, whether a canonicalized external path entered the module, or how much
time any call consumed. Symlinks, errors, replay count, early returns and native
implementation details affect the model. In-module open expansion, cache writes,
locking and another phase remain possible contributors. The evidence strengthens
the containment-metadata candidate; it does not prove it dominates the tail or
exclude storage/locking. There is no accepted fix or product design decision.

## One next bounded observation, not executed

Propose a linked remainder for direct driver runtime-stack evidence: one freshly
admitted run with the same containment/deadlines and action trace, adding only
the installed, undocumented `-debug-runtime-trace=<packet>/runtime.trace` flag.
`cmd/go/main.go:324-335` starts runtime tracing in the driver itself; this is
distinct from test-binary `-cpuprofile`. Inspect available syscall-transition
stacks during the unfinished package actor for `search.InDir`/EvalSymlinks
versus cache storage/locking work. Record exact source/tool/cache inputs anew.
The flag was verified statically only. Additional overhead and forced termination
may leave a truncated or undecodable trace; preserve it unchanged and accept an
inconclusive result without extension/retry. No such command was admitted or run
in AP-572, and no new tool, installation or whole-system profiling is proposed.
PM owns retaining the precise-hotspot/cause requirement and approving any next
packet; this report closes only the distinguishing fanout observation.

## Evidence and validation

The single [evidence index](../../.aitemp/pm/ap572/evidence-index.md) is private
under `C:/Dev/ado/devpossible/OpenSource/aa-sldc-wt/ap572/.aitemp/pm/ap572/`.
It names exact admission inputs, source/tool/generated/cache identities, all
original streams/trace, native/absence receipts, original setup failure,
separate repair authority/scripts/receipts, hash-verified raw captures, derived
parsers/verification and the checksum inventory. Raw test-input data remains
task-local. PM must copy/hash-verify the complete proof before retirement.

| Original evidence | SHA-256 |
| --- | --- |
| `stdout.jsonl` | `07185B9B1329FD3A7AB5797022162989344649F3668E5B3DAFE4BED0332AD552` |
| Empty `stderr.log` | `E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855` |
| `plugincmd` raw test log | `557CB05C8F9F3944F4F0216A9084F30D9DDE7AA99E4D5767C4355867D9E6461B` |
| `updatecmd` raw test log | `0AF2883D54D7A65CDF3FD4C02CB53358A55EAB695D0986E97E6D0D82282955B7` |

Canonical AP-571/AP-553 proof remains unchanged, referenced and hash-identified
in place. AP-571 driver124/NONPASS, AP-553 stopped cached NONPASS, historical
uncached/Windows passes and successful service CI remain distinct outcomes.
No successful CI run reclassifies this native experiment or its setup failure.

Only this report is tracked. Author validation uses report text conventions,
`git diff --check` and static recomputation of the reported counts. Full local
build/lint/test tiers were not rerun for this evidence-only change. Normal
automatic service CI, if run for the MR, is a separate result; no manual retry
is authorized. Independent acceptance, merge and release are unclaimed.

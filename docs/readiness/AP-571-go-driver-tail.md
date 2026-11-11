# AP-571: Windows Go driver tail

Anchor: [AP-571](https://devpossible.atlassian.net/browse/AP-571), follow-up to
[AP-553](https://devpossible.atlassian.net/browse/AP-553). Author investigation on
2026-11-10; independent review, Jira updates and merge belong to PM.

The single admitted experiment reproduced a silent, CPU-active Go driver after
all 72 individual test/subtest PASS events. It was **NONPASS**: the owned driver
was terminated at its 150-second external deadline with exit 124. Five of six
test-bearing packages emitted package-pass events. The remaining `plugincmd`
test-run action was still open. This was unfinished package processing, not a
completed suite waiting only for final driver exit.

The leading inference is result-cache finalization inside package test-run
actions. The measured distinction is sustained kernel CPU and Other IO operations
with no additional read/write operations in the final silent interval. No sampled
stack, syscall name, file path or precise cache hotspot was obtained. There is no
proven deadlock, cache cause, fix, full-suite success or release qualification.

## Question and boundary

Can one bounded native Windows observation distinguish driver work after test
events from live test children, and localize that work enough to choose the next
experiment? Identifying a specific phase would guide targeted diagnosis; failing
to localize it would leave the hypothesis unresolved without changing product
behavior. The packet had a 45-minute time box; its first recorded preparation
timestamp was 22:52:55.3003909 CT. The admitted
load occupied 152.7556665 seconds including wrapper startup and cleanup.

PM explicitly authorized AP-571 as the cross-repository anchor despite
`aa.config.yaml` selecting AA by default. The ticket read at start was updated
2026-11-11T04:52:43Z and had no linked requirement pages or scenarios. The approved
brief supplies the investigation boundary. Repository design, Tenets, Opinions,
vocabulary and the spike guidance were read. This evidence-only finding serves
T-07 and T-13; it makes no product or framework decision requiring a new Decision
record.

The only tracked delivery is this report. Throwaway harness and raw proof remain
under `.aitemp/pm/ap571/`; none is production code or a test-launcher change.
There was one Go test experiment, no matrix or retry. No cache clearing, tool
installation/upgrade, shared environment edit, repack, release, service restart
or kill by process name occurred.

## Exact inputs and instrumentation

- Source: `48d08c4941d3890e113d43148f862bb9217f645d`, initially clean tracked tree.
  Its tree `60de047ea00504957fc77a8f059aa89189559a1b` equals the tree of AP-553's
  `c29dce8f0700df8fe2ab09a0c1f8c519f985fb4a`; the full comparison diff is empty.
  `Sync-EmbeddedContent.ps1` refreshed ignored embed data before Go. Tracked source
  remained unchanged. `embedded-manifest.json` identifies generated inputs,
  including build metadata. A new worktree path and regenerated metadata mean
  this is not an identical historical cache state or built artifact.
- Native Windows/amd64, PowerShell 7.6.10, Go 1.26.7 at
  `C:/Program Files/Go/bin/go.exe`, SHA-256
  `5463FE58FA999D74420F00EE1B36D31C3DA90A57FF204159F159859567AD61FC`.
  Git and `sh` resolve under `C:/Program Files/Git/bin/`. The isolated wrapper
  explicitly loads AP-553's retained normal worker PATH/PATHEXT, then applies
  the existing Git-shell helper. Relevant paths/extensions and selected tool
  hashes are retained; no whole-environment or credential dump was exported.
- Cache: `C:/Users/richa/AppData/Local/go-build`; module cache:
  `C:/Users/richa/go/pkg/mod`; GOROOT: `C:/Program Files/Go`; GOTOOLCHAIN `auto`,
  GOWORK empty. Selected effective GOFLAGS, GODEBUG and GOCACHEPROG were empty;
  the default GOENV file was absent. Cache identity is its path and retained
  `trim.txt`, not an immutable snapshot of shared cache contents. No global
  cache inventory or content hashing was performed.
- Existing tools were inspected first. Windows `wpr` was present but unused;
  the discovered `procdump.exe` was a zero-byte WindowsApps alias, not a verified
  usable profiler. No installation, EULA acceptance or administrator action was
  attempted. The installed Go source supplies an internal, unstable action trace
  with synchronous event writes. Native per-owned-process counters need no
  systemwide tracing. This action trace is not a runtime stack/CPU profile.
- Low-impact DevTest preflight: SSH reached `DevTest`; Docker server reported
  `29.9.3`; read-only inventory showed the existing AP566 candidate and three
  other running containers. Nothing was started or changed there. Profiling ran
  on the admitted native Windows/Titan lane; AP566 DevTest was untouched.

From `src/aa-sdlc-cli`, the one command was:

```text
go test -json ./... -timeout=90s -debug-trace=<task-local>/driver-trace.json
```

The driver starts suspended, is assigned to a new native job, and resumes only
after a 150-second independent termination timer is armed. The job disallows
breakaway and has KILL_ON_JOB_CLOSE. Only its process membership is sampled;
retained handles identify the created driver and wrapper. The outer supervisor
has a 175-second bound plus at most five seconds for joining its owned wrapper.
A harmless owned-process smoke first exercised the one-second job deadline:
exit 124, joined, active job count zero. It ran no Go tests.

Admitted SHA-256 identities:

| Task-local harness | SHA-256 |
| --- | --- |
| `probe.ps1` | `99BAD2ECE35D6BAD9E74135CCEF350098375254156D176B2A59E1D1F22F42B40` |
| `OwnedJob.cs` | `6A82D5C4493459B7186B6D648FDA96A9878C1E07B167B765AC0B988DE53ED9F1` |
| `supervise.ps1` | `5F3BA5B9C44057823B0D306FD1615C744026AC2BD38F222F64D0B4DE2961E2A0` |

## Distinguishing observation

Original JSON events separate printed test output from package completion:

| Package | Printed `ok` (UTC, 2026-11-11) | Package-pass event | Time after printed `ok` |
| --- | --- | --- | --- |
| `updatecmd` | 04:57:20.9513509 | 04:58:58.6641673 | 97.7128164 seconds |
| `plugincmd` | 04:57:36.8327221 | Absent at stop | 120.0324754 seconds to deadline |

All 72 individual test/subtest passes were present, with zero individual
failures/skips. Five package-level skips were packages with no test files.
Package-pass events were present for `config`, `targets`, `tools`, `initcmd`,
and finally `updatecmd`. No package-pass event was present for `plugincmd`.

The action trace has these exact events (`ts` is Unix microseconds):

| Action | Logical `tid` | Begin `ts` | End `ts` |
| --- | --- | --- | --- |
| `test run aasdlc.com/aa/internal/updatecmd` | 2 | 1794373029831956.8 | 1794373138664167.5 |
| `test run aasdlc.com/aa/internal/plugincmd` | 11 | 1794373029767302.5 | Absent at stop |

Both spans were open during the earlier silent interval; only `plugincmd`
remained open after `updatecmd` completed. The enclosing `exec.Builder.Do
(go test )` and `Running test command` spans were also open at stop. Trace
`pid=0` and `tid` are logical trace identifiers, not native PIDs or OS threads.

After the final event at 04:58:58.6641673Z, the sampled interval
04:58:59.3548665Z to 04:59:36.8823894Z spans 37.5275229 seconds:

| Driver counter delta over that interval | Measured value |
| --- | --- |
| Kernel CPU | 36.046875 seconds |
| User CPU | 1.484375 seconds |
| Other IO operations / bytes | 2,550,217 / 57,431,254 |
| Read operations / read bytes | 0 / 0 |
| Write operations / write bytes | 0 / 0 |

All 38 samples in this final interval had two owned job members: driver 66588
and console host 76152, whose paths and creation identities were verified.
There were no test children in those samples. Earlier cumulative driver totals
are retained but are not used as proof of a hotspot. Other IO includes control
and metadata operations and cannot identify particular filesystem calls or
paths; kernel time is not a stack profile. One-second snapshots can miss short
children, while native job containment still covers their lifetime and cleanup.

`trim.txt` remained `1794345480`, length 10, last-write
2026-11-10T21:18:00.9681006Z. This marker alone neither profiles nor excludes
cache work. Together with the still-open package run actions, it provides no
evidence for a completed action graph stuck only in final cache trimming.

## Installed Go source supporting the inference

Paths below are under the recorded `C:/Program Files/Go` installation. These
are static control-flow observations, not measured stacks:

- `src/cmd/go/internal/test/test.go:1731` prints package `ok`; line 1732 calls
  `r.c.saveOutput(a)`. The JSON converter's exit/close is deferred at lines
  1483-1486. Thus printed `ok` precedes result-cache saving and final
  package-pass emission. `saveOutput` starts at line 2158 and calls
  `computeTestInputsID` at line 2175 before storing cache entries.
- `test.go:2008` computes test-input identity from recorded getenv/chdir/stat/open
  operations. `hashOpen` at line 2084 uses stat/directory-entry metadata rather
  than hashing regular-file contents. That makes input metadata work a candidate
  consistent with the counter shape, without proving it is the expensive call.
- `src/cmd/go/internal/work/exec.go:148` starts an action span; lines 153-154
  execute the actor and finish the span. Lines 74-85 register cache Close/Trim
  at the end of Builder.Do. The unfinished package actors therefore narrow the
  observation earlier than final whole-graph cleanup.

| Installed source | SHA-256 |
| --- | --- |
| `src/cmd/go/internal/test/test.go` | `3DFACCD644F4AC97129B3112834018216EBA50FD8359D831B103633656E2314C` |
| `src/cmd/go/internal/work/exec.go` | `E1BE568F9B0FAA30BC065CDDFE433628A21FC55C52B17938038B153EE7E118C2` |
| `src/cmd/go/internal/cache/cache.go` | `22DA4896758772A443D90DD148719866D20E811BFEFD3668597EAE083B6F39B2` |
| `src/cmd/go/internal/trace/trace.go` | `530B8C495EFB185B883053A92244A9B4A74B79129AB934B96CD613B99A07BDD0` |

The original 13,565-event trace ends without its closing array delimiter because
the deadline terminated the driver. It is retained unchanged. The static parser
appends a closing delimiter only to an in-memory copy and records
`TraceComplete=false`; derived span summaries do not turn missing end events
into completed actions. Instrumentation overhead and the differing cache/input
state limit comparison with historical timing.

## Terminal outcomes and cleanup

All times are UTC on 2026-11-11:

| Receipt | Actual outcome |
| --- | --- |
| Wrapper start | PID 64852, 04:57:04.1819610Z |
| Driver start | PID 66588, creation FILETIME `134388466268512779`, start receipt 04:57:06.8561051Z |
| Driver deadline | Fired 04:59:36.8651975Z; owned job terminated with code 124 |
| Driver join | Recorded 04:59:36.8810319Z; exit 124; NONPASS |
| Final native job | ActiveJobProcesses 0; Members empty |
| Wrapper join | 04:59:36.9114280Z; exit 0; external deadline not fired; 152.7556665 seconds |
| Exec session join | Session 40760, exit 0; supervisor completed |
| Independent PID absence | 05:00:05.0764864Z; all 28 observed PID/creation pairs, including wrapper, absent |

Wrapper exit 0 reports successful evidence capture and containment, not passing
tests. The final counter snapshot was taken after termination/join. Native job
active count zero covers all job descendants, including short-lived processes
missed by sampling. The separate absence check queries only observed PIDs and
compares creation time if present; none was present. No owned load remains and
DONE-CPU was sent to PM. The 90-second Go test timeout was not a whole-driver
bound. There was no extension or second test command.

## AP-553 comparison and retained failures

The original AP-553 cached log likewise contains **72 individual test/subtest
passes but only four package-pass events**: `config`, `targets`, `tools`,
`initcmd`. `plugincmd` and `updatecmd` printed `ok` without package-pass events.
This corrects any reading of “all PASS events” as a completed suite or a delay
only in final driver exit. Its original externally stopped 175.325016-second
run remains NONPASS. Its cleanup failures and corrected receipts remain intact.

AP-553's uncached 95.2882369-second pass, later real Windows root-unit
32.3144863-second pass, and exact-head Linux CI integration success are separate
outcomes. Historical main reports of cached silence eventually passing after
more than ten minutes remain reported history, not newly replayed raw proof.
None establishes a stack hotspot or changes either timed-out cached outcome.

## One proposed next experiment

Not executed or admitted here: retain the same bounded action-traced command
with the single addition `-work`, preserving Go's owned WORK directory. Aggregate
the `plugincmd`/`updatecmd` test-input logs by operation type and hashed
module-relative path; do not export environment values or raw outside paths.
The distinguishing observation is whether repeated metadata-input fanout in
those packages can explain the large Other-IO interval, or whether the candidate
must remain cache storage/locking or another phase. This would narrow the next
profiling target rather than prove causation or produce a fix. `-work` changes
cleanup behavior and must be disclosed; it requires fresh admission, exact
input/cache identities, a whole-command bound and verified owned-directory
cleanup. No additional experiment or tool change belongs to this packet.

## Evidence and validation

The single [evidence index](../../.aitemp/pm/ap571/evidence-index.md) is local,
under `C:/Dev/ado/devpossible/OpenSource/aa-sldc-wt/ap571/.aitemp/pm/ap571/`.
It names original stdout/stderr, incomplete raw trace, samples, admitted harness,
source/tool/generated-input identities, terminal/absence receipts and derived
analysis. It also references preserved canonical AP-553 evidence at
`C:/Dev/ado/devpossible/OpenSource/aa-sldc/.aitemp/pm/ap553-merged/`.
Task-local evidence is deliberately excluded from the source-only merge; PM
retains it for independent review.

Original stream/trace SHA-256 fingerprints:

| Evidence | SHA-256 |
| --- | --- |
| `stdout.jsonl` | `884A8FD0BE57B17ECF42EDF7AFD6DB3DF8CF108CE70779F77E5B6423FA17FAB4` |
| Empty `stderr.log` | `E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855` |
| Incomplete `driver-trace.json` | `8A2602653DA71F68A2584DEDF4D437E33E5DE55756C4BC328232D4E3F381457D` |

Author verification for this report uses changed-file text conventions and
`git diff --check`. Full build/lint/test tiers were not rerun: this changes only
the investigation report, and the admitted native experiment already ended
NONPASS. Automatic service-CI results, if any, belong to the merge request and
must remain distinct from this experiment. Independent acceptance, merge and
release are unclaimed.

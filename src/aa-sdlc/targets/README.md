# Targets

The agent harnesses the `aa` CLI installs into are data, in [targets.yaml](targets.yaml): for each
harness, how it is detected, the folders it reads skills from at user and project scope, whether it
needs command files and in which format, the instruction file it reads, whether it supports
subagents, and the documentation the entry was taken from (decision record 0014). Skills ship
unchanged to every harness; only these facts differ.

`verified: true` means the install has been tried in the harness itself. The others follow their
documentation, which changes often; when a harness moves a folder, fix its row here.

Adding a harness is a new row. A new command format is a code change in
`src/aa-sdlc-cli/internal/targets/`.

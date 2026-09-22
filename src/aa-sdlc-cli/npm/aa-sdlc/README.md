# aa-sdlc

The `aa` command line for the [AA-SDLC](https://aasdlc.com) framework. Agent skills and
commands that implement an opinionated software development life cycle; this package installs
them into your agent and bootstraps your repositories.

```
npm install -g aa-sdlc
aa setup                          # once per machine: installs skills and commands for each agent found
cd my-project
aa init                           # once per repository: config, folders, script stubs, decision records
```

Then, inside your agent, run `/aa-fw-health` and `/aa-fw-init`.

`aa` is a native binary. This package carries one launcher and lists one optional dependency
per platform (`@aa-sdlc/cli-<os>-<arch>`); npm installs the one that matches your machine. The
content the CLI installs is compiled into the binary, so the CLI and the skills it installs
always version together.

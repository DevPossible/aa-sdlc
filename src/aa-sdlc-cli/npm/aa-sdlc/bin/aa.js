#!/usr/bin/env node
// The only JavaScript in this repository (decision record 0004). npm's "bin" entry must name one
// file that works on every platform, and a native binary cannot be that file for all of them, so
// this launcher finds the platform package that npm installed as an optional dependency and
// execs its binary with the same arguments, stdio, and exit code. No dependencies, no logic.
"use strict";
const { spawnSync } = require("child_process");
const path = require("path");

const pkg = `@aa-sdlc/cli-${process.platform}-${process.arch}`;
let dir;
try {
  dir = path.dirname(require.resolve(`${pkg}/package.json`));
} catch {
  process.stderr.write(
    `aa: no binary for ${process.platform}-${process.arch}. ` +
      `Expected the optional dependency ${pkg}; reinstall with optional dependencies enabled, ` +
      `or install that package directly.\n`
  );
  process.exit(1);
}
const exe = path.join(dir, "bin", process.platform === "win32" ? "aa.exe" : "aa");
const result = spawnSync(exe, process.argv.slice(2), { stdio: "inherit" });
if (result.error) {
  process.stderr.write(`aa: could not start ${exe}: ${result.error.message}\n`);
  process.exit(1);
}
process.exit(result.status === null ? 1 : result.status);

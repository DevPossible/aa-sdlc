# Targets

Per-target adapter templates, one folder per target (for example `claude-code`, `codex`,
`gemini-cli`, `opencode`, `pi`, `cursor`, `hermes`, `openclaw`). Only `claude-code` exists today. Only what differs per target belongs here: install locations,
command declaration format, hooks, and subagent definitions. Skills themselves ship unchanged.

# Plugins

Optional packs that add skills, commands, or workflow steps without changing core. Three kinds:
tech-stack packs (for example `dotnet`), tool packs (for example `prettier`, `k6`), and process
packs (for example a compliance review). Every plugin skill names the core step, process, or
requirement it attaches to. Plugins never wrap the ticket system, wiki, or source control.

The core package ships no plugins. The optional plugins this project maintains live in the
`aa-sdlc-plugins` repository (decision record 0013).

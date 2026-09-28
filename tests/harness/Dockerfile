# One Linux image with every agent harness that can be installed headless, for the harness tier
# (test.ps1 -Tier harness). Each harness is installed from its own published package or install
# script; one that fails to install is recorded, not fatal, so the tier reports it as not
# installable rather than stopping. No harness is signed in and no model is called: the tier checks
# detection, the files aa writes, and the folders each harness's own code names.
FROM node:22-bookworm

RUN apt-get update -qq \
 && apt-get install -y -qq --no-install-recommends ca-certificates curl wget git python3 python3-pip pipx > /dev/null \
 && wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/ms.deb \
 && dpkg -i /tmp/ms.deb > /dev/null && apt-get update -qq && apt-get install -y -qq powershell > /dev/null \
 && pwsh -NoProfile -Command "Install-Module powershell-yaml -Scope AllUsers -Force" \
 && rm -rf /var/lib/apt/lists/*

# Harnesses published on npm, one layer each so a failure is isolated and cached separately
RUN npm install -g @anthropic-ai/claude-code > /dev/null 2>&1 && echo claude-code >> /harnesses.txt || echo "claude-code failed" >> /harness-failures.txt
RUN npm install -g @openai/codex > /dev/null 2>&1 && echo codex >> /harnesses.txt || echo "codex failed" >> /harness-failures.txt
RUN npm install -g @google/gemini-cli > /dev/null 2>&1 && echo gemini-cli >> /harnesses.txt || echo "gemini-cli failed" >> /harness-failures.txt
RUN npm install -g opencode-ai > /dev/null 2>&1 && echo opencode >> /harnesses.txt || echo "opencode failed" >> /harness-failures.txt
RUN npm install -g @qwen-code/qwen-code > /dev/null 2>&1 && echo qwen-code >> /harnesses.txt || echo "qwen-code failed" >> /harness-failures.txt
RUN npm install -g @github/copilot > /dev/null 2>&1 && echo copilot >> /harnesses.txt || echo "copilot failed" >> /harness-failures.txt
RUN npm install -g @charmland/crush > /dev/null 2>&1 && echo crush >> /harnesses.txt || echo "crush failed" >> /harness-failures.txt
RUN npm install -g @sourcegraph/amp > /dev/null 2>&1 && echo amp >> /harnesses.txt || echo "amp failed" >> /harness-failures.txt
RUN npm install -g @kilocode/cli > /dev/null 2>&1 && echo kilo >> /harnesses.txt || echo "kilo failed" >> /harness-failures.txt
RUN npm install -g cline > /dev/null 2>&1 && echo cline >> /harnesses.txt || echo "cline failed" >> /harness-failures.txt
RUN npm install -g @augmentcode/auggie > /dev/null 2>&1 && echo auggie >> /harnesses.txt || echo "auggie failed" >> /harness-failures.txt
RUN npm install -g @mariozechner/pi-coding-agent > /dev/null 2>&1 && echo pi >> /harnesses.txt || echo "pi failed" >> /harness-failures.txt
RUN npm install -g droid > /dev/null 2>&1 && echo factory >> /harnesses.txt || echo "factory failed" >> /harness-failures.txt
RUN npm install -g @jetbrains/junie > /dev/null 2>&1 && echo junie >> /harnesses.txt || echo "junie failed" >> /harness-failures.txt

# Harnesses with their own install scripts
RUN (curl -fsSL https://cursor.com/install | bash > /dev/null 2>&1 && echo cursor >> /harnesses.txt) || echo "cursor failed" >> /harness-failures.txt
RUN (curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=false bash > /dev/null 2>&1 && echo goose >> /harnesses.txt) || echo "goose failed" >> /harness-failures.txt
RUN (curl -fsSL https://cli.kiro.dev/install | bash > /dev/null 2>&1 && echo kiro >> /harnesses.txt) || echo "kiro failed" >> /harness-failures.txt
RUN (pipx install hermes-agent > /dev/null 2>&1 && echo hermes >> /harnesses.txt) || echo "hermes failed" >> /harness-failures.txt

ENV PATH="/root/.local/bin:${PATH}"

# Some npm packages are loaders that fetch the harness itself on first run; run each once, with no
# sign-in and no model, so its real code is in the image for the evidence search
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends unzip > /dev/null && rm -rf /var/lib/apt/lists/*  && (timeout 120 copilot --version > /dev/null 2>&1 || true)  && (timeout 180 junie --version > /dev/null 2>&1 || true)
RUN touch /harnesses.txt /harness-failures.txt
WORKDIR /work

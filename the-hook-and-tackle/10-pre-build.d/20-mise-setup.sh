#!/usr/bin/env bash
set -euo pipefail

conf=""
if [[ -f "mise.toml" ]]; then conf="mise.toml"; fi
if [[ -z "$conf" && -f "mise/config.toml" ]]; then conf="mise/config.toml"; fi

if [[ -n "$conf" ]]; then
  echo "[mise-setup] using config: $conf"
  if ! command -v mise >/dev/null 2>&1; then
    echo "[mise-setup] installing mise"
    curl -fsSL https://mise.jdx.dev/install.sh | sh -s -- -y >/dev/null 2>&1 || true
    export PATH="$HOME/.local/share/mise/bin:$PATH"
    echo "PATH=$HOME/.local/share/mise/bin:$PATH" >> "$GITHUB_ENV"
  fi
  mise install
  eval "$(mise env -s bash)"
  mise env -s bash | sed -n 's/^export \([A-Za-z_][A-Za-z0-9_]*\)=\(.*\)$/\1=\2/p' >> "$GITHUB_ENV"
fi

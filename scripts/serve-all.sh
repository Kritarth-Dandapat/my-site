#!/usr/bin/env bash
# Start hub, notebook (static), and portfolio (Vite) for local preview.
# Usage: ./scripts/serve-all.sh
# Env:   HUB_PORT=8081 NOTEBOOK_PORT=8082 (optional overrides)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HUB_PORT="${HUB_PORT:-8081}"
NOTEBOOK_PORT="${NOTEBOOK_PORT:-8082}"
PORTFOLIO_PORT="${PORTFOLIO_PORT:-3000}"

PIDS=()

cleanup() {
  echo ""
  echo "Stopping local servers…"
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
}

trap cleanup EXIT INT TERM HUP

if ! command -v python3 &>/dev/null; then
  echo "error: python3 is required to serve hub and notebook."
  exit 1
fi

cd "$ROOT/hub"
python3 -m http.server "$HUB_PORT" --bind 127.0.0.1 &
PIDS+=($!)

cd "$ROOT/notebook"
python3 -m http.server "$NOTEBOOK_PORT" --bind 127.0.0.1 &
PIDS+=($!)

if command -v npm &>/dev/null; then
  (cd "$ROOT/portfolio" && npm run dev -- --port "$PORTFOLIO_PORT" --host 127.0.0.1) &
  PIDS+=($!)
  PORTFOLIO_OK=1
else
  echo "warning: npm not in PATH; start portfolio yourself: cd portfolio && npm install && npm run dev"
  PORTFOLIO_OK=0
fi

sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Hub:       http://127.0.0.1:${HUB_PORT}/"
if [[ "${PORTFOLIO_OK}" -eq 1 ]]; then
  echo "  Portfolio: http://127.0.0.1:${PORTFOLIO_PORT}/"
fi
echo "  Notebook:  http://127.0.0.1:${NOTEBOOK_PORT}/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Hub still links to production portfolio/notebook in nav cards;"
echo "  use the URLs above for local copies. Ctrl+C stops servers."
echo ""

if [[ "$(uname -s)" == "Darwin" ]]; then
  open "http://127.0.0.1:${HUB_PORT}/"
  [[ "${PORTFOLIO_OK}" -eq 1 ]] && open "http://127.0.0.1:${PORTFOLIO_PORT}/"
  open "http://127.0.0.1:${NOTEBOOK_PORT}/"
fi

wait

#!/bin/sh
# ---------------------------------------------------------------------------
# SILENCE - local launcher (macOS / Linux).
#
# The form on contacts.html uses fetch(), and the page is built to run under
# a real HTTP origin (not file://) - this script starts a local server and
# opens the site in your browser.
# ---------------------------------------------------------------------------
set -e
cd "$(dirname "$0")"

PY=""
if command -v python3 >/dev/null 2>&1; then PY=python3
elif command -v python >/dev/null 2>&1; then PY=python
fi

if [ -z "$PY" ]; then
  echo ""
  echo "  Python was not found."
  echo "  Install it from https://www.python.org/downloads/ and run this script again."
  echo ""
  exit 1
fi

PORT=8080
while lsof -i ":$PORT" >/dev/null 2>&1; do
  PORT=$((PORT + 1))
  if [ "$PORT" -gt 8090 ]; then PORT=8080; break; fi
done

echo ""
echo "  SILENCE"
echo "  http://localhost:$PORT/index.html"
echo ""
echo "  Keep this window open while you use the site."
echo "  Press Ctrl+C to stop the server."
echo ""

( sleep 1
  if command -v open >/dev/null 2>&1; then open "http://localhost:$PORT/index.html"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "http://localhost:$PORT/index.html"
  fi
) &

"$PY" -m http.server "$PORT" --bind 127.0.0.1

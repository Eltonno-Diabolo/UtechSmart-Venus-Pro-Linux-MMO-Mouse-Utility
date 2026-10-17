#!/bin/sh
# Start an installed Venus Pro Config headlessly and fail if it crashes or
# prints a traceback during startup. No mouse is needed.
#   smoke-test.sh [command...]    (default: venusprolinux)
set -u
[ $# -gt 0 ] || set -- venusprolinux
log="$(mktemp)"
QT_QPA_PLATFORM=offscreen timeout 10 "$@" >"$log" 2>&1
status=$?
cat "$log"
if [ "$status" -ne 0 ] && [ "$status" -ne 124 ]; then
    echo "smoke test: '$*' exited with status ${status}" >&2
    exit 1
fi
if grep -q Traceback "$log"; then
    echo "smoke test: '$*' printed a traceback" >&2
    exit 1
fi
echo "smoke test: '$*' started cleanly"

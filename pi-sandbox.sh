#!/usr/bin/env bash
set -euo pipefail

# Refuse to mount whole home directory by accident
if [ "$PWD" = "$HOME" ] || [ "$PWD" = "/" ]; then
    echo "Run this from inside a project directory, not $PWD" >&2
    exit 1
fi

mkdir -p "$HOME/.pi"

exec docker run --rm -it --init \
    --network host \
    --cap-drop ALL \
    --security-opt no-new-privileges:true \
    --pids-limit 2048 \
    -v "$HOME/.pi:/home/pi/.pi" \
    -v "$PWD:/workspace" \
    pi-agent:local "$@"

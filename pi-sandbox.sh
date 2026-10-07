set -euo pipefail

# Refuse to mount whole home directory by accident
if [ "$PWD" = "$HOME" ] || [ "$PWD" = "/" ]; then
    echo "Run this from inside a project directory, not $PWD" >&2
    exit 1
fi

exec docker run --rm -it \
    --network host \
    --cap-drop ALL \
    --security-opt no-new-privileges:true \
    -v "$HOME/.pi:/home/pi/.pi" \
    -v "$PWD:/workspace" \
    pi-agent:local "$@"

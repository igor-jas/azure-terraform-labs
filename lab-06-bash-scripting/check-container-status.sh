#!/bin/bash
# check-container-status.sh
# Checks whether a given Docker container is running and whether it responds on a given port.
CONTAINER_NAME=$1
PORT=$2
if [ -z "$CONTAINER_NAME" ] || [ -z "$PORT" ]; then
    echo "Usage: ./check-container-status.sh <container_name> <port>"
    exit 1
fi

if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[OK] Container '$CONTAINER_NAME' is running."
else
    echo "[ERROR] Container '$CONTAINER_NAME' is NOT running."
    exit 1
fi

if nc -z localhost "$PORT" 2>/dev/null; then
    echo "[OK] Port $PORT is responding."
else
    echo "[WARN]  Container is running, but port $PORT is not responding."
    exit 1
fi

echo "[SUCCESS] All checks passed for '$CONTAINER_NAME' on port $PORT."
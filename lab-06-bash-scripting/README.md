# Bash Container Status Check - Lab 06

This lab demonstrates a practical Bash script that checks whether a Docker
container is running and whether it responds on a given port, building on
the containerized Flask app from Lab 05.

## What this lab creates

- A Bash script (`check-container-status.sh`) that:
  - Accepts a container name and port as arguments
  - Validates that both arguments were provided
  - Checks whether the specified container is currently running
  - Checks whether the specified port is responding
  - Returns a clear success or failure message, with an appropriate exit code

## Technologies used

- Bash
- Docker
- WSL2 (Ubuntu)
- netcat (`nc`) for port checking

## Script

```bash
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
    echo "[WARN] Container is running, but port $PORT is not responding."
    exit 1
fi

echo "[SUCCESS] All checks passed for '$CONTAINER_NAME' on port $PORT."
```

## Usage

```bash
chmod +x check-container-status.sh
./check-container-status.sh igor-flask-container 5000
```

## Verification

Tested against three scenarios:

- **Container running and port responding** — all checks pass, exit code `0`
- **Container not running** — script reports failure, exit code `1`
- **Missing arguments** — script prints usage instructions, exit code `1`

## Notes

The script relies on `docker ps` and `nc`, so it is intended to run in an
environment with Docker CLI access (in this case, via WSL2 with Docker
Desktop's WSL integration enabled) and `netcat` installed.
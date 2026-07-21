# Docker + Flask Web App - Lab 05

This lab demonstrates how to containerize a simple Python web application using
a custom Dockerfile, moving beyond the prebuilt public images used in previous
labs (e.g. the `nginx:latest` image in Lab 04).

## What this lab creates

- A minimal Flask web application (`app.py`)
- A custom Docker image built from a self-written `Dockerfile`
- A running Docker container serving the Flask app on port 5000

## Technologies used

- Python 3.14
- Flask
- Docker
- uv (Python package/environment manager)
- PowerShell

## Architecture

Unlike Lab 04, where the container image (`nginx:latest`) was pulled ready-made
from Docker Hub, this lab builds a custom image from scratch:

- The base image (`python:3.14-slim`) provides a minimal Python runtime
- Application dependencies (`requirements.txt`) are installed inside the image
  during the build step
- The application code (`app.py`) is copied into the image afterward
- The container listens on `0.0.0.0:5000`, and port 5000 is mapped to the host

Dependencies are installed before copying the application code so that Docker
can reuse the cached dependency layer when only the app code changes, avoiding
unnecessary reinstalls on rebuild.

## Dockerfile

```dockerfile
FROM python:3.14-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

## Local development setup

A local virtual environment was used for development and testing before
containerizing the app:

```powershell
uv venv
.venv\Scripts\Activate.ps1
uv pip install flask
uv pip freeze > requirements.txt
uv run python app.py
```

## Build and run

```powershell
docker build -t igor-flask-app .
docker run -d -p 5000:5000 --name igor-flask-container igor-flask-app
```

The app is then available at `http://localhost:5000`.

## Verification

- `docker build` — success, image built in ~10s
- `docker run` — container started successfully
- `docker ps` — container confirmed running with port mapping `0.0.0.0:5000->5000/tcp`
- Verified in browser at `http://localhost:5000` — returns expected response

## Comparison to Lab 04

| Aspect | Lab 04 (ACI + Nginx) | Lab 05 (Docker + Flask) |
|---|---|---|
| Image source | Public image (`nginx:latest`) | Custom-built image (own `Dockerfile`) |
| Application code | None (static Nginx page) | Custom Python/Flask app |
| Environment | Azure Container Instances | Local Docker (no cloud dependency) |
| Dependency management | N/A | `requirements.txt` |
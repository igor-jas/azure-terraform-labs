# Capstone: Terraform + Ansible + Docker + Flask - Lab 11

This lab ties together Terraform, Docker, and Ansible into a single end-to-end pipeline: Terraform provisions a server, Ansible configures it and installs Docker on it, and that Docker instance builds and runs a containerized Flask app (from Lab 05). It complements the earlier labs by showing how infrastructure provisioning, configuration management, and containerization fit together in one workflow rather than as isolated exercises.

## What this lab creates

A Terraform configuration that builds a custom Docker image (Ubuntu with SSH enabled) and provisions a container acting as a standalone server. An Ansible playbook that connects to that server over SSH, installs Docker inside it, starts the Docker daemon, copies over the Flask app from Lab 05, and builds and runs it as a nested container. The Flask app is reachable from the host at `http://localhost:5001`.

## Technologies used

Terraform (`kreuzwerker/docker` provider), Docker, Ansible, Flask.

## Architecture

Terraform provisions the outer container using a custom Dockerfile rather than a bare `ubuntu:22.04` image, since a plain image has no long-running process and exits immediately after creation. The container runs in privileged mode and exposes SSH on port 2222 and the app on port 5001. Ansible then connects over SSH and runs a playbook that installs Docker inside the container, starts the Docker daemon manually (there's no systemd available to manage it as a service), copies the Flask app from `lab-05-docker-flask`, and builds and runs it as a nested container using the `docker` CLI directly, with `DOCKER_HOST` pointed at the inner daemon's socket.

See `terraform/main.tf`, `docker-server/Dockerfile`, `ansible/inventory.ini`, and `ansible/playbook.yml` for the full configuration.

## Setup and execution

```bash
cd terraform
terraform init
terraform apply

cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```

## Why a local Docker container instead of a cloud VM

This lab runs entirely locally instead of provisioning a real Azure VM, to avoid cloud costs. The Terraform provider used is `kreuzwerker/docker` rather than `azurerm`, and the "server" is a privileged Docker container running its own nested Docker daemon. This is functionally equivalent to a real VM for the purposes of this exercise.

## Notes on issues encountered running Docker inside Docker

Running a Docker daemon inside a Docker container surfaced several problems that don't come up on a real VM. A bare Ubuntu image exits immediately after being created, since it has no foreground process to keep it alive, so the server image runs `sshd -D` instead. There's no systemd inside the container, so the Docker daemon can't be managed with `service docker start`; it's started manually with `nohup dockerd &` instead. The nested daemon initially failed with an `iptables: Permission denied` error, since it needs low-level network privileges the container doesn't have by default, which was fixed by running the outer container in privileged mode. It then failed again trying to build the Flask image, this time because its default OverlayFS storage driver conflicts with the host's own OverlayFS; switching the nested daemon to `--storage-driver=vfs` resolved it. Finally, port 5000 was already bound locally by macOS's ControlCenter, so the app is mapped to port 5001 externally instead.

## Verification

After the playbook completed with `failed=0`, the Flask container was confirmed running inside the server with `docker ps`, and the app responded correctly at `http://localhost:5001`, returning the expected message from `lab-05-docker-flask`.

## Status

This lab runs entirely on a local Docker container standing in for a real server. In a real-world scenario, the same Terraform and Ansible structure would target an actual cloud VM, with the Docker-in-Docker workarounds no longer necessary.
# Ansible Local Configuration - Lab 09

This lab uses Ansible to configure a local Nginx web server, demonstrating infrastructure configuration management and idempotency. It complements Terraform (Lab 01-04), which provisions infrastructure but doesn't configure what runs on it.

## What this lab creates

An Ansible inventory targeting localhost, a playbook that installs Nginx, deploys a custom HTML page, and ensures the service is running, and a Jinja2 template for the deployed page using an Ansible variable.

## Technologies used

Ansible, Homebrew (`homebrew` and `command` modules), Jinja2 templating.

## Architecture

The `homebrew` module installs Nginx if it isn't already present. The `template` module renders `templates/index.html.j2` with the `site_message` variable substituted, and deploys it to Nginx's web root. A handler restarts Nginx only if the deployed file actually changed, avoiding unnecessary restarts on every run. The `command` module (`brew services start/restart nginx`) is used instead of the `homebrew_service` module, which requires the `community.general` collection that isn't installed by default.

See `playbook.yml` and `inventory.ini` for the full configuration.

## Setup and execution

```bash
brew install ansible
ansible-playbook -i inventory.ini playbook.yml
```

## Notes on macOS-specific issues encountered

`become: true` was removed from the playbook. Homebrew explicitly refuses to run as root for security reasons, and on macOS with Homebrew, elevated privileges aren't needed to manage packages or write to Homebrew-owned directories. Homebrew's Nginx on Apple Silicon listens on port 8080 by default, not 80, since binding to port 80 requires root privileges.

## Verification

The first run showed changed=3 (Nginx installed, file deployed, service started). A second run with no changes made showed changed=0, confirming the playbook is idempotent and only makes changes when actually needed. The application was verified in the browser at http://localhost:8080, displaying the templated message.

## Status

This lab targets localhost for learning purposes. In a real-world scenario, the inventory would list remote servers reachable via SSH, and this same playbook structure would apply configuration across multiple machines consistently.
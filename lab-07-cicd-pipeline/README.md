# CI Pipeline with GitHub Actions - Lab 07

This lab adds a Continuous Integration pipeline using GitHub Actions, validating
every previous lab automatically on each push and pull request to `main`.

## What this lab creates

- `.github/workflows/ci.yml` — a GitHub Actions workflow that:
  - Checks out the repository
  - Sets up Terraform
  - Runs `terraform fmt -check` and `terraform validate` for lab-01 through lab-04
  - Builds the Docker image from lab-05 (Flask app)
  - Runs the built container and waits for it to start
  - Runs the Bash status check script from lab-06 against the running container

## Technologies used

- GitHub Actions
- `hashicorp/setup-terraform`
- Terraform (`fmt`, `init -backend=false`, `validate`)
- Docker
- Bash

## Trigger

The workflow runs on:
- `push` to `main`
- `pull_request` targeting `main`

## Design notes

Each Terraform lab (01-04) has its own explicit `fmt` + `validate` steps rather
than a matrix strategy. This was a deliberate choice at this stage — a matrix
would reduce duplication and scale better as more labs are added, but writing
the steps manually first made the underlying mechanics (working directory,
step ordering, per-lab isolation) more explicit while learning.

## Verification

The pipeline was tested end-to-end, including a deliberate negative test:

- **Happy path**: PR opened from `lab-07-dev` — all steps passed (Terraform
  validation for lab-01–04, Docker build/run for lab-05, Bash check for lab-06)
- **Negative test**: formatting in `lab-01/main.tf` was intentionally broken
  and committed to the same PR — the `Terraform fmt check (lab-01)` step
  correctly failed, confirming the pipeline actually validates rather than
  always passing
- **Fix**: formatting was corrected in a follow-up commit — the pipeline
  returned to green

## Status

- `terraform init -backend=false` + `validate` — passing for lab-01 to lab-04
- `docker build` + `docker run` (lab-05) — passing
- Bash status check (lab-06) — passing
- No `terraform apply` is run in CI, consistent with the rest of this repo
  (Azure free trial expired — CI only validates configuration, never deploys)
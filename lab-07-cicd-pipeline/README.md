# CI Pipeline with GitHub Actions - Lab 07

This lab adds a Continuous Integration pipeline using GitHub Actions. On each
push and pull request to `main`, it validates the Terraform labs, builds and
tests the Docker and Bash labs, and checks the syntax of the Ansible playbook
from lab-09. The workflow was originally built for labs 01-06 and later
extended to cover labs 09, 11 (Terraform only) and 12.

## What this lab creates

`.github/workflows/ci.yml` — a GitHub Actions workflow with three independent
jobs:

- `validate-and-build`
  - Checks out the repository and sets up Terraform
  - Runs `terraform fmt -check`, `init -backend=false` and `validate` for lab-01 through lab-04
  - Builds the Docker image from lab-05 (Flask app), runs the container and waits for it to start
  - Runs the Bash status check script from lab-06 against the running container
- `terraform-modules`
  - Runs `terraform fmt -check -recursive` for lab-12 (modules and both environments)
  - Runs `init -backend=false` and `validate` separately for `lab-12-terraform-modules/environments/dev` and `/staging`
  - Runs `fmt -check`, `init -backend=false` and `validate` for the Terraform configuration of lab-11
- `ansible-syntax`
  - Installs Ansible
  - Runs `ansible-playbook --syntax-check` for the playbook of lab-09

Not covered by CI at the moment: lab-08 (Kubernetes), lab-10 (monitoring) and
the Ansible playbook of lab-11 (see "Known limitation" below).

## Technologies used

- GitHub Actions
- `hashicorp/setup-terraform`
- Terraform (`fmt`, `init -backend=false`, `validate`)
- Docker
- Bash
- Ansible (`ansible-playbook --syntax-check`)

## Trigger

The workflow runs on:
- `push` to `main`
- `pull_request` targeting `main`

## Design notes

Each Terraform lab has its own explicit `fmt` + `validate` steps rather than a
matrix strategy. This was a deliberate choice at this stage — a matrix would
reduce duplication and scale better as more labs are added, but writing the
steps manually first made the underlying mechanics (working directory, step
ordering, per-lab isolation) more explicit while learning.

The extension was added as two new jobs instead of more steps in the existing
one. The original job stays untouched, the new jobs run in parallel with it, and
a failure shows up in the job it belongs to.

Lab-12 needs two separate `validate` runs because `dev` and `staging` are
independent root configurations that both call the same module. `fmt` needs
`-recursive` to reach the `modules/` and `environments/` subfolders.

## Known limitation

The playbook of lab-11 loads `secrets.yml`, which is encrypted with Ansible
Vault. `ansible-playbook --syntax-check` reads variable files, so on the runner
it failed with `Attempting to decrypt but no vault secrets found`. The CI has no
Vault password, so this step was removed. Lab-11 is still covered on the
Terraform side (`fmt`, `init -backend=false`, `validate`).

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

Extension to labs 09, 11 and 12:

- Before the first run, `terraform fmt -check -recursive` was run locally and
  reported unformatted files in lab-12 (`environments/dev` and `staging`). They
  were formatted in a separate commit, so the pipeline did not fail on them.
- First run: `validate-and-build` and `terraform-modules` passed, while
  `ansible-syntax` failed on the lab-11 step because of the encrypted vars
  file. After removing that step, all three jobs passed.

## Status

- `terraform init -backend=false` + `validate` — passing for lab-01 to lab-04, lab-11 and lab-12 (dev and staging)
- `docker build` + `docker run` (lab-05) — passing
- Bash status check (lab-06) — passing
- Ansible syntax check (lab-09) — passing
- Ansible syntax check (lab-11) — not run in CI (encrypted vars file, no Vault password on the runner)
- No `terraform apply` is run in CI, consistent with the rest of this repo
  (Azure free trial expired — CI only validates configuration, never deploys)
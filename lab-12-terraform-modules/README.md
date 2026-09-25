# Lab 12 — Reusable Terraform Networking Module

## What this lab creates

A reusable Terraform module that provisions a Virtual Network, a subnet, and a Network Security Group associated with that subnet, replacing the duplicated networking code previously repeated across Lab-01, Lab-02, and Lab-03. The module is called from two independent environments (`dev` and `staging`), each with its own resource group, VNet address space, and subnet, demonstrating that the same module logic can be reused across multiple environments without modifying the module itself.

## Technologies used

Terraform (HCL), Terraform modules, Microsoft Azure (Resource Groups, Virtual Networks, Subnets, Network Security Groups)

## Architecture

The module lives under `modules/networking/` and exposes six input variables (resource group name, location, VNet name and address space, subnet name and address prefix), keeping all naming and addressing decisions outside the module itself. Two separate root configurations under `environments/dev/` and `environments/staging/` each create their own resource group and invoke the module with distinct values (different VNet/subnet CIDR ranges, different resource names), proving the module can serve multiple, independent environments from a single, unchanged codebase. The module outputs the created VNet, subnet, and NSG IDs, making them available for future labs that build on top of this networking foundation.

## Setup

For each environment (`environments/dev/` and `environments/staging/`):

1. `terraform init`
2. `terraform validate`
3. `terraform plan` / `terraform apply` to provision the resources

## Notes on issues encountered

Early in development, the module folder was accidentally nested one level too deep (`modules/modules/networking` instead of `modules/networking`), which caused Terraform to fail during `terraform init` with an "Unreadable module directory" error. Fixed by relocating the `networking` folder to the correct path.

When splitting the original single root configuration into `environments/dev/` and `environments/staging/`, the module `source` path had to be updated from `./modules/networking` to `../../modules/networking`, since Terraform resolves relative module paths from the location of the calling configuration file, not from the repository root.

## Verification

`terraform validate` completed successfully in both `environments/dev/` and `environments/staging/`, confirming the configuration and module references are syntactically and internally consistent in each environment.

## Status

Module structure complete and validated in two independent environments (dev and staging).
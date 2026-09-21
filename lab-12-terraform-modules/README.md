# Lab 12 - Reusable Terraform Networking Module

## What this lab creates

A reusable Terraform module that provisions a Virtual Network, a subnet, and a Network Security Group associated with that subnet, replacing the duplicated networking code previously repeated across Lab-01, Lab-02, and Lab-03. The root configuration creates a dedicated resource group and calls the module with a single set of input values, demonstrating that the same module logic can be reused for different networking configurations without modifying the module itself.

## Technologies used

Terraform (HCL), Terraform modules, Microsoft Azure (Resource Groups, Virtual Networks, Subnets, Network Security Groups)

## Architecture

The module lives under `modules/networking/` and exposes six input variables (resource group name, location, VNet name and address space, subnet name and address prefix), keeping all naming and addressing decisions outside the module itself. The root `main.tf` creates the resource group and invokes the module via a `module` block, passing in concrete values. The module outputs the created VNet, subnet, and NSG IDs, making them available for future labs that build on top of this networking foundation.

## Setup

1. `terraform init`
2. `terraform validate`
3. `terraform plan` (requires an active Azure subscription)

## Notes on issues encountered

Early in development, the module folder was accidentally nested one level too deep (`modules/modules/networking` instead of `modules/networking`), which caused Terraform to fail during `terraform init` with an "Unreadable module directory" error. Fixed by relocating the `networking` folder to the correct path.

## Verification

`terraform validate` completed successfully, confirming the configuration and module references are syntactically and internally consistent.

## Status

Module structure complete and validated. Deployment (`terraform plan`/`apply`) pending an active Azure subscription.
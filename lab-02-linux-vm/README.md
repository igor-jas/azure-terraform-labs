# Azure Terraform Linux VM Lab

This lab creates a Linux virtual machine in Azure using Terraform.

The goal of this project was to practice creating compute resources in Azure, connecting networking components, and preparing SSH access to a Linux VM.

## What this lab creates

This Terraform configuration creates:

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- SSH security rule
- Public IP address
- Network Interface
- Linux Virtual Machine

## Resources

| Resource | Name |
|---|---|
| Resource Group | `rg-linux-vm-lab` |
| Virtual Network | `vnet-linux-vm-lab` |
| Subnet | `subnet-linux-vm` |
| Network Security Group | `nsg-linux-vm-lab` |
| Public IP | `pip-linux-vm-lab` |
| Network Interface | `nic-linux-vm-lab` |
| Linux VM | `vm-linux-lab` |

## Network

| Component | Address range |
|---|---|
| Virtual Network | `10.1.0.0/16` |
| Subnet | `10.1.1.0/24` |

The Network Security Group allows inbound SSH traffic on port `22`.

## Virtual Machine

| Setting | Value |
|---|---|
| OS | Ubuntu Server 22.04 LTS |
| VM size | `Standard_D2s_v5` |
| Admin user | `azureuser` |
| Authentication | SSH key |

> Note: During testing, smaller B-series VM sizes such as `Standard_B1s`, `Standard_B1ms` and `Standard_B2s` were unavailable due to Azure capacity restrictions in the tested regions. `Standard_D2s_v5` was used temporarily to complete the lab, and all resources were destroyed after validation to avoid unnecessary costs.

## Terraform commands used

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
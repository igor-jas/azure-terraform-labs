# Azure Terraform Networking Lab

This is my first Azure networking lab created with Terraform.

The goal of this project was to practice basic Azure networking and understand how Terraform can be used to create and manage cloud infrastructure.

## What this lab creates

This Terraform configuration creates:

- Resource Group
- Virtual Network
- Two subnets
- Network Security Group
- NSG association with the secure subnet

## Resources

| Resource | Name |
|---|---|
| Resource Group | `rg-terraform-networking-lab` |
| Virtual Network | `vnet-networking-lab` |
| Web Subnet | `subnet-web` |
| Secure Subnet | `subnet-secure` |
| Network Security Group | `nsg-secure` |

## Network

| Component | Address range |
|---|---|
| Virtual Network | `10.0.0.0/16` |
| Web Subnet | `10.0.1.0/24` |
| Secure Subnet | `10.0.2.0/24` |

The Network Security Group is associated only with `subnet-secure`.

## Terraform commands used

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

## What I learned

In this lab I practiced:

- creating Azure resources with Terraform
- using references between Terraform resources
- creating a Virtual Network and subnets
- understanding basic CIDR ranges
- creating a Network Security Group
- associating an NSG with a subnet
- reading Terraform plan before applying changes
- removing resources with terraform destroy

## Status

The lab was successfully deployed to Azure and then destroyed to avoid unnecessary costs.
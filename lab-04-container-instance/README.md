# Azure Container Instance with Nginx - Terraform Lab 04

This lab demonstrates how to deploy a containerized Nginx web server in Microsoft Azure
using Terraform and Azure Container Instances (ACI), as a lighter-weight alternative
to the VM-based approach in Lab 03.

## What this lab creates

- Azure Resource Group
- Azure Container Instance (Container Group) running the public `nginx:latest` image
- Public IP address and FQDN for the container group

## Technologies used

- Microsoft Azure
- Terraform
- Docker (public Nginx image from Docker Hub)
- Azure Container Instances

## Architecture

Unlike Lab 03, this lab does not require a Virtual Network, Subnet, Network Security
Group, or Network Interface. Azure Container Instances handles public networking
internally through the container group itself.

The container group is exposed publicly via:

- TCP port 80 for HTTP
- A public IP address
- A public FQDN, derived from `dns_name_label`

## Terraform resources

Main Terraform resources used in this lab:

- `azurerm_resource_group`
- `azurerm_container_group`

## Outputs

```hcl
output "public_fqdn" {
  value = azurerm_container_group.web.fqdn
}

output "public_ip" {
  value = azurerm_container_group.web.ip_address
}
```

## Status

- `terraform init` — success
- `terraform validate` — configuration valid
- `terraform plan` — confirmed valid plan: 2 to add, 0 to change, 0 to destroy
- `terraform apply` — **not executed**

The Azure free trial expired before this step was reached, and the subscription
entered a disabled state. Continuing with the deployment would require upgrading
the subscription to pay-as-you-go, which could result in usage charges because
Azure Container Instances is not guaranteed to be covered by the free service
allowances.

For this reason, `terraform apply` was intentionally skipped.

The configuration is validated and ready to deploy on an active subscription.

## Comparison to Lab 03

| Aspect | Lab 03 (VM) | Lab 04 (ACI) |
|---|---|---|
| Networking setup | Manual (VNet, Subnet, NSG, NIC) | Handled internally by ACI |
| OS management | Full Linux VM, manual Nginx install | Prebuilt Docker image |
| Resource count | 8 resources | 2 resources |
| Startup model | IaaS | Container/PaaS-like |
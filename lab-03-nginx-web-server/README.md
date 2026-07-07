# Azure Linux VM with Nginx Web Server - Terraform Lab 03

This lab demonstrates how to deploy a Linux virtual machine in Microsoft Azure using Terraform and install an Nginx web server on it.

## What this lab creates

- Azure Resource Group
- Virtual Network
- Subnet
- Network Security Group
- NSG rules for SSH and HTTP
- Public IP Address
- Network Interface
- Ubuntu Linux Virtual Machine
- Nginx Web Server

## Technologies used

- Microsoft Azure
- Terraform
- Linux Ubuntu
- SSH
- Nginx
- PowerShell
- Azure CLI

## Architecture

The virtual machine is deployed inside an Azure Virtual Network and Subnet.

The VM is connected to the subnet through a Network Interface.

A Public IP Address is attached to the Network Interface.

A Network Security Group allows inbound traffic on:

- TCP port 22 for SSH
- TCP port 80 for HTTP

## Terraform resources

Main Terraform resources used in this lab:

- `azurerm_resource_group`
- `azurerm_virtual_network`
- `azurerm_subnet`
- `azurerm_network_security_group`
- `azurerm_subnet_network_security_group_association`
- `azurerm_public_ip`
- `azurerm_network_interface`
- `azurerm_linux_virtual_machine`

## SSH access

The VM uses SSH key authentication.

The public SSH key is passed to the VM using:

```hcl
admin_ssh_key {
  username   = "azureuser"
  public_key = file(pathexpand(var.ssh_public_key_path))
}
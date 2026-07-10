terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "fc22f2ff-b65f-4ea9-b071-9424b57dab8b"
}

resource "azurerm_resource_group" "lab" {
  name     = "rglab04"
  location = "westeurope"
}

resource "azurerm_container_group" "web" {
  name                = "containergrouoplab04"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "nginx-lab-igorjas-04"

  container {
    name   = "containerlab04"
    image  = "nginx:latest"
    cpu    = 0.5
    memory = 1

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

output "public_fqdn" {
  description = "Public FQDN address of the Nginx container"
  value       = azurerm_container_group.web.fqdn
}

output "public_ip" {
  description = "Public IP address of the Nginx container"
  value       = azurerm_container_group.web.ip_address
}
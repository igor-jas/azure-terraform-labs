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
}

resource "azurerm_resource_group" "lab12-rg" {
  name     = "lab12-networking-rg-staging"
  location = "Germany North"
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name   = azurerm_resource_group.lab12-rg.name
  location               = azurerm_resource_group.lab12-rg.location
  vnet_name               = "lab12-vnet-staging"
  vnet_address_space      = ["10.1.0.0/16"]
  subnet_name              = "lab12-subnet-staging"
  subnet_address_prefix    = ["10.1.1.0/24"]
}
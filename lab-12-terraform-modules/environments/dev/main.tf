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
  name     = "lab12-networking-rg"
  location = "Germany North"
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name   = azurerm_resource_group.lab12-rg.name
  location               = azurerm_resource_group.lab12-rg.location
  vnet_name               = "lab12-vnet"
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_name              = "lab12-subnet"
  subnet_address_prefix    = ["10.0.1.0/24"]
}
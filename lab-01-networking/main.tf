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

resource "azurerm_resource_group" "dev" {
  name     = "rg-terraform-networking-lab"
  location = "PolandCentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-networking-lab"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "secure" {
  name                 = "subnet-secure"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "secure_nsg" {
  name                = "nsg-secure"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
}

resource "azurerm_subnet_network_security_group_association" "secure_assoc" {
  subnet_id                 = azurerm_subnet.secure.id
  network_security_group_id = azurerm_network_security_group.secure_nsg.id
}

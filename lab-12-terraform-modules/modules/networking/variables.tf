variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where networking resources will be created"
}

variable "location" {
  type        = string
  description = "Azure region for the networking resources"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the Virtual Network, e.g. [\"10.0.0.0/16\"]"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "Address prefix for the subnet, e.g. [\"10.0.1.0/24\"]"
}
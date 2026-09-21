output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of the created Virtual Network"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "ID of the created subnet"
}

output "nsg_id" {
  value       = azurerm_network_security_group.nsg.id
  description = "ID of the created Network Security Group"
}
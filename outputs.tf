output "vnet_id" {
  description = "The ID of this virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of this virtual network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "A map of subnet IDs."
  value = {
    for k, v in azurerm_subnet.this : k => v.id
  }
}

output "subnet_names" {
  description = "A map of subnet names."
  value = {
    for k, v in azurerm_subnet.this : k => v.name
  }
}

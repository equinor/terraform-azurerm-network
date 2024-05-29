output "vnet_id" {
  description = "The ID of this virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of this virtual network."
  value       = azurerm_virtual_network.this.name
}

output "address_spaces" {
  description = "A list of address spaces that are used for this virtual network."
  value       = azurerm_virtual_network.this.address_space
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

output "subnet_route_table_association_ids" {
  description = "A map of subnet route table association IDs."
  value = {
    for k, v in azurerm_subnet_route_table_association.this : k => v.id
  }
}

output "subnet_network_security_group_association_ids" {
  description = "A map of subnet network security group association IDs."
  value = {
    for k, v in azurerm_subnet_network_security_group_association.this : k => v.id
  }
}

output "subnet_nat_gateway_association_ids" {
  description = "A map of subnet NAT gateway association IDs."
  value = {
    for k, v in azurerm_subnet_nat_gateway_association.this : k => v.id
  }
}

output "virtual_network_peering_names" {
  description = "A map of virtual network peering names."
  value = {
    for k, v in azurerm_virtual_network_peering.this : k => v.name
  }
}

output "virtual_network_peering_ids" {
  description = "A map of virtual network peering IDs."
  value = {
    for k, v in azurerm_virtual_network_peering.this : k => v.id
  }
}

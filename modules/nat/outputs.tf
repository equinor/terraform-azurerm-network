output "gateway_id" {
  description = "The ID of this NAT gateway."
  value       = azurerm_nat_gateway.this.id
}

output "gateway_name" {
  description = "The name of this NAT gateway."
  value       = azurerm_nat_gateway.this.name
}

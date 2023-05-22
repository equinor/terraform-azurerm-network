output "nic_id" {
  description = "The ID of this network interface card."
  value       = azurerm_network_interface.this.id
}

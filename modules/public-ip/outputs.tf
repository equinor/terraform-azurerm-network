output "address_id" {
  description = "The ID of this public IP address."
  value       = azurerm_public_ip.this.id
}

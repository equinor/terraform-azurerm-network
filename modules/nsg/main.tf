locals {
  security_rules = [
    for r in var.security_rules : {
      name        = r.name
      description = r.description
      access      = r.access
      protocol    = r.protocol

      source_port_range  = "*" # Recommended by default. Port filtering is meant for destination.
      source_port_ranges = null

      destination_port_range  = r.destination_port_range
      destination_port_ranges = null

      source_address_prefix   = r.source_address_prefix
      source_address_prefixes = null

      destination_address_prefix   = r.destination_address_prefix
      destination_address_prefixes = null

      destination_application_security_group_ids = null
      source_application_security_group_ids      = null

      direction = r.direction
      priority  = r.priority
    }
  ]
}

resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
  location            = var.location
  security_rule       = local.security_rules

  tags = var.tags
}

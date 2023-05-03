locals {
  security_rules = [
    for r in var.security_rules : {
      name                         = r.name
      protocol                     = r.protocol
      access                       = r.access
      priority                     = r.priority
      direction                    = r.direction
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = r.destination_port_range
      destination_port_ranges      = null
      source_address_prefix        = r.source_address_prefix
      source_address_prefixes      = null
      destination_address_prefix   = r.destination_address_prefix
      destination_address_prefixes = null
      description                  = r.description

      destination_application_security_group_ids = null
      source_application_security_group_ids      = null
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

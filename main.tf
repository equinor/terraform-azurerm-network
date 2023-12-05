locals {
  subnet_network_security_group_associations = {
    for key, value in var.subnets : key => value.network_security_group_id
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_spaces
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [0] : []

    content {
      id     = var.ddos_protection_plan_id
      enable = var.ddos_protection_plan_enabled
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.value["name"]
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value["address_prefixes"]
  service_endpoints    = each.value["service_endpoints"]

  dynamic "delegation" {
    for_each = each.value["service_delegation_name"] != null ? [0] : []

    content {
      name = "0"

      service_delegation {
        name    = each.value["service_delegation_name"]
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.subnet_network_security_group_associations

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.virtual_network_peerings

  name                      = each.value["name"]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value["remote_virtual_network_id"]
}

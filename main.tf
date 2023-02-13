locals {
  subnet_route_table_associations = {
    for k, v in var.subnets : k => v["route_table_association"].route_table_id if v["route_table_association"] != null
  }

  subnet_network_security_group_associations = {
    for k, v in var.subnets : k => v["network_security_group_association"].network_security_group_id if v["network_security_group_association"] != null
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_spaces
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []

    content {
      id     = each.value["id"]
      enable = each.value["enable"]
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
    for_each = each.value["delegation"]

    content {
      name = delegation.value["name"]

      service_delegation {
        name    = delegation.value["service_delegation_name"]
        actions = delegation.value["service_delegation_actions"]
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.subnet_network_security_group_associations

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = local.subnet_route_table_associations

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.virtual_network_peerings

  name                      = each.value["name"]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value["remote_virtual_network_id"]
}

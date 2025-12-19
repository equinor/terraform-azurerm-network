locals {
  # For each address space, calculate an address prefix for each subnet.
  address_prefixes = [
    for address_space in var.address_spaces : cidrsubnets(address_space.address_prefix, address_space.subnets[*].new_bits...)
  ]

  # Map calculated address prefixes to each subnet.
  # The Azure provider does not permit overlapping address spaces, so each address prefix can be used as a unique map key.
  subnets = {
    for i in flatten([
      for address_space_index, address_space in var.address_spaces : [
        for subnet_index, _ in address_space.subnets : {
          address_space_index = address_space_index
          subnet_index        = subnet_index
        }
      ]
    ]) : local.address_prefixes[i.address_space_index][i.subnet_index] => var.address_spaces[i.address_space_index].subnets[i.subnet_index]
  }

  subnet_route_table_associations = {
    for k, v in local.subnets : k => v["route_table"].id if v["route_table"] != null
  }

  subnet_network_security_group_associations = {
    for k, v in local.subnets : k => v["network_security_group"].id if v["network_security_group"] != null
  }

  subnet_nat_gateway_associations = {
    for k, v in local.subnets : k => v["nat_gateway"].id if v["nat_gateway"] != null
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_spaces[*].address_prefix
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
  for_each = local.subnets

  name                 = each.value["name"]
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  # Multiple prefixes for a subnet are only supported for virtual machines and virtual machine scale sets.
  # Ref: https://learn.microsoft.com/en-us/azure/virtual-network/how-to-multiple-prefixes-subnet
  address_prefixes = [each.key]

  service_endpoints                             = each.value["service_endpoints"]
  service_endpoint_policy_ids                   = each.value["service_endpoint_policy_ids"]
  private_endpoint_network_policies             = each.value["private_endpoint_network_policies"]
  private_link_service_network_policies_enabled = each.value["private_link_service_network_policies_enabled"]

  dynamic "delegation" {
    for_each = each.value["delegations"]

    content {
      # If a name is not explicitly set, set it to the index of the current object.
      # E.g., if two subnet delegations are to be configured, the first delegation will be named "0" and the second will be named "1".
      # This is the default naming convention when creating a subnet delegation in the Azure Portal.
      name = coalesce(delegation.value["name"], index(each.value["delegations"], delegation.value))

      service_delegation {
        name    = delegation.value["service_name"]
        actions = delegation.value["service_actions"]
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

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = local.subnet_nat_gateway_associations

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = each.value
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.virtual_network_peerings

  name                      = each.value["name"]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value["remote_virtual_network_id"]
}

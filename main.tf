locals {
  # A map of key-value pairs, where the key is the address space prefix, and value is a list of subnets in that address space.
  address_space_subnets = { for address_space in var.address_spaces : address_space.prefix => address_space.subnets }

  # A map of key-value pairs, where the key is the address space prefix, and value is a list of calculated address prefixes for the subnets in that address space.
  subnet_address_prefixes = { for address_space in var.address_spaces : address_space.prefix => cidrsubnets(address_space.prefix, [for subnet in address_space.subnets : subnet.new_bits]...) }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_spaces
  dns_servers         = var.dns_servers

  dynamic "subnet" {
    for_each = var.subnets

    content {
      name                                          = subnet.value["name"]
      address_prefixes                              = local.subnet_address_prefixes[subnet.value.prefix][index(local.address_space_subnets[subnet.value.prefix], subnet.value)]
      security_group                                = subnet.value["security_group_id"]
      route_table_id                                = subnet.value["route_table_id"]
      service_endpoints                             = subnet.value["service_endpoints"]
      service_endpoint_policy_ids                   = subnet.value["service_endpoint_policy_ids"]
      private_endpoint_network_policies             = subnet.value["private_endpoint_network_policies"]
      private_link_service_network_policies_enabled = subnet.value["private_link_service_network_policies_enabled"]

      dynamic "delegation" {
        for_each = subnet.value["delegations"]

        content {
          # If a name is not explicitly set, set it to the index of the current object.
          # E.g., if two subnet delegations are to be configured, the first delegation will be named "0" and the second will be named "1".
          # This is the default naming convention when creating a subnet delegation in the Azure Portal.
          name = coalesce(delegation.value["name"], index(subnet.value["delegations"], delegation.value))

          service_delegation = {
            name    = delegation.value["service_name"]
            actions = delegation.value["service_actions"]
          }
        }
      }
    }
  }

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [0] : []

    content {
      id     = var.ddos_protection_plan_id
      enable = var.ddos_protection_plan_enabled
    }
  }

  tags = var.tags
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.virtual_network_peerings

  name                      = each.value["name"]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value["remote_virtual_network_id"]
}

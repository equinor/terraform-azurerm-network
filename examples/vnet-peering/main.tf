provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_monitor_action_group" "this" {
  name                = "ag-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  short_name          = "action"
}

module "network_hub" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-hub-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  action_group_id     = azurerm_monitor_action_group.this.id
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "default" = {
      name             = "default"
      address_prefixes = ["10.0.1.0/24"]
    }
  }

  virtual_network_peerings = {
    "spoke" = {
      name                      = "spoke-peering"
      remote_virtual_network_id = module.network_spoke.vnet_id
    }
  }
}

module "network_spoke" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-spoke-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  action_group_id     = azurerm_monitor_action_group.this.id
  address_spaces      = ["10.1.0.0/16"]

  subnets = {
    "default" = {
      name             = "default"
      address_prefixes = ["10.1.1.0/24"]
    }
  }

  virtual_network_peerings = {
    "hub" = {
      name                      = "hub-peering"
      remote_virtual_network_id = module.network_hub.vnet_id
    }
  }
}

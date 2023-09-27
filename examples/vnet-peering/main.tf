provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_id.suffix.hex}"
  location = var.location
}

module "network_hub" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-hub-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "default" = {
      name             = "default"
      address_prefixes = ["10.0.1.0/24"]
    }
  }

  virtual_network_peerings = {
    "spoke" = {
      name                      = "spoke-01-peering"
      remote_virtual_network_id = module.network_spoke_01.vnet_id
    }
  }
}

module "network_spoke_01" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-spoke-01-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
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

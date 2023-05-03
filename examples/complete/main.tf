provider "azurerm" {
  features {}
}

locals {
  tags = {
    environment = "Development"
  }
}

resource "random_id" "this" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${random_id.this.hex}"
  location = var.location

  tags = local.tags
}

module "network_hub" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-hub-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_spaces      = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnets = {
    "this" = {
      name             = "snet-${random_id.this.hex}"
      address_prefixes = ["10.0.1.0/24"]
    }
  }

  virtual_network_peerings = {
    "this" = {
      name                      = "peer-${random_id.this.hex}"
      remote_virtual_network_id = module.network.vnet_id
    }
  }

  tags = local.tags
}

module "nsg" {
  # source = "github.com/equinor/terraform-azurerm-network//modules/nsg?ref=v0.0.0"
  source = "../../modules/nsg"

  nsg_name            = "nsg-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  security_rules = [
    {
      name                       = "AllowInternetTcp80OutBound"
      destination_address_prefix = "Internet"
      protocol                   = "Tcp"
      destination_port_range     = "80"
      direction                  = "Outbound"
      priority                   = 100
    },
    {
      name                       = "AllowInternetTcp80InBound"
      destination_address_prefix = "Internet"
      protocol                   = "Tcp"
      destination_port_range     = "80"
      direction                  = "Inbound"
      priority                   = 100
    }
  ]

  tags = local.tags
}

resource "azurerm_route_table" "this" {
  name                = "rt-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  tags = local.tags
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_spaces      = ["10.1.0.0/16"]

  subnets = {
    "this" = {
      name              = "snet-${random_id.this.hex}"
      address_prefixes  = ["10.1.1.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]

      network_security_group_association = {
        network_security_group_id = module.nsg.nsg_id
      }

      route_table_association = {
        route_table_id = azurerm_route_table.this.id
      }

      delegation = [
        {
          service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
          service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      ]
    }
  }

  virtual_network_peerings = {
    "this" = {
      name                      = "peer-${random_id.this.hex}"
      remote_virtual_network_id = module.network_hub.vnet_id
    }
  }

  tags = local.tags
}

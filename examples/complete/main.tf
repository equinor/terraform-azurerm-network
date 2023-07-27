provider "azurerm" {
  features {}
}

locals {
  tags = {
    "Environment" = "Development"
  }
}

resource "random_id" "example" {
  byte_length = 8
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_id.suffix.hex}"
  location = var.location

  tags = local.tags
}

module "network_hub" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-hub-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnets = {
    "default" = {
      name             = "snet-default-${random_id.suffix.hex}"
      address_prefixes = ["10.0.1.0/24"]
    }
  }

  virtual_network_peerings = {
    "example" = {
      name                      = "example-peering"
      remote_virtual_network_id = module.network.vnet_id
    }
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

resource "azurerm_route_table" "example" {
  name                = "rt-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  tags = local.tags
}

resource "azurerm_nat_gateway" "example" {
  name                = "ng-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  tags = local.tags
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.1.0.0/16"]

  subnets = {
    "ci" = {
      name             = "snet-ci-${random_id.suffix.hex}"
      address_prefixes = ["10.1.1.0/24"]

      service_endpoints = [
        "Microsoft.Sql",
        "Microsoft.KeyVault",
        "Microsoft.Storage"
      ]

      delegations = [{
        service_name = "Microsoft.ContainerInstance/containerGroups"
      }]

      network_security_group_association = {
        network_security_group_id = azurerm_network_security_group.example.id
      }

      route_table_association = {
        route_table_id = azurerm_route_table.example.id
      }

      nat_gateway_association = {
        nat_gateway_id = azurerm_nat_gateway.example.id
      }
    }
  }

  virtual_network_peerings = {
    "hub" = {
      name                      = "hub-peering"
      remote_virtual_network_id = module.network_hub.vnet_id
    }
  }

  tags = local.tags
}

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

resource "azurerm_virtual_network" "remote" {
  name                = "vnet-${random_id.this.hex}-remote"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

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
    "vm" = {
      name             = "snet-vm-${random_id.this.hex}"
      address_prefixes = ["10.1.1.0/24"]

      network_security_group_association = {
        network_security_group_id = azurerm_network_security_group.this.id
      }

      route_table_association = {
        route_table_id = azurerm_route_table.this.id
      }
    }

    "sql" = {
      name             = "snet-sql-${random_id.this.hex}"
      address_prefixes = ["10.1.2.0/24"]

      route_table_association = {
        route_table_id = azurerm_route_table.this.id
      }
    }

    "storage" = {
      name             = "snet-storage-${random_id.this.hex}"
      address_prefixes = ["10.1.3.0/24"]
    }
  }

  virtual_network_peerings = {
    "remote" = {
      name                      = "peer-${random_id.this.hex}"
      remote_virtual_network_id = azurerm_virtual_network.remote.id
    }
  }

  tags = local.tags
}

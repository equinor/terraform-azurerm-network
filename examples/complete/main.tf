provider "azurerm" {
  features {}
}

locals {
  tags = {
    "Environment" = "Development"
  }
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_id.suffix.hex}"
  location = var.location

  tags = local.tags
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  tags = local.tags
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
      name                      = "snet-ci-${random_id.suffix.hex}"
      address_prefixes          = ["10.1.1.0/24"]
      network_security_group_id = azurerm_network_security_group.example.id
      service_endpoints         = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
      service_delegation_name   = "Microsoft.ContainerInstance/containerGroups"
    }
  }

  tags = local.tags
}

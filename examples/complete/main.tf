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

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = local.tags
}

resource "azurerm_route_table" "example" {
  name                = "rt-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = local.tags
}

resource "azurerm_nat_gateway" "example" {
  name                = "ng-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = local.tags
}

resource "azurerm_subnet_service_endpoint_storage_policy" "this" {
  name                = "se-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_spaces      = ["10.1.0.0/16"]

  subnets = {
    "ci" = {
      name             = "snet-ci-${random_id.suffix.hex}"
      address_prefixes = ["10.1.1.0/24"]

      security_group_id = azurerm_network_security_group.example.id
      route_table_id    = azurerm_route_table.example.id
      nat_gateway_id    = azurerm_nat_gateway.example.id

      service_endpoints           = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
      service_endpoint_policy_ids = [azurerm_subnet_service_endpoint_storage_policy.this.id]

      delegations = [
        {
          service_name = "Microsoft.ContainerInstance/containerGroups"
        }
      ]
    }
  }

  tags = local.tags
}

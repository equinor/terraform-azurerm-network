# Terraform module for Azure Network

Terraform module which creates Azure Network resources.

## Features

- Creates a virtual network in the specified resource group.
- Associates subnets with specified network security groups for increased security of inbound and outbound traffic by default.
- Associates subnets with specified NAT gateways for increased reliability of outbound internet traffic by default.
- Creates specified virtual network peerings.

## Prerequisites

- Azure role `Contributor` at the resource group scope.

## Usage

```terraform
provider "azurerm" {
  features {}
}

module "network" {
  source  = "equinor/network/azurerm"
  version = "~> 3.2"

  vnet_name           = "example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name             = "example-vm-snet"
      address_prefixes = ["10.0.1.0/24"]
      network_security_group = {
        id = azurerm_network_security_group.example.id
      }
      nat_gateway = {
        id = module.nat_gateway_id
      }
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  security_rule = []
}

module "nat" {
  source  = "equinor/nat/azurerm"
  version = "~> 3.0"

  gateway_name               = "example-nat"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.3"

  workspace_name      = "example-log"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).

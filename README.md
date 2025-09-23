# Terraform module for Azure Network

[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-network)](https://github.com/equinor/terraform-azurerm-network/releases/latest)
[![Terraform Module Downloads](https://img.shields.io/terraform/module/dt/equinor/network/azurerm)](https://registry.terraform.io/modules/equinor/network/azurerm/latest)
[![GitHub contributors](https://img.shields.io/github/contributors/equinor/terraform-azurerm-network)](https://github.com/equinor/terraform-azurerm-network/graphs/contributors)
[![GitHub Issues](https://img.shields.io/github/issues/equinor/terraform-azurerm-network)](https://github.com/equinor/terraform-azurerm-network/issues)
[![GitHub Pull requests](https://img.shields.io/github/issues-pr/equinor/terraform-azurerm-network)](https://github.com/equinor/terraform-azurerm-network/pulls)
[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-network)](https://github.com/equinor/terraform-azurerm-network/blob/main/LICENSE)

Terraform module which creates Azure Network resources.

## Features

- Creates a virtual network in the specified resource group.
- Creates specified subnets.
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
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

output "vm_subnet_id" {
  description = "The ID of the subnet to deploy virtual machines into."
  value       = module.network.subnet_ids["vm"]
}
```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).

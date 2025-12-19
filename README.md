# Terraform module for Azure Network

Terraform module which creates Azure Network resources.

## Features

- Creates a virtual network in the specified resource group.
- Creates specified subnets.
- Automatically calculates subnet address prefixes using the built-in [`cidrsubnets` function](https://developer.hashicorp.com/terraform/language/functions/cidrsubnets).
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

  address_space = [
    {
      address_prefix = "10.0.0.0/16"
      subnets = [
        {
          name     = "example-snet-01"
          new_bits = 8
        },
        {
          name     = "example-snet-02"
          new_bits = 10
        }
      ]
    },
    {
      address_prefix = "10.1.0.0/16"
      subnets = [
        {
          name     = "example-snet-03"
          new_bits = 12
        }
      ]
    }
  ]
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

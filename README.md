# Terraform module for Azure Network

Terraform module which creates Azure Network resources.

## Features

- Creates a virtual network with the specified address space.
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

  address_spaces = [
    {
      prefix = "10.0.0.0/16"
      subnets = [
        {
          name          = "example-app-snet"
          prefix_length = "/26"
        },
        {
          name          = "example-func-snet"
          prefix_length = "/22"
        }
      ]
    }
  ]
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}
```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).

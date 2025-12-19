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
      address_prefix = "10.0.0.0/16"
      subnets = [
        {
          name          = "example-app-snet"
          prefix_length = "/26"
          service_endpoints = [
            "Microsoft.KeyVault",
            "Microsoft.Storage"
          ]
          delegations = [{
            service_name = "Microsoft.Web/serverfarms"
          }]
        },
        {
          name          = "example-func-snet"
          prefix_length = "/22"
          service_endpoints = [
            "Microsoft.KeyVault",
            "Microsoft.Storage"
          ]
          delegations = [{
            service_name = "Microsoft.Web/serverfarms"
          }]
        }
      ]
    },
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

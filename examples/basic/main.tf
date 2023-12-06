provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_id.suffix.hex}"
  location = var.location
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name                   = "snet-vm-${random_id.suffix.hex}"
      address_prefixes       = ["10.0.1.0/24"]
      network_security_group = { id = azurerm_network_security_group.example.id }
    }
  }
}

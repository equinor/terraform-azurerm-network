provider "azurerm" {
  features {}
}

resource "random_id" "this" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${random_id.this.hex}"
  location = var.location
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name             = "snet-vm-${random_id.this.hex}"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

module "nsg" {
  # source = "github.com/equinor/terraform-azurerm-network//modules/nsg?ref=v0.0.0"
  source = "../../modules/nsg"

  nsg_name            = "nsg-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  security_rules = [
    {
      name                   = "Allow8080InBound"
      destination_port_range = "8080"
      direction              = "Inbound"
      priority               = 100
    }
  ]
}

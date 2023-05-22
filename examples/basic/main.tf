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

module "nic" {
  # source = "github.com/equinor/terraform-azurerm-network//modules/nic?ref=v0.0.0"
  source = "../../modules/nic"

  name                = "nic-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration = {
    "ip_configuration_block" = {
      name                          = "ip_config_name"
      subnet_id                     = module.network.subnet_ids["vm"]
      private_ip_address_allocation = "Dynamic"
    }
  }
}

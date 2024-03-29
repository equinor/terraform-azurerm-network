provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 8
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name             = "snet-vm-${random_id.suffix.hex}"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

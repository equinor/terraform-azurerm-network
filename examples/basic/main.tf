provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_monitor_action_group" "this" {
  name                = "ag-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  short_name          = "action"
}

module "network" {
  # source = "github.com/equinor/terraform-azurerm-network?ref=v0.0.0"
  source = "../.."

  vnet_name           = "vnet-${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  action_group_id     = azurerm_monitor_action_group.this.id
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "vm" = {
      name             = "snet-vm-${random_id.suffix.hex}"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

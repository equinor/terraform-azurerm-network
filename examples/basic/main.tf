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

module "log_analytics" {
  source = "github.com/equinor/terraform-azurerm-log-analytics?ref=v1.4.0"

  workspace_name      = "log-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
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
    "ip_configuration" = {
      name                          = "ip_config-${random_id.this.hex}"
      private_ip_address_allocation = "Dynamic"
      private_ip_address_version    = "IPv4"
      subnet_id                     = module.network.subnet_ids["vm"]
    }
  }
}

module "nsg" {
  # source = "github.com/equinor/terraform-azurerm-network//modules/nsg?ref=v0.0.0"
  source = "../../modules/nsg"

  nsg_name                   = "nsg-${random_id.this.hex}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  log_analytics_workspace_id = module.log_analytics.workspace_id


  security_rules = [
    {
      name                   = "Allow8080InBound"
      destination_port_range = "8080"
      direction              = "Inbound"
      priority               = 100
    }
  ]
}

module "nat" {
  # source = "github.com/equinor/terraform-azurerm-network//modules/nat?ref=v0.0.0"
  source = "../../modules/nat"

  gateway_name        = "ng-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

module "public_ip" {
  # source = "github.com/equinor/terraform-azurerm-network//modules/public-ip?ref=v0.0.0"
  source = "../../modules/public-ip"

  address_name               = "pip-${random_id.this.hex}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
}

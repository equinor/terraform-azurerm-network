resource "azurerm_network_interface" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "ip_configuration" {
    for_each = var.ip_configuration

    content {
      name                          = ip_configuration.value["name"]
      subnet_id                     = ip_configuration.value["subnet_id"]
      private_ip_address_version    = ip_configuration.value["private_ip_address_version"]
      private_ip_address_allocation = ip_configuration.value["private_ip_address_allocation"]
      private_ip_address            = ip_configuration.value["private_ip_address"]
      primary                       = ip_configuration.value["primary"]
    }
  }
}

resource "azurerm_nat_gateway" "this" {
  name                = var.gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "Standard"

  tags = var.tags
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.subnet_associations

  nat_gateway_id = azurerm_nat_gateway.this.id
  subnet_id      = each.value["subnet_id"]
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each = var.public_ip_associations

  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = each.value["public_ip_address_id"]
}

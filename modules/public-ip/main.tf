resource "azurerm_public_ip" "this" {
  name                = var.address_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  # If sku is "Standard", allocation_method must be "Static".
  # Ref: https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses#sku
  allocation_method = var.sku == "Standard" ? "Static" : var.allocation_method

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_public_ip.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

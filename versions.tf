terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Version 5.0.0 is required to use the "service_endpoint" block for the "azurerm_subnet" resource.
      version = ">= 5.0.0"
    }
  }
}

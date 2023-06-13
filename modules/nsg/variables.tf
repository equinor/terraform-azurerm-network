variable "nsg_name" {
  description = "The name of this network security group."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "security_rules" {
  description = "A list of security rules to configure for this network security group."

  type = list(object({
    name                   = string
    destination_port_range = string
    direction              = string
    priority               = number

    # The following default values are taken from Azure Portal

    description = optional(string, "")

    access   = optional(string, "Allow")
    protocol = optional(string, "*")

    source_address_prefix      = optional(string, "*")
    destination_address_prefix = optional(string, "*")
  }))

  default = []
}

variable "diagnostic_setting_name" {
  description = "The name of this diagnostic setting."
  type        = string
  default     = "audit-logs"
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)
  default = [
    "NetworkSecurityGroupEvent",
    "NetworkSecurityGroupRuleCounter"
  ]
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
}

variable "log_analytics_destination_type" {
  description = "The type of log analytics destination to use for this Log Analytics Workspace."
  type        = string
  default     = null
}


variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

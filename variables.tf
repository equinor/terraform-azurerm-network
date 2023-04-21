variable "vnet_name" {
  description = "The name of this virtual network."
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

variable "address_spaces" {
  description = "A list of address spaces that are used for this virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of DNS servers to use for this virtual network."
  type        = list(string)
  default     = []
}

# ! WARNING: DDoS protection is a HIGH COST service!
variable "ddos_protection_plan" {
  description = "The DDoS Protection Plan for this Virtual Network. This is a HIGH COST service, ref. https://azure.microsoft.com/en-us/pricing/details/ddos-protection/#pricing."

  type = object({
    id     = string # The ID of this DDoS Protection Plan.
    enable = string # Is DDoS Protection Plan enabled/disabled for this Virtual Network.
  })

  default = null
}

variable "subnets" {
  description = "A map of subnets to create for this virtual network."

  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])

    delegation = optional(list(object({
      name                       = string
      service_delegation_name    = string
      service_delegation_actions = optional(list(string), [])
    })), [])

    network_security_group_association = optional(object({
      network_security_group_id = string
    }))

    route_table_association = optional(object({
      route_table_id = string
    }))
  }))

  default = {}
}

variable "virtual_network_peerings" {
  description = "A map of virtual network peerings to create for this virtual network."

  type = map(object({
    name                      = string
    remote_virtual_network_id = string
  }))

  default = {}
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

variable "diagnostic_setting_name" {
  description = "The name of this diagnostic setting."
  type        = string
  default     = "audit-logs"
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)

  default = [
    "VMProtectionAlerts"
  ]
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

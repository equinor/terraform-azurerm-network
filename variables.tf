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
  description = "A list of address spaces to use for this virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of DNS servers to use for this virtual network."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A map of subnets to create for this virtual network."

  type = map(object({
    name             = string
    address_prefixes = list(string)

    network_security_group = optional(object({
      id = string
    }))

    nat_gateway = optional(object({
      id = string
    }))

    route_table = optional(object({
      id = string
    }))

    service_endpoints = optional(list(string), [])

    service_endpoint_policy_ids = optional(list(string), null)

    delegations = optional(list(object({
      service_name    = string
      service_actions = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/action"])
      name            = optional(string)
    })), [])
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

variable "ddos_protection_plan_id" {
  description = "The ID of a DDoS Protection plan to be associated with this virtual network? WARNING: This is a HIGH COST service! (ref: https://azure.microsoft.com/en-us/pricing/details/ddos-protection/)"
  type        = string
  default     = null
}

variable "ddos_protection_plan_enabled" {
  description = "Should the DDoS Protection plan be enabled for this virtual network? WARNING: This is a HIGH COST service! (ref: https://azure.microsoft.com/en-us/pricing/details/ddos-protection/)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

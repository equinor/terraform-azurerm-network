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

# WARNING: DDoS Protection is a HIGH COST service!
variable "ddos_protection_plan" {
  description = "A DDoS Protection plan for this virtual network. This is a HIGH COST service (ref: https://azure.microsoft.com/en-us/pricing/details/ddos-protection/)."

  type = object({
    id     = string
    enable = optional(bool, false) # Disabled by default to prevent accidentally enabling HIGH COST service.
  })

  default = null
}

variable "subnets" {
  description = "A map of subnets to create for this virtual network."

  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])

    delegations = optional(list(object({
      name            = optional(string)
      service_name    = string
      service_actions = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/action"])
    })), [])

    network_security_group = optional(object({
      id = string
    }))

    route_table = optional(object({
      id = string
    }))

    nat_gateway = optional(object({
      id = string
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

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

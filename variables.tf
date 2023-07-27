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

    delegations = optional(list(object({
      name            = optional(string)
      service_name    = string
      service_actions = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/action"])
    })), [])

    network_security_group_association = optional(object({
      network_security_group_id = string
    }))

    route_table_association = optional(object({
      route_table_id = string
    }))

    nat_gateway_association = optional(object({
      nat_gateway_id = string
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

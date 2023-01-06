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

variable "subnets" {
  description = "A map of subnets to create for this virtual network."

  type = map(object({
    name             = string
    address_prefixes = list(string)

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

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

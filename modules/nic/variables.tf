variable "name" {
  description = "The name of this network interface card."
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

variable "ip_configuration" {
  description = "A map of IP configurations to create for this network interface card."

  type = map(object({
    name                          = string
    private_ip_address_allocation = string                   # Possible values are Dynamic and Static. Default is set to Dynamic.
    primary                       = optional(bool, true)     # Must be true if multiple ip configuration blocks are specified.
    private_ip_address_version    = optional(string, "IPv4") # Possible values are IPv4 or IPv6. Defaults to IPv4.
    subnet_id                     = optional(string)         # Required when private_ip_address_version is set to IPv4.
    private_ip_address            = optional(string)
  }))

  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

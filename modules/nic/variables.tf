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
  description = "A map of IP configuration with supported blockss"

  type = map(object({
    name                          = string
    subnet_id                     = optional(string)
    private_ip_address_version    = optional(string)
    private_ip_address_allocation = string
    private_ip_address            = optional(string)
    primary                       = optional(bool, true)

  }))

  default = {
    "ip_configuration_block" = {
      name                          = "ip_config_name"
      subnet_id                     = ""
      private_ip_address_version    = "IPv4"
      private_ip_address_allocation = "Dynamic"
      private_ip_address            = "10.0.1.4"
      primary                       = true
    }
  }
}
# private ip address version defaults to IPv4, and subnet id is required when private ip address version is set to IPv4
# got the private ip address from a created network interface in Azure portal and following that example for the complete example

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

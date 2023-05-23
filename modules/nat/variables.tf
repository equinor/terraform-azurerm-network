variable "gateway_name" {
  description = "The name of this NAT gateway."
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

variable "subnet_nat_gateway_associations" {
  description = "A map of subnet NAT Gateway associations."

  type = map(object({
    subnet_id = string
  }))

  default = {}
}

variable "public_ip_associations" {
  description = "A map of public IP addresses to associate with this NAT gateway."

  type = map(object({
    public_ip_address_id = string
  }))

  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

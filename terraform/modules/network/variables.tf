variable "vnet_name" {
  description = "Name of the VNet."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Existing RG."
  type        = string
}

variable "address_space" {
  description = "VNet CIDRs."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet_name => CIDR."
  type        = map(string)
}

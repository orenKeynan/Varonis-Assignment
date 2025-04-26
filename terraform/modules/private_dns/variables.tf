variable "pdns_name" {
  description = "The name of the Private DNS Zone to create (e.g., \"aca.internal\")"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the DNS zone and link"
  type        = string
}

variable "virtual_network_id" {
  description = "The resource ID of the Virtual Network to link the DNS zone to"
  type        = string
}

variable "registration_enabled" {
  description = "Whether virtual machines in the linked VNet should be auto-registered in this zone"
  type        = bool
  default     = true
}

variable "private_dns_a_records" {
  description = "Map of private DNS A records to create."
  type = map(object({
    ttl                 = optional(number, 60)
    records             = set(string)
  }))
  default = {}
}

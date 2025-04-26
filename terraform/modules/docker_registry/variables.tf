variable "acr_name" {
  description = "The globally-unique name for the Azure Container Registry (3–50 alphanumeric characters)."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group in which to create the registry."
  type        = string
}

variable "location" {
  description = "Azure region (e.g., eastus, westeurope) where the registry will reside."
  type        = string
}

variable "sku" {
  description = "ACR SKU tier: Basic, Standard, or Premium."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Whether to enable the ‘admin user’ (generates username & passwords)."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the registry endpoints."
  type        = bool
  default     = false
}

variable "georep_locations" {
  description = <<EOT
List of additional Azure regions for geo-replication.
If empty, registry is single-region.
EOT
  type        = list(string)
  default     = []
}

variable "georep_zone_redundancy" {
  description = "Enable zone-redundancy on each replicated location (Premium SKU only)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Optional map of tags to apply to the registry."
  type        = map(string)
  default     = {}
}

variable "key_vault_id" {
  description = "ID of the Key Vaulr"
  type        = string
  default     = null
}

variable "admin_secret_name" {
  description = "The sql admin Secret name in KV"
  type        = string
  default     = null
}
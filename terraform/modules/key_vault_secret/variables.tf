variable "key_vault_name" {
  description = "Key Vault name"
  type        = string
}
variable "resource_group_name" {
  description = "Resource group for the Key Vault"
  type        = string
}
variable "location" {
  description = "Location for the Key Vault"
  type        = string
}
variable "tenant_id" {
  description = "Tenant ID for Key Vault access"
  type        = string
}

variable "object_id" {
  description = "Object ID to grant secret permissions"
  type        = string
}

variable "sku_name" {
  description = "SKU type to use"
  type = string
  default = "standard"
  
}
variable "secret_name" {
  description = "Key of Secret Name in keyvault"
  type = string
  default = null
}
variable "value" {
  description = "Value to store in keyvault"
  type = string
  default = null
}

variable "secret_permissions" {
  description = "List of permissions"
  type = list(string)
  default = ["Get", "Set", "List"]
}
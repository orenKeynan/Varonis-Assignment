variable "sa_name" {
  description = "Storage Account name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "account_tier" {
  description = "The tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type"
  type        = string
  default     = "LRS"
}

variable "network_subnet_ids" {
  description = "Subnet IDs for virtual network rule"
  type        = list(string)
}

variable "infrastructure_encryption_enabled" {
  description = "is the data is being encrypted or not"
  type        = bool
  default     = true
}
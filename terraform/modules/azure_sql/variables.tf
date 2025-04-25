variable "tenant_id" {
  description = "Client tenant ID"
  type        = string
}

variable "object_id" {
  description = "TBD"
  type = string
}
variable "resource_group_name" {
  description = "Name of the Resource Group where the MSSQL resources will reside."
  type        = string
}

variable "location" {
  description = "Azure region for the MSSQL resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "sql_version" {
  description = "sql Version."
  type        = string
}

variable "sql_server_name" {
  description = "Globally‑unique name for the Azure MSSQL Server (do **not** include the domain)."
  type        = string
}

variable "administrator_login" {
  description = "Administrator username for the MSSQL Server."
  type        = string
}

variable "minimum_tls_version" {
  description = "Minimum TLS Version to use."
  type        = string
}
variable "database_name" {
  description = "Name of the MSSQL database to create."
  type        = string
}

variable "sku_name" {
  description = "Azure SQL SKU name (e.g. Basic, GP_S_Gen5_2)."
  type        = string
  default     = "Basic"
}

variable "collation" {
  description = "Database collation; keep the default unless you have specific localisation needs."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

# variable "firewall_rules" {
#   description = "Map of firewall rules to add to the server (key = rule name)."
#   type = map(object({
#     start_ip = string
#     end_ip   = string
#   }))
#   default = {}
# }
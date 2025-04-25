variable "resource_group_name" {
  description = "Name of the Resource Group to create (or reuse)."
  type        = string
}

variable "location" {
  description = "Azure region (e.g. West Europe)."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources (map)."
  type        = map(string)
  default     = {}
}

# SQL‑related
# variable "sql_server_name" { type = string }
# variable "administrator_login" { type = string }
# variable "administrator_password" { type = string sensitive = true }
# variable "database_name" { type = string }
# variable "sku_name" { type = string default = "Basic" }
# variable "collation" {
#   type    = string
#   default = "SQL_Latin1_General_CP1_CI_AS"
# }
variable "firewall_rules" {
  description = "Map of firewall rules (key = name, value = { start_ip, end_ip })."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}
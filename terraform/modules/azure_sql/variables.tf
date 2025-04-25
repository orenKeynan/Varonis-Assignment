variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sql_server_name" { type = string }
variable "administrator_login" { type = string }
variable "administrator_password" { type = string, sensitive = true }
variable "database_name" { type = string }
variable "sku_name" { type = string default = "Basic" }
variable "collation" {
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}
variable "firewall_rules" {
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}
module "rg" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 2) Azure SQL module
# module "azure_sql" {
#   source = "./modules/azure_sql"

#   resource_group_name    = module.rg.name
#   location               = module.rg.location
#   tags                   = var.tags

#   sql_server_name        = var.sql_server_name
#   administrator_login    = var.administrator_login
#   administrator_password = var.administrator_password
#   database_name          = var.database_name
#   sku_name               = var.sku_name
#   collation              = var.collation
#   firewall_rules         = var.firewall_rules
# }

# # convenient outputs
# output "resource_group_id" {
#   value       = module.rg.id
#   description = "ID of the RG"
# }

# output "sql_fqdn" {
#   value       = module.azure_sql.server_fqdn
#   description = "SQL Server FQDN"
# }

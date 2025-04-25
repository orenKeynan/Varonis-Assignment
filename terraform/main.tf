data "azurerm_client_config" "this" {
}

locals {
  rg_name = "rg-varonis"
  location = "West Europe"
  # tenant = "7147b932-52e5-40de-92fd-8dd9c3e95a88"
  tags = {
    environment = "dev"
    owner       = "oren"
  }
}

module "rg" {
  source   = "./modules/resource_group"
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

module "azure_sql" {
  source = "./modules/azure_sql"

  resource_group_name    = module.rg.name
  location               = module.rg.location
  tenant_id              = data.azurerm_client_config.this.tenant_id
  object_id              = data.azurerm_client_config.this.object_id
  tags                   = local.tags

  sql_server_name        = "varonis-sql-srv"
  administrator_login    = "sqladmin"
  database_name          = "restaurants"
  sku_name               = "GP_S_Gen5_2"
  collation              = "SQL_Latin1_General_CP1_CI_AS"
  # firewall_rules         = 
  minimum_tls_version = "1.2"
  sql_version = "12.0"
}

# convenient outputs
output "resource_group_id" {
  value       = module.rg.id
  description = "ID of the RG"
}

output "sql_fqdn" {
  value       = module.azure_sql.server_fqdn
  description = "SQL Server FQDN"
}

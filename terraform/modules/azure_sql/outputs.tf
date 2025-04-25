output "server_fqdn" {
  description = "SQL Server FQDN"
  value       = azurerm_sql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "SQL Database ID"
  value       = azurerm_sql_database.this.id
}

output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.this.id
}
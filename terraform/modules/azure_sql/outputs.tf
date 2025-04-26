output "server_fqdn" {
  description = "SQL Server FQDN"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "SQL Database ID"
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "Sql Database Name"
  value       = azurerm_mssql_database.this.name
}

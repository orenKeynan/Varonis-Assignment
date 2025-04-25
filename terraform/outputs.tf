output "resource_group_id" {
  value       = module.rg.id
  description = "ID of the RG"
}

output "sql_fqdn" {
  value       = module.azure_sql.server_fqdn
  description = "SQL Server FQDN"
}

output "application_gateway_fqdn" {
  description = "DNS name of the public IP (nullable unless you set a DNS label)."
  value       = azurerm_public_ip.pip.fqdn
}
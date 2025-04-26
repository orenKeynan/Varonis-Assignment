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

output "outbound_ip_addresses" {
  value = module.container_app.outbound_ip_addresses
}

output "container_fqdn" {
  value = module.container_app.fqdn
}

# https://restaurants-api.internal.calmdune-1edbf9c1.eastus.azurecontainerapps.io
# https://restaurants-api--0000002.internal.calmdune-1edbf9c1.eastus.azurecontainerapps.io
output "container_app_id" {
  description = "Resource ID of the Container App."
  value       = azurerm_container_app.app.id
}

output "container_app_env_id" {
  description = "ID of the Container Apps environment."
  value       = azurerm_container_app_environment.env.id
}

output "fqdn" {
  value = azurerm_container_app.app.ingress[0].fqdn
}

output "default_domain" {
  value = azurerm_container_app_environment.env.default_domain
}

output "static_ip" {
  value = azurerm_container_app_environment.env.static_ip_address
}

output "container_app_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity."
  value       = azurerm_container_app.app.identity[0].principal_id
}

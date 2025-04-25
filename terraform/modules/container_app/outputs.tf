output "container_app_id" {
  description = "Resource ID of the Container App."
  value       = azurerm_container_app.app.id
}

output "container_app_env_id" {
  description = "ID of the Container Apps environment."
  value       = azurerm_container_app_environment.env.id
}

output "container_app_fqdn" {
  description = "Public FQDN of the latest revision (changes on every deployment)."
  value       = azurerm_container_app.app.latest_revision_fqdn
}

output "container_app_identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity."
  value       = azurerm_container_app.app.identity[0].principal_id
}

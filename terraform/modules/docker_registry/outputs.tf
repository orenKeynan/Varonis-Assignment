output "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.this.id
}

output "login_server" {
  description = "Fully-qualified ACR login server (e.g., myregistry.azurecr.io)."
  value       = azurerm_container_registry.this.login_server
}

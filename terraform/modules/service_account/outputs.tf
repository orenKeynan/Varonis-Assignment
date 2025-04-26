output "client_id" {
  description = "The Application (client) ID of the service principal"
  value       = azuread_application.this.client_id
}

output "client_secret" {
  description = "The generated client secret"
  value       = azuread_service_principal_password.this.value
  sensitive   = true
}

output "object_id" {
  description = "The generated object_id"
  value       = azuread_service_principal.this.object_id
}

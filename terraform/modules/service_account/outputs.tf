output "client_id" {
  description = "The Application (client) ID of the service principal"
  value       = azuread_application.this.client_id
}

output "client_secret" {
  description = "The generated client secret"
  value       = azuread_service_principal_password.this.value
  sensitive   = true
}

resource "azuread_application" "this" {
  display_name = var.name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "random_password" "secret" {
  length  = var.secret_length
  special = true
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.id
}

resource "azurerm_container_registry" "this" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku           = var.sku
  admin_enabled = var.admin_enabled

  # Disable public network access if you plan to use private endpoints only
  public_network_access_enabled = var.public_network_access_enabled

  # Optional geo-replication
  dynamic "georeplications" {
    for_each = var.georep_locations
    content {
      location                  = georeplications.value
      zone_redundancy_enabled   = var.georep_zone_redundancy
      regional_endpoint_enabled = true
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "acr_admin" {
  count        = var.admin_enabled ? 1 : 0
  name         = var.admin_secret_name
  key_vault_id = var.key_vault_id
  value        = azurerm_container_registry.this.admin_password
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = var.service_account_id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = var.service_account_id
}
resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name
}

resource "azurerm_key_vault_access_policy" "tf_access" {
  key_vault_id       = azurerm_key_vault.this.id
  tenant_id          = var.tenant_id
  object_id          = var.object_id
  secret_permissions = var.secret_permissions
}

# store password in key vault
resource "azurerm_key_vault_secret" "sql_admin" {
  name         = var.secret_name
  key_vault_id = azurerm_key_vault.this.id
  value        = var.value
}
# create password for admin user
resource "random_password" "sql_admin" {
  length  = 12
  special = true
}

# create key vault
resource "azurerm_key_vault" "sql_adminpas" {
  name                = "kv-sql_admin_pass"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# create access
resource "azurerm_key_vault_access_policy" "tf_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["get", "set", "list"]
}

# store password in key vault
resource "azurerm_key_vault_secret" "sql_admin" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_sql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.mysql_version
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.sql_admin
  minimum_tls_version          = var.tls_version
  tags                         = var.tags
}

resource "azurerm_sql_database" "this" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.this.name
  collation           = var.collation
  sku_name            = var.sku_name
  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags
}

# resource "azurerm_sql_firewall_rule" "rules" {
#   for_each            = var.firewall_rules
#   name                = each.key
#   resource_group_name = azurerm_resource_group.this.name
#   server_name         = azurerm_sql_server.this.name
#   start_ip_address    = each.value.start_ip
#   end_ip_address      = each.value.end_ip
# }
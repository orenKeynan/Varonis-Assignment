
# create password for admin user
resource "random_password" "sql_admin" {
  length  = 12
  special = true
}

# create key vault
resource "azurerm_key_vault" "sql_adminpass" {
  name                = "kv-sql-${var.sql_server_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"
}

# create access
resource "azurerm_key_vault_access_policy" "tf_access" {
  key_vault_id       = azurerm_key_vault.sql_adminpass.id
  tenant_id          = var.tenant_id
  object_id          = var.object_id
  secret_permissions = ["Get", "Set", "List"] # move to different module
}

# store password in key vault
resource "azurerm_key_vault_secret" "sql_admin" {
  name         = "${var.sql_server_name}-admin-password"
  key_vault_id = azurerm_key_vault.sql_adminpass.id
  value        = random_password.sql_admin.result
}

resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.sql_admin.result
  minimum_tls_version          = var.minimum_tls_version
  tags                         = var.tags
}

# Need to make it production grade, meaning what will happen if not using a Serverless SKU
resource "azurerm_mssql_database" "this" {
  name                        = var.database_name
  server_id                   = azurerm_mssql_server.this.id
  sku_name                    = var.sku_name
  read_scale                  = var.read_scale
  geo_backup_enabled          = var.geo_backup_enabled
  tags                        = var.tags
  max_size_gb                 = var.max_size_gb
  min_capacity                = var.min_capacity
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  lifecycle {
    prevent_destroy = true
  }
}

# resource "azurerm_mssql_firewall_rule" "rules" {
#   for_each         = var.firewall_rules
#   name             = each.key
#   server_id        = azurerm_mssql_server.this.id
#   start_ip_address = each.value.start_ip
#   end_ip_address   = each.value.end_ip
# }
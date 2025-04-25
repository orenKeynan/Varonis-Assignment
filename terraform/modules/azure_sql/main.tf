resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
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
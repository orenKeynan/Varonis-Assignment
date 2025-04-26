# store password in key vault
resource "azurerm_key_vault_secret" "sql_admin" {
  name         = var.admin_secret_name
  key_vault_id = var.key_vault_id
  value        = var.administrator_login_password
}

resource "azurerm_mssql_server" "this" {
  name                          = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.sql_version
  public_network_access_enabled = var.public_network_access_enabled
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = var.minimum_tls_version
  tags                          = var.tags
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
    prevent_destroy = false
  }
}


resource "azurerm_private_endpoint" "sql" {
  for_each            = var.private_endpoints
  name                = "${var.sql_server_name}-${each.key}-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value

  private_service_connection {
    name                           = "${var.sql_server_name}-${each.key}-privateserviceconnection"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = var.pdns_zone_group_name
    private_dns_zone_ids = [var.pdns_zone_id]
  }
}

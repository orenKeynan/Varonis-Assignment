resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_sql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  minimum_tls_version          = "1.2"
  tags = {
    environment = "dev"
    terraform   = "true"
  }
}

resource "azurerm_sql_database" "this" {
  name                = var.database_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  server_name         = azurerm_sql_server.this.name
  collation           = var.collation
  sku_name            = var.sku_name
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    environment = "dev"
    terraform   = "true"
  }
}

resource "azurerm_sql_firewall_rule" "rules" {
  for_each            = var.firewall_rules
  name                = each.key
  resource_group_name = azurerm_resource_group.this.name
  server_name         = azurerm_sql_server.this.name
  start_ip_address    = each.value.start_ip
  end_ip_address      = each.value.end_ip
}
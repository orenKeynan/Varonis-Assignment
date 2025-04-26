resource "azurerm_private_dns_zone" "aca_internal" {
  name                = var.pdns_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "this" {
  for_each            = var.private_dns_a_records
  name                = each.key
  zone_name           = azurerm_private_dns_zone.aca_internal.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca_link" {
  name                  = "${azurerm_private_dns_zone.aca_internal.name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aca_internal.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.registration_enabled
}
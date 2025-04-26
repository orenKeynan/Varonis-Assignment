resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
  # default = no endpoints for this subnet
  service_endpoints = lookup(var.subnet_service_endpoints, each.key, [])
}

resource "azurerm_private_dns_zone" "aca_internal" {
  name                = "azurecontainerapps.io" # Or "privatelink.azurecontainerapps.io" etc.
  resource_group_name = var.resource_group_name # Use the same RG as your VNet and App Gateway
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca_link" {
  name                  = "${azurerm_private_dns_zone.aca_internal.name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aca_internal.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = true
}
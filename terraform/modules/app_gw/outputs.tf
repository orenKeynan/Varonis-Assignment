output "application_gateway_id" {
  description = "Resource ID of the Application Gateway."
  value       = azurerm_application_gateway.this.id
}

output "application_gateway_public_ip_id" {
  description = "ID of the public IP attached to the gateway."
  value       = azurerm_public_ip.pip.id
}

output "application_gateway_public_ip" {
  description = "IPv4 address allocated to the gateway."
  value       = azurerm_public_ip.pip.ip_address
}

output "application_gateway_fqdn" {
  description = "DNS name of the public IP (nullable unless you set a DNS label)."
  value       = azurerm_public_ip.pip.fqdn
}

output "waf_enabled" {
  description = "Boolean—true when WAF is in Prevention/Detection mode."
  value       = azurerm_application_gateway.this.waf_configuration[0].enabled
}

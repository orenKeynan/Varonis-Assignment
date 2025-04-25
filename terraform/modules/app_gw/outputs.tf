output "waf_enabled" {
  description = "Boolean—true when WAF is in Prevention/Detection mode."
  value       = azurerm_application_gateway.this.waf_configuration[0].enabled
}

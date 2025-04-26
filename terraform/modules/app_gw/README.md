<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_key_vault_access_policy.appgw_identity_cert_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.tls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_monitor_diagnostic_setting.appgw_access_logs_to_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_user_assigned_identity.appgw_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_gw_name"></a> [app\_gw\_name](#input\_app\_gw\_name) | Application Gateway Name | `string` | n/a | yes |
| <a name="input_app_static_ip"></a> [app\_static\_ip](#input\_app\_static\_ip) | The static ip of the Container app | `string` | n/a | yes |
| <a name="input_app_subnet_id"></a> [app\_subnet\_id](#input\_app\_subnet\_id) | The private subnet of the application | `string` | n/a | yes |
| <a name="input_azure_key_id"></a> [azure\_key\_id](#input\_azure\_key\_id) | ID of Azure Key Vault | `string` | n/a | yes |
| <a name="input_azurerm_public_fqdn"></a> [azurerm\_public\_fqdn](#input\_azurerm\_public\_fqdn) | azure public fqdn | `string` | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | HTTP settings per pool. | <pre>map(object({<br/>    name                                = string<br/>    port                                = number<br/>    protocol                            = string # Http or Https<br/>    cookie_based_affinity               = string # Enabled / Disabled<br/>    request_timeout                     = number<br/>    probe_name                          = optional(string, null)<br/>    pick_host_name_from_backend_address = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_backend_pools"></a> [backend\_pools](#input\_backend\_pools) | Backend pools keyed by arbitrary names. | <pre>map(object({<br/>    name         = string<br/>    fqdns        = optional(list(string))<br/>    ip_addresses = optional(list(string))<br/>  }))</pre> | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Instance count. | `number` | `1` | no |
| <a name="input_enable_waf"></a> [enable\_waf](#input\_enable\_waf) | Turn WAF on/off. | `bool` | `true` | no |
| <a name="input_frontend_ip_configs"></a> [frontend\_ip\_configs](#input\_frontend\_ip\_configs) | Public and/or private front-end IP configurations. | <pre>map(object({<br/>    name               = string<br/>    public_ip_id       = optional(string) # supply one of public_ip_id OR subnet_id<br/>    subnet_id          = optional(string)<br/>    private_ip_address = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_frontend_ports"></a> [frontend\_ports](#input\_frontend\_ports) | Map of frontend-port objects. | <pre>map(object({<br/>    name = string<br/>    port = number<br/>  }))</pre> | n/a | yes |
| <a name="input_gw_ipcfg_name"></a> [gw\_ipcfg\_name](#input\_gw\_ipcfg\_name) | Name of the Gateway-IP-Config block. | `string` | `"gw-ipcfg"` | no |
| <a name="input_health_probes"></a> [health\_probes](#input\_health\_probes) | List of health probes to configure on the Application Gateway | <pre>list(object({<br/>    name                                      = string<br/>    protocol                                  = string           # "Http" or "Https"<br/>    host                                      = optional(string) # e.g. "my-app.internal"<br/>    path                                      = optional(string) # e.g. "/healthz"<br/>    interval                                  = optional(number) # probe interval in seconds<br/>    timeout                                   = optional(number) # probe timeout in seconds<br/>    unhealthy_threshold                       = optional(number) # how many failures before marking unhealthy<br/>    pick_host_name_from_backend_http_settings = optional(bool)   # whether to reuse host from http-settings<br/>    match = optional(object({                                    # what status codes count as healthy<br/>      status_code = list(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | Listener definitions. | <pre>map(object({<br/>    name                           = string<br/>    frontend_ip_configuration_name = string<br/>    frontend_port_name             = string<br/>    protocol                       = string # Http / Https<br/>    ssl_certificate_name           = optional(string)<br/>    host_name                      = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region. | `string` | n/a | yes |
| <a name="input_logs_storage_account_id"></a> [logs\_storage\_account\_id](#input\_logs\_storage\_account\_id) | Storage account for diagnostics. | `string` | n/a | yes |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | Routing rules. | <pre>map(object({<br/>    name                       = string<br/>    rule_type                  = string<br/>    http_listener_name         = string<br/>    backend_address_pool_name  = string<br/>    backend_http_settings_name = string<br/>    priority                   = optional(number)<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing RG. | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention of logs in days | `number` | `30` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | App GW SKU. | `string` | n/a | yes |
| <a name="input_ssl_certs"></a> [ssl\_certs](#input\_ssl\_certs) | Certificates (map for easy SNI future-proofing). | <pre>map(object({<br/>    name         = string<br/>    pfx_path     = string<br/>    pfx_password = string<br/>  }))</pre> | `{}` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet for App GW. | `string` | n/a | yes |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | Identity name to access the cert | `string` | `"container-iden"` | no |
| <a name="input_waf_firewall_mode"></a> [waf\_firewall\_mode](#input\_waf\_firewall\_mode) | Prevention or Detection. | `string` | `"Prevention"` | no |
| <a name="input_waf_rule_set_type"></a> [waf\_rule\_set\_type](#input\_waf\_rule\_set\_type) | Rule set family. | `string` | `"OWASP"` | no |
| <a name="input_waf_rule_set_version"></a> [waf\_rule\_set\_version](#input\_waf\_rule\_set\_version) | OWASP CRS version. | `string` | `"3.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_waf_enabled"></a> [waf\_enabled](#output\_waf\_enabled) | Boolean—true when WAF is in Prevention/Detection mode. |
<!-- END_TF_DOCS -->
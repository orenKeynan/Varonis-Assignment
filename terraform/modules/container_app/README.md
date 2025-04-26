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
| [azurerm_container_app.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |
| [azurerm_container_app_environment.env](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_login_server"></a> [acr\_login\_server](#input\_acr\_login\_server) | ACR Login Server | `string` | n/a | yes |
| <a name="input_acr_secret_name"></a> [acr\_secret\_name](#input\_acr\_secret\_name) | ACR Secret value name | `string` | n/a | yes |
| <a name="input_acr_username"></a> [acr\_username](#input\_acr\_username) | ACR Username | `string` | n/a | yes |
| <a name="input_allow_insecure_connection"></a> [allow\_insecure\_connection](#input\_allow\_insecure\_connection) | n/a | `bool` | `false` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App name | `string` | n/a | yes |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | n/a | `string` | `"ignore"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Container's name | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | vCPU per replica. | `number` | `0.25` | no |
| <a name="input_env"></a> [env](#input\_env) | Map of env‐var name | <pre>map(object({<br/>    value       = optional(string) # for plain text<br/>    secret_name = optional(string) # for container-app‐level secrets<br/>  }))</pre> | `{}` | no |
| <a name="input_external_enabled"></a> [external\_enabled](#input\_external\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_image"></a> [image](#input\_image) | Docker image URI. | `string` | n/a | yes |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | Configuration for the container liveness probe | <pre>object({<br/>    path      = string<br/>    transport = string<br/>    port      = number<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region. | `string` | n/a | yes |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | max number of replicas | `number` | `3` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | GiB per replica. | `string` | `"0.5Gi"` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | minimum number of replicas | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | application port | `number` | n/a | yes |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | Configuration for the container readiness probe | <pre>object({<br/>    path      = string<br/>    transport = string<br/>    port      = number<br/>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing RG. | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention of logs in days | `number` | `30` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secret-name | `map(string)` | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU of container app logs analytics | `string` | `"PerGB2018"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet for container env. | `string` | n/a | yes |
| <a name="input_termination_grace_period_seconds"></a> [termination\_grace\_period\_seconds](#input\_termination\_grace\_period\_seconds) | time for pod to finish it's proecessing before forcing it | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_app_env_id"></a> [container\_app\_env\_id](#output\_container\_app\_env\_id) | ID of the Container Apps environment. |
| <a name="output_container_app_id"></a> [container\_app\_id](#output\_container\_app\_id) | Resource ID of the Container App. |
| <a name="output_container_app_identity_principal_id"></a> [container\_app\_identity\_principal\_id](#output\_container\_app\_identity\_principal\_id) | Principal ID of the system-assigned managed identity. |
| <a name="output_default_domain"></a> [default\_domain](#output\_default\_domain) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_static_ip"></a> [static\_ip](#output\_static\_ip) | n/a |
<!-- END_TF_DOCS -->
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
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_key_vault_secret.acr_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.acr_push](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | The globally-unique name for the Azure Container Registry (3–50 alphanumeric characters). | `string` | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Whether to enable the ‘admin user’ (generates username & passwords). | `bool` | `false` | no |
| <a name="input_admin_secret_name"></a> [admin\_secret\_name](#input\_admin\_secret\_name) | The sql admin Secret name in KV | `string` | `null` | no |
| <a name="input_georep_locations"></a> [georep\_locations](#input\_georep\_locations) | List of additional Azure regions for geo-replication.<br/>If empty, registry is single-region. | `list(string)` | `[]` | no |
| <a name="input_georep_zone_redundancy"></a> [georep\_zone\_redundancy](#input\_georep\_zone\_redundancy) | Enable zone-redundancy on each replicated location (Premium SKU only). | `bool` | `false` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the Key Vaulr | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region (e.g., eastus, westeurope) where the registry will reside. | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Allow public network access to the registry endpoints. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the existing resource group in which to create the registry. | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service Account ID | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | ACR SKU tier: Basic, Standard, or Premium. | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional map of tags to apply to the registry. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | Resource ID of the Azure Container Registry. |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | Fully-qualified ACR login server (e.g., myregistry.azurecr.io). |
<!-- END_TF_DOCS -->
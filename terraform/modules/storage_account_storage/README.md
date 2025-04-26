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
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | The replication type | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | The tier of the storage account | `string` | `"Standard"` | no |
| <a name="input_bypass"></a> [bypass](#input\_bypass) | What traffic is bypassed | `list(string)` | <pre>[<br/>  "AzureServices"<br/>]</pre> | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | What action to do in case it doesn't exists in a rule | `string` | `"Deny"` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | is the data is being encrypted or not | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_network_subnet_ids"></a> [network\_subnet\_ids](#input\_network\_subnet\_ids) | Subnet IDs for virtual network rule | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_sa_name"></a> [sa\_name](#input\_sa\_name) | Storage Account name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | n/a |
<!-- END_TF_DOCS -->
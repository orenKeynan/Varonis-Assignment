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
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.tf_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_permissions"></a> [certificate\_permissions](#input\_certificate\_permissions) | List of permissions of 'cert' | `list(string)` | <pre>[<br/>  "Create",<br/>  "Delete",<br/>  "Get",<br/>  "List",<br/>  "Update"<br/>]</pre> | no |
| <a name="input_key_permissions"></a> [key\_permissions](#input\_key\_permissions) | List of permissions of 'key | `list(string)` | <pre>[<br/>  "Create",<br/>  "Delete",<br/>  "Get",<br/>  "List",<br/>  "Update"<br/>]</pre> | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for the Key Vault | `string` | n/a | yes |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | Object ID to grant secret permissions | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group for the Key Vault | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Key of Secret Name in keyvault | `string` | `null` | no |
| <a name="input_secret_permissions"></a> [secret\_permissions](#input\_secret\_permissions) | List of permissions of 'secret' | `list(string)` | <pre>[<br/>  "Get",<br/>  "Set",<br/>  "List",<br/>  "Delete"<br/>]</pre> | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU type to use | `string` | `"standard"` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID for Key Vault access | `string` | n/a | yes |
| <a name="input_value"></a> [value](#input\_value) | Value to store in keyvault | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | ID of the created Key Vault |
<!-- END_TF_DOCS -->
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
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | VNet CIDRs. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing RG. | `string` | n/a | yes |
| <a name="input_subnet_service_endpoints"></a> [subnet\_service\_endpoints](#input\_subnet\_service\_endpoints) | Map of <subnet\_name> => list(string) of service endpoints. | `map(list(string))` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet\_name => CIDR. | <pre>map(object({<br/>    ip                                            = string<br/>    private_link_service_network_policies_enabled = optional(bool, true)<br/>  }))</pre> | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the VNet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of <subnet\_name> => <subnet\_id> for all subnets. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of <subnet\_name> => object(id,cidr). |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | Address prefixes of the VNet. |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of the virtual network. |
<!-- END_TF_DOCS -->
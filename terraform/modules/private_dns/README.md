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
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.aca_internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aca_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pdns_name"></a> [pdns\_name](#input\_pdns\_name) | The name of the Private DNS Zone to create (e.g., "aca.internal") | `string` | n/a | yes |
| <a name="input_private_dns_a_records"></a> [private\_dns\_a\_records](#input\_private\_dns\_a\_records) | Map of private DNS A records to create. | <pre>map(object({<br/>    ttl     = optional(number, 60)<br/>    records = set(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_registration_enabled"></a> [registration\_enabled](#input\_registration\_enabled) | Whether virtual machines in the linked VNet should be auto-registered in this zone | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which to create the DNS zone and link | `string` | n/a | yes |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The resource ID of the Virtual Network to link the DNS zone to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Resource ID of the Private DNS zone. |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Name of the Private DNS zone. |
<!-- END_TF_DOCS -->
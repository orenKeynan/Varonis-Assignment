<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Display name for the service principal | `string` | n/a | yes |
| <a name="input_secret_expire_hours"></a> [secret\_expire\_hours](#input\_secret\_expire\_hours) | Secret validity period in hours | `number` | `720` | no |
| <a name="input_secret_length"></a> [secret\_length](#input\_secret\_length) | Length of the generated client secret | `number` | `16` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The Application (client) ID of the service principal |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | The generated client secret |
| <a name="output_object_id"></a> [object\_id](#output\_object\_id) | The generated object\_id |
<!-- END_TF_DOCS -->
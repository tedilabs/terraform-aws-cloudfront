# function

This module creates following resources.

- `aws_cloudfront_function` (optional)
- `aws_cloudfront_connection_function` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_connection_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_connection_function) | resource |
| [aws_cloudfront_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_code"></a> [code](#input\_code) | (Required) The source code of the function. Maximum length is 40960 characters for CONNECTION functions. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) A unique name for the CloudFront Function. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | (Required) The identifier of the function's runtime. Valid values are `cloudfront-js-1.0` and `cloudfront-js-2.0`. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A comment to describe the CloudFront Function. Defaults to `Managed by Terraform.`. | `string` | `"Managed by Terraform."` | no |
| <a name="input_key_value_store"></a> [key\_value\_store](#input\_key\_value\_store) | (Optional) The ARN of CloudFront Key Value Store to associate with the function. AWS limits associations to one key value store per function. | `string` | `null` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | (Optional) Whether to publish the function to the LIVE stage after creation or update. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The type of CloudFront Function to create. Valid values are `GENERAL` and `CONNECTION`. Defaults to `GENERAL`. | `string` | `"GENERAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the CloudFront Function. |
| <a name="output_description"></a> [description](#output\_description) | The comment describing the CloudFront function. |
| <a name="output_etag"></a> [etag](#output\_etag) | The ETag hash of the function. This is the value for the DEVELOPMENT stage of the function. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the CloudFront Function. |
| <a name="output_key_value_store"></a> [key\_value\_store](#output\_key\_value\_store) | The ARN of the CloudFront Key Value Store associated with the function, if any. |
| <a name="output_live_stage_etag"></a> [live\_stage\_etag](#output\_live\_stage\_etag) | The ETag hash of the LIVE stage of the function. Will be empty if the function has not been published. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront Function. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_runtime"></a> [runtime](#output\_runtime) | The runtime environment for the function. |
| <a name="output_status"></a> [status](#output\_status) | The status of the function. Can be UNPUBLISHED, UNASSOCIATED or ASSOCIATED. |
| <a name="output_type"></a> [type](#output\_type) | The type of the CloudFront Function. |
<!-- END_TF_DOCS -->

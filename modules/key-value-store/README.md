# key-value-store

This module creates following resources.

- `aws_cloudfront_key_value_store`
- `aws_cloudfrontkeyvaluestore_key` (optional)
- `aws_cloudfrontkeyvaluestore_keys_exclusive` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_key_value_store.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_key_value_store) | resource |
| [aws_cloudfrontkeyvaluestore_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfrontkeyvaluestore_key) | resource |
| [aws_cloudfrontkeyvaluestore_keys_exclusive.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfrontkeyvaluestore_keys_exclusive) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Unique name of the CloudFront Key-Value Store. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the CloudFront Key-Value Store. | `string` | `"Managed by Terraform."` | no |
| <a name="input_exclusive"></a> [exclusive](#input\_exclusive) | (Optional) Whether to manage all keys exclusively. If `true`, all keys not defined in the `keys` variable will be removed from the key-value store. If `false`, keys are managed individually and can coexist with keys managed outside of Terraform. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_items"></a> [items](#input\_items) | (Optional) A map of key-value pairs to store in the CloudFront Key-Value Store. The key is the key name and the value is the value to store. Defaults to `{}`. | `any` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the CloudFront Key-Value Store to be created. | <pre>object({<br/>    create = optional(string, "30m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the CloudFront Key-Value Store. |
| <a name="output_description"></a> [description](#output\_description) | The description of the CloudFront Key-Value Store. |
| <a name="output_etag"></a> [etag](#output\_etag) | The ETag of the CloudFront Key-Value Store. |
| <a name="output_exclusive"></a> [exclusive](#output\_exclusive) | Whether all keys are managed exclusively. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the CloudFront Key-Value Store. |
| <a name="output_items"></a> [items](#output\_items) | The map of key-value pairs stored in the CloudFront Key-Value Store. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront Key-Value Store. |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | The date and time when the CloudFront Key-Value Store was last modified. |
<!-- END_TF_DOCS -->

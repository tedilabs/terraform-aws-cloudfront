# key-group

This module creates following resources.

- `aws_cloudfront_key_group`
- `aws_cloudfront_public_key`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_key_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_key_group) | resource |
| [aws_cloudfront_public_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the CloudFront key group. | `string` | n/a | yes |
| <a name="input_public_keys"></a> [public\_keys](#input\_public\_keys) | (Required) A list of public keys to create and associate with the key group. Each block of `public_keys` as defined below.<br/>    (Required) `name` - A name to identify the public key.<br/>    (Optional) `description` - A comment to describe the public key. Defaults to `Managed by Terraform.`.<br/>    (Required) `public_key` - The encoded public key that you want to add to CloudFront to use with features like field-level encryption. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "Managed by Terraform.")<br/>    public_key  = string<br/>  }))</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The comment for the CloudFront key group. Defaults to `Managed by Terraform.`. | `string` | `"Managed by Terraform."` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | The comment of the CloudFront key group. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the key group. |
| <a name="output_id"></a> [id](#output\_id) | The identifier for the key group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront key group. |
| <a name="output_public_keys"></a> [public\_keys](#output\_public\_keys) | A set of public keys managed by this key group. |
<!-- END_TF_DOCS -->

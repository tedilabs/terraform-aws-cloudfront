# origin-access-control

This module creates following resources.

- `aws_cloudfront_origin_access_control`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) A name to identify the origin access control. | `string` | n/a | yes |
| <a name="input_origin_type"></a> [origin\_type](#input\_origin\_type) | (Required) The type of origin that this origin access control is for. Valid values are `LAMBDA`, `MEDIAPACKAGE_V2`, `MEDIASTORE` and `S3`. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the origin access control. | `string` | `"Managed by Terraform."` | no |
| <a name="input_signing_behavior"></a> [signing\_behavior](#input\_signing\_behavior) | (Optional) Specify which requests CloudFront signs (adds authentication information to). Valid values are `ALWAYS`, `NEVER`, `NO_OVERRIDE`. Defaults to `ALWAYS`.<br/>    `ALWAYS` - CloudFront signs all origin requests, overwriting the `Authorization` header from the viewer request if one exists.<br/>    `NEVER` - CloudFront doesn't sign any origin requests. This value turns off origin access control for all origins in all distributions that use this origin access control.<br/>    `NO_OVERRIDE` - If the viewer request doesn't contain the `Authorization` header, then CloudFront signs the origin request. If the viewer request contains the Authorization header, then CloudFront doesn't sign the origin request and instead passes along the Authorization header from the viewer request. | `string` | `"ALWAYS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the origin access control. |
| <a name="output_description"></a> [description](#output\_description) | The description of the origin access control. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the origin access control. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the origin access control. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront origin access control. |
| <a name="output_origin_type"></a> [origin\_type](#output\_origin\_type) | The type of origin that this origin access control is for. |
| <a name="output_signing_behavior"></a> [signing\_behavior](#output\_signing\_behavior) | Specify which requests CloudFront signs (adds authentication information to). |
| <a name="output_signing_protocol"></a> [signing\_protocol](#output\_signing\_protocol) | The signing protocol of the origin access control. |
<!-- END_TF_DOCS -->

# origin-request-policy

This module creates following resources.

- `aws_cloudfront_origin_request_policy`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.34.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_origin_request_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_request_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) A unique name to identify the CloudFront Origin Request Policy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the origin request policy. | `string` | `"Managed by Terraform."` | no |
| <a name="input_forwarding_cookies"></a> [forwarding\_cookies](#input\_forwarding\_cookies) | (Optional) A configuration for specifying which cookies in viewer requests to be forwarded in the origin requests. `forwarding_cookies` as defined below.<br>    (Required) `behavior` - Determine whether any cookies in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`. Defaults to `NONE`.<br>    (Optional) `items` - A list of cookie names. It only takes effect when `behavior` is `WHITELIST`. | <pre>object({<br>    behavior = optional(string, "NONE")<br>    items    = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_forwarding_headers"></a> [forwarding\_headers](#input\_forwarding\_headers) | (Optional) A configuration for specifying which headers in viewer requests to be forwarded in the origin requests. `forwarding_headers` as defined below.<br>    (Required) `behavior` - Determine whether any headers in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL_VIEWER` and `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`. Defaults to `NONE`.<br>    (Optional) `items` - A list of header names. It only takes effect when `behavior` is `WHITELIST` or `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`. | <pre>object({<br>    behavior = optional(string, "NONE")<br>    items    = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_forwarding_query_strings"></a> [forwarding\_query\_strings](#input\_forwarding\_query\_strings) | (Optional) A configuration for specifying which query strings in viewer requests to be forwarded in the origin requests. `forwarding_query_strings` as defined below.<br>    (Required) `behavior` - Determine whether any query strings in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`. Defaults to `NONE`.<br>    (Optional) `items` - A list of query string names. It only takes effect when `behavior` is `WHITELIST`. | <pre>object({<br>    behavior = optional(string, "NONE")<br>    items    = optional(set(string), [])<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | The description of the origin request policy. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the origin request policy. |
| <a name="output_forwarding_cookies"></a> [forwarding\_cookies](#output\_forwarding\_cookies) | A configuration for specifying which cookies to be forwarded in the origin requests. |
| <a name="output_forwarding_headers"></a> [forwarding\_headers](#output\_forwarding\_headers) | A configuration for specifying which headers to be forwarded in the origin requests. |
| <a name="output_forwarding_query_strings"></a> [forwarding\_query\_strings](#output\_forwarding\_query\_strings) | A configuration for specifying which query strings to be forwarded in the origin requests. |
| <a name="output_id"></a> [id](#output\_id) | The identifier for the CloudFront origin request policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront origin request policy. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

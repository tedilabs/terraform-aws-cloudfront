# origin-request-policy

This module creates following resources.

- `aws_cloudfront_origin_request_policy`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.20 |
| <a name="requirement_telemetry"></a> [telemetry](#requirement\_telemetry) | >= 0.2.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.20 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudfront_origin_request_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_request_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | (Required) A unique name to identify the CloudFront Origin Request Policy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the origin request policy. | `string` | `"Managed by Terraform."` | no |
| <a name="input_forwarding_cookies"></a> [forwarding\_cookies](#input\_forwarding\_cookies) | (Optional) A configuration for specifying which cookies in viewer requests to be forwarded in the origin requests. `forwarding_cookies` as defined below.<br/>    (Required) `behavior` - Determine whether any cookies in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`, `BLACKLIST`. Defaults to `NONE`.<br/>    (Optional) `items` - A list of cookie names. It only takes effect when `behavior` are `WHITELIST`, `BLACKLIST`. | <pre>object({<br/>    behavior = optional(string, "NONE")<br/>    items    = optional(set(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_forwarding_headers"></a> [forwarding\_headers](#input\_forwarding\_headers) | (Optional) A configuration for specifying which headers in viewer requests to be forwarded in the origin requests. `forwarding_headers` as defined below.<br/>    (Required) `behavior` - Determine whether any headers in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `BLACKLIST`, `ALL_VIEWER` and `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`. Defaults to `NONE`.<br/>    (Optional) `items` - A list of header names. It only takes effect when `behavior` are `WHITELIST`, `BLACKLIST` or `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`. | <pre>object({<br/>    behavior = optional(string, "NONE")<br/>    items    = optional(set(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_forwarding_query_strings"></a> [forwarding\_query\_strings](#input\_forwarding\_query\_strings) | (Optional) A configuration for specifying which query strings in viewer requests to be forwarded in the origin requests. `forwarding_query_strings` as defined below.<br/>    (Required) `behavior` - Determine whether any query strings in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `BLACKLIST`, `ALL`. Defaults to `NONE`.<br/>    (Optional) `items` - A list of query string names. It only takes effect when `behavior` are `WHITELIST`, `BLACKLIST`. | <pre>object({<br/>    behavior = optional(string, "NONE")<br/>    items    = optional(set(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_telemetry"></a> [telemetry](#input\_telemetry) | (Optional) A configuration to collect telemetry data for the module. This is used to improve the module and its features. To send pseudonyms instead of identifying values such as the hostname and the Git remote, set `pseudonymization_enabled` to `true`. Pseudonyms are not anonymous; to keep data from being sent, disable its collector. The default configuration enables telemetry collection for machine, network, git, github, github actions, HCP Terraform, terraform, and toolchain. You can disable telemetry collection by setting `enabled` to `false`. `telemetry` block as defined below.<br/>    (Optional) `enabled` - Whether to enable telemetry collection. Default is `true`.<br/>    (Optional) `capture_machine` - Whether to capture machine information. Default is `true`.<br/>    (Optional) `capture_network` - Whether to capture network information. Default is `true`.<br/>    (Optional) `capture_git` - Whether to capture git information. Default is `true`.<br/>    (Optional) `capture_github` - Whether to capture GitHub information. Default is `true`.<br/>    (Optional) `capture_github_actions` - Whether to capture GitHub Actions information. Default is `true`.<br/>    (Optional) `capture_hcp_terraform` - Whether to capture HCP Terraform information. Default is `true`.<br/>    (Optional) `capture_terraform` - Whether to capture Terraform information. Default is `true`.<br/>    (Optional) `capture_toolchain` - Whether to capture toolchain information. Default is `true`.<br/>    (Optional) `pseudonymization_enabled` - Whether to enable pseudonymization of the captured data. Default is `false`. | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    capture_machine        = optional(bool, true)<br/>    capture_network        = optional(bool, true)<br/>    capture_git            = optional(bool, true)<br/>    capture_github         = optional(bool, true)<br/>    capture_github_actions = optional(bool, true)<br/>    capture_hcp_terraform  = optional(bool, true)<br/>    capture_terraform      = optional(bool, true)<br/>    capture_toolchain      = optional(bool, true)<br/><br/>    pseudonymization_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the CloudFront origin request policy. |
| <a name="output_description"></a> [description](#output\_description) | The description of the origin request policy. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the origin request policy. |
| <a name="output_forwarding_cookies"></a> [forwarding\_cookies](#output\_forwarding\_cookies) | A configuration for specifying which cookies to be forwarded in the origin requests. |
| <a name="output_forwarding_headers"></a> [forwarding\_headers](#output\_forwarding\_headers) | A configuration for specifying which headers to be forwarded in the origin requests. |
| <a name="output_forwarding_query_strings"></a> [forwarding\_query\_strings](#output\_forwarding\_query\_strings) | A configuration for specifying which query strings to be forwarded in the origin requests. |
| <a name="output_id"></a> [id](#output\_id) | The identifier for the CloudFront origin request policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront origin request policy. |
<!-- END_TF_DOCS -->

# vpc-origin

This module creates following resources.

- `aws_cloudfront_vpc_origin`

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

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_share"></a> [share](#module\_share) | tedilabs/organization/aws//modules/ram-share | ~> 0.8.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudfront_vpc_origin.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | (Required) The ARN of the VPC origin endpoint to associate with the CloudFront VPC Origin. The VPC origin endpoint must be an Application Load Balancer (ALB), Network Load Balancer (NLB), or EC2 instance in the same AWS Region as the CloudFront distribution. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the CloudFront VPC Origin. | `string` | n/a | yes |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | (Optional) The HTTP port for the CloudFront VPC origin endpoint configuration. Defaults to `80`. | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | (Optional) The HTTPS port for the CloudFront VPC origin endpoint configuration. Defaults to `443`. | `number` | `443` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_protocol_policy"></a> [protocol\_policy](#input\_protocol\_policy) | (Optional) The origin protocol policy for the CloudFront VPC origin endpoint configuration. The origin protocol policy determines the protocol (HTTP or HTTPS) that you want CloudFront to use when connecting to the origin. Valid values are `HTTP_ONLY`, `HTTPS_ONLY` or `MATCH_VIEWER`. Defaults to `MATCH_VIEWER`. | `string` | `"MATCH_VIEWER"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_shares"></a> [shares](#input\_shares) | (Optional) A list of resource shares via RAM (Resource Access Manager). | <pre>list(object({<br/>    name = optional(string)<br/><br/>    permissions = optional(set(string), ["AWSRAMDefaultPermissionCloudfrontVpcOrigin"])<br/><br/>    external_principals_allowed = optional(bool, false)<br/>    principals                  = optional(set(string), [])<br/><br/>    tags = optional(map(string), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_ssl_security_policy"></a> [ssl\_security\_policy](#input\_ssl\_security\_policy) | (Optional) The minimum SSL protocol that CloudFront uses with the origin. Valid values are `SSLv3`, `TLSv1`, `TLSv1.1` or `TLSv1.2`. Defaults to `TLSv1.2`. | `string` | `"TLSv1.2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_telemetry"></a> [telemetry](#input\_telemetry) | (Optional) A configuration to collect telemetry data for the module. This is used to improve the module and its features. To send pseudonyms instead of identifying values such as the hostname and the Git remote, set `pseudonymization_enabled` to `true`. Pseudonyms are not anonymous; to keep data from being sent, disable its collector. The default configuration enables telemetry collection for machine, network, git, github, github actions, HCP Terraform, terraform, and toolchain. You can disable telemetry collection by setting `enabled` to `false`. `telemetry` block as defined below.<br/>    (Optional) `enabled` - Whether to enable telemetry collection. Default is `true`.<br/>    (Optional) `capture_machine` - Whether to capture machine information. Default is `true`.<br/>    (Optional) `capture_network` - Whether to capture network information. Default is `true`.<br/>    (Optional) `capture_git` - Whether to capture git information. Default is `true`.<br/>    (Optional) `capture_github` - Whether to capture GitHub information. Default is `true`.<br/>    (Optional) `capture_github_actions` - Whether to capture GitHub Actions information. Default is `true`.<br/>    (Optional) `capture_hcp_terraform` - Whether to capture HCP Terraform information. Default is `true`.<br/>    (Optional) `capture_terraform` - Whether to capture Terraform information. Default is `true`.<br/>    (Optional) `capture_toolchain` - Whether to capture toolchain information. Default is `true`.<br/>    (Optional) `pseudonymization_enabled` - Whether to enable pseudonymization of the captured data. Default is `false`. | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    capture_machine        = optional(bool, true)<br/>    capture_network        = optional(bool, true)<br/>    capture_git            = optional(bool, true)<br/>    capture_github         = optional(bool, true)<br/>    capture_github_actions = optional(bool, true)<br/>    capture_hcp_terraform  = optional(bool, true)<br/>    capture_terraform      = optional(bool, true)<br/>    capture_toolchain      = optional(bool, true)<br/><br/>    pseudonymization_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the CloudFront VPC Origin. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The ARN of the CloudFront VPC Origin endpoint. |
| <a name="output_etag"></a> [etag](#output\_etag) | The ETag of the CloudFront VPC Origin. |
| <a name="output_http_port"></a> [http\_port](#output\_http\_port) | The HTTP port of the CloudFront VPC Origin. |
| <a name="output_https_port"></a> [https\_port](#output\_https\_port) | The HTTPS port of the CloudFront VPC Origin. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the CloudFront VPC Origin. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront VPC Origin. |
| <a name="output_protocol_policy"></a> [protocol\_policy](#output\_protocol\_policy) | The origin protocol policy applied to the CloudFront VPC Origin. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_sharing"></a> [sharing](#output\_sharing) | The configuration for sharing of the Cloudfront VPC Origin.<br/>    `status` - An indication of whether the VPC Origin is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are `NOT_SHARED`, `SHARED_BY_ME` or `SHARED_WITH_ME`.<br/>    `shares` - The list of resource shares via RAM (Resource Access Manager). |
| <a name="output_ssl_security_policy"></a> [ssl\_security\_policy](#output\_ssl\_security\_policy) | The minimum SSL protocol that CloudFront uses with the origin. |
<!-- END_TF_DOCS -->

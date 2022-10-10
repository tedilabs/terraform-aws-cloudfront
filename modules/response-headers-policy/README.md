# response-headers-policy

This module creates following resources.

- `aws_cloudfront_response_headers_policy`

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
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) A unique name to identify the CloudFront Origin Request Policy. | `string` | n/a | yes |
| <a name="input_cors"></a> [cors](#input\_cors) | (Optional) A configuraiton for a set of HTTP response headers for CORS(Cross-Origin Resource Sharing). `cors` as defined below.<br>    (Optional) `enabled` - Whether to enable CORS configuration for the response headers policy .<br>    (Optional) `override` - Whether CloudFront override the response from the origin which contains one of the CORS headers specified in this policy. Defaults to `true`.<br>    (Optional) `access_control_allow_credentials` - Whether CloudFront adds the `Access-Control-Allow-Credentials` header in responses to CORS requests. When enabled, CloudFront adds the `Access-Control-Allow-Credentials: true` header in responses to CORS requests. Otherwise, CloudFront doesn't add this header to responses. Defaults to `false`.<br>    (Optional) `access_control_allow_headers` - A set of HTTP header names for CloudFront to include as values for the `Access-Control-Allow-Headers` HTTP response header in responses to CORS preflight requests. Defaults to `["*"]` (All headers).<br>    (Optional) `access_control_allow_methods` - A set of HTTP methods for CloudFront to include as values for the `Access-Control-Allow-Methods` header in responses to CORS preflight requests. Valid values are `GET`, `DELETE`, `HEAD`, `OPTIONS`, `PATCH`, `POST`, `PUT`, or `ALL`). Defaults to `ALL` (All methods).<br>    (Optional) `access_control_allow_origins` - A set of the origins that CloudFront can use as values in the `Access-Control-Allow-Origin` response header. Use `*` value to allow CORS requests from all origins. Defaults to `["*"]` (All origins).<br>    (Optional) `access_control_expose_headers` - A set of HTTP header names for CloudFront to include as values for the `Access-Control-Expose-Headers` header in responses to CORS requests. Defaults to `[]` (None).<br>    (Optional) `access_control_max_age` - The number of seconds for CloudFront to use as the value for the `Access-Control-Max-Age` header in responses to CORS preflight requests. | <pre>object({<br>    enabled  = optional(bool, false)<br>    override = optional(bool, true)<br><br>    access_control_allow_credentials = optional(bool, false)<br>    access_control_allow_headers     = optional(set(string), ["*"])<br>    access_control_allow_methods     = optional(set(string), ["ALL"])<br>    access_control_allow_origins     = optional(set(string), ["*"])<br>    access_control_expose_headers    = optional(set(string), [])<br>    access_control_max_age           = optional(number, 600)<br>  })</pre> | `{}` | no |
| <a name="input_custom_headers"></a> [custom\_headers](#input\_custom\_headers) | (Optional) A configuraiton for specifying the custom HTTP headers in HTTP responses sent from CloudFront. Each item of `custom_headers` as defined below.<br>    (Required) `name` - The HTTP response header name.<br>    (Optional) `value` - The value for the HTTP response header. If a header value is not provided, CloudFront adds the empty header (with no value) to the response.<br>    (Optional) `override` - Whether CloudFront overrides a response header with the same name received from the origin with the header specifies here. | <pre>list(object({<br>    name     = string<br>    value    = string<br>    override = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the origin request policy. | `string` | `"Managed by Terraform."` | no |
| <a name="input_server_timing_header"></a> [server\_timing\_header](#input\_server\_timing\_header) | (Optional) A configuraiton for `Server-Timing` header in HTTP responses sent from CloudFront. This header can be used to view metrics for insights about CloudFront's behavior and performance. You can see which cache layer served a cache hit, the first byte latency from the origin when there was a cache miss. The metrics in the `Server-Timing` header can help you troubleshoot issues or test the efficiency of the CloudFront configuration. `server_timing_header` as defined below.<br>    (Optional) `enabled` - Whether to add the `Server-Timing` header in HTTP response that match a cache behavior associated with this response headers policy. Defaults to `false`.<br>    (Optional) `sampling_rate` - A number from 0 through 100 that specifies the percentage of responses that you want CloudFront to add the `Server-Timing` header to. When you set the sampling rate to `100`, CloudFront adds the `Server-Timing` header to the HTTP response for every request that matches the cache behavior that the response headers policy is attached to. Can have up to four decimal places like `9.9999`. | <pre>object({<br>    enabled       = optional(bool, false)<br>    sampling_rate = optional(number, 0)<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cors"></a> [cors](#output\_cors) | A configuraiton for a set of HTTP response headers for CORS(Cross-Origin Resource Sharing). |
| <a name="output_custom_headers"></a> [custom\_headers](#output\_custom\_headers) | A configuraiton for custom headers in the response headers. |
| <a name="output_description"></a> [description](#output\_description) | The description of the response headers policy. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the response headers policy. |
| <a name="output_id"></a> [id](#output\_id) | The identifier for the CloudFront response headers policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront response headers policy. |
| <a name="output_server_timing_header"></a> [server\_timing\_header](#output\_server\_timing\_header) | A configuraiton for `Server-Timing` header in HTTP responses sent from CloudFront. |
| <a name="output_zzz"></a> [zzz](#output\_zzz) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

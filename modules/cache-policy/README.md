# cache-policy

This module creates following resources.

- `aws_cloudfront_cache_policy`

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
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_cache_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) A unique name to identify the CloudFront Cache Policy. | `string` | n/a | yes |
| <a name="input_cache_keys_in_cookies"></a> [cache\_keys\_in\_cookies](#input\_cache\_keys\_in\_cookies) | (Optional) A configuraiton for specifying which cookies to use as cache key in viewer requests. The values in the cache key are automatically forwarded in requests to the origin. `cache_keys_in_cookies` as defined below.<br>    (Required) `behavior` - Determine whether any cookies in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. Valid values are `NONE`, `WHITELIST`, `BLACKLIST`, `ALL`. Defaults to `NONE`.<br>    (Optional) `items` - A list of cookie names. It only takes effect when `behavior` is `WHITELIST` or `BLACKLIST`. | <pre>object({<br>    behavior = optional(string, "NONE")<br>    items    = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_cache_keys_in_headers"></a> [cache\_keys\_in\_headers](#input\_cache\_keys\_in\_headers) | (Optional) A configuraiton for specifying which headers to use as cache key in viewer requests. The values in the cache key are automatically forwarded in requests to the origin. `cache_keys_in_headers` as defined below.<br>    (Required) `behavior` - Determine whether any headers in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. Valid values are `NONE`, `WHITELIST`. Defaults to `NONE`.<br>    (Optional) `items` - A list of header names. It only takes effect when `behavior` is `WHITELIST`. | <pre>object({<br>    behavior = optional(string, "NONE")<br>    items    = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_cache_keys_in_query_strings"></a> [cache\_keys\_in\_query\_strings](#input\_cache\_keys\_in\_query\_strings) | (Optional) A configuraiton for specifying which query strings to use as cache key in viewer requests. The values in the cache key are automatically forwarded in requests to the origin. `cache_keys_in_query_strings` as defined below.<br>    (Required) `behavior` - Determine whether any query strings in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. Valid values are `NONE`, `WHITELIST`, `BLACKLIST`, `ALL`. Defaults to `NONE`.<br>    (Optional) `items` - A list of query string names. It only takes effect when `behavior` is `WHITELIST` or `BLACKLIST`. | <pre>object({<br>    behavior = optional(string, "NONE")<br>    items    = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | (Optional) The default time to live in seconds. The amount of time is that you want objects to stay in the CloudFront cache before another request to the origin to see if the object has been updated. Defaults to `86400` (one day). | `number` | `86400` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the cache policy. | `string` | `"Managed by Terraform."` | no |
| <a name="input_max_ttl"></a> [max\_ttl](#input\_max\_ttl) | (Optional) The maximum time to live in seconds. The amount of time is that you want objects to stay in the CloudFront cache before another request to the origin to see if the object has been updated. Defaults to `31536000` (one year). | `number` | `31536000` | no |
| <a name="input_min_ttl"></a> [min\_ttl](#input\_min\_ttl) | (Optional) The minimum time to live in seconds. The amount of time is that you want objects to stay in the CloudFront cache before another request to the origin to see if the object has been updated. Defaults to `1`. | `number` | `1` | no |
| <a name="input_supported_compression_formats"></a> [supported\_compression\_formats](#input\_supported\_compression\_formats) | (Optional) A list of compression formats to enable CloudFront to request and cache objects that are compressed in these compression formats, when the viewer supports it. These setting also allow CloudFront's automatic compression to work. Valid values are `BROTLI` and `GZIP`. | `set(string)` | <pre>[<br>  "BROTLI",<br>  "GZIP"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cache_keys_in_cookies"></a> [cache\_keys\_in\_cookies](#output\_cache\_keys\_in\_cookies) | A configuraiton for specifying which cookies to use as cache key in viewer requests. |
| <a name="output_cache_keys_in_headers"></a> [cache\_keys\_in\_headers](#output\_cache\_keys\_in\_headers) | A configuraiton for specifying which headers to use as cache key in viewer requests. |
| <a name="output_cache_keys_in_query_strings"></a> [cache\_keys\_in\_query\_strings](#output\_cache\_keys\_in\_query\_strings) | A configuraiton for specifying which query strings to use as cache key in viewer requests. |
| <a name="output_default_ttl"></a> [default\_ttl](#output\_default\_ttl) | The default time to live in seconds. |
| <a name="output_description"></a> [description](#output\_description) | The description of the cache policy. |
| <a name="output_etag"></a> [etag](#output\_etag) | The current version of the cache policy. |
| <a name="output_id"></a> [id](#output\_id) | The identifier for the CloudFront cache policy. |
| <a name="output_max_ttl"></a> [max\_ttl](#output\_max\_ttl) | The maximum time to live in seconds. |
| <a name="output_min_ttl"></a> [min\_ttl](#output\_min\_ttl) | The minimum time to live in seconds. |
| <a name="output_name"></a> [name](#output\_name) | The name of the CloudFront cache policy. |
| <a name="output_supported_compression_formats"></a> [supported\_compression\_formats](#output\_supported\_compression\_formats) | The list of compression formats to enable CloudFront to request and cache objects that are compressed in these compression formats, when the viewer supports it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

output "id" {
  description = "The identifier for the CloudFront cache policy."
  value       = aws_cloudfront_cache_policy.this.id
}

output "etag" {
  description = "The current version of the cache policy."
  value       = aws_cloudfront_cache_policy.this.etag
}

output "name" {
  description = "The name of the CloudFront cache policy."
  value       = aws_cloudfront_cache_policy.this.name
}

output "description" {
  description = "The description of the cache policy."
  value       = aws_cloudfront_cache_policy.this.comment
}

output "default_ttl" {
  description = "The default time to live in seconds."
  value       = aws_cloudfront_cache_policy.this.default_ttl
}

output "min_ttl" {
  description = "The minimum time to live in seconds."
  value       = aws_cloudfront_cache_policy.this.min_ttl
}

output "max_ttl" {
  description = "The maximum time to live in seconds."
  value       = aws_cloudfront_cache_policy.this.max_ttl
}

output "supported_compression_formats" {
  description = "The list of compression formats to enable CloudFront to request and cache objects that are compressed in these compression formats, when the viewer supports it"
  value       = var.supported_compression_formats
}

output "cache_keys_in_cookies" {
  description = "A configuration for specifying which cookies to use as cache key in viewer requests."
  value = {
    behavior = {
      for k, v in local.behaviors :
      v => k
    }[aws_cloudfront_cache_policy.this.parameters_in_cache_key_and_forwarded_to_origin[0].cookies_config[0].cookie_behavior]
    items = try(aws_cloudfront_cache_policy.this.parameters_in_cache_key_and_forwarded_to_origin[0].cookies_config[0].cookies[0].items, toset([]))
  }
}

output "cache_keys_in_headers" {
  description = "A configuration for specifying which headers to use as cache key in viewer requests."
  value = {
    behavior = {
      for k, v in local.behaviors :
      v => k
    }[aws_cloudfront_cache_policy.this.parameters_in_cache_key_and_forwarded_to_origin[0].headers_config[0].header_behavior]
    items = try(aws_cloudfront_cache_policy.this.parameters_in_cache_key_and_forwarded_to_origin[0].headers_config[0].headers[0].items, toset([]))
  }
}

output "cache_keys_in_query_strings" {
  description = "A configuration for specifying which query strings to use as cache key in viewer requests."
  value = {
    behavior = {
      for k, v in local.behaviors :
      v => k
    }[aws_cloudfront_cache_policy.this.parameters_in_cache_key_and_forwarded_to_origin[0].query_strings_config[0].query_string_behavior]
    items = try(aws_cloudfront_cache_policy.this.parameters_in_cache_key_and_forwarded_to_origin[0].query_strings_config[0].query_strings[0].items, toset([]))
  }
}

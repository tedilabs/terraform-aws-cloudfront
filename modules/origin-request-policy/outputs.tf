output "id" {
  description = "The identifier for the CloudFront origin request policy."
  value       = aws_cloudfront_origin_request_policy.this.id
}

output "etag" {
  description = "The current version of the origin request policy."
  value       = aws_cloudfront_origin_request_policy.this.etag
}

output "name" {
  description = "The name of the CloudFront origin request policy."
  value       = aws_cloudfront_origin_request_policy.this.name
}

output "description" {
  description = "The description of the origin request policy."
  value       = aws_cloudfront_origin_request_policy.this.comment
}

output "forwarding_cookies" {
  description = "A configuration for specifying which cookies to be forwarded in the origin requests."
  value = {
    behavior = {
      for k, v in local.behaviors :
      v => k
    }[aws_cloudfront_origin_request_policy.this.cookies_config[0].cookie_behavior]
    items = try(aws_cloudfront_origin_request_policy.this.cookies_config[0].cookies[0].items, toset([]))
  }
}

output "forwarding_headers" {
  description = "A configuration for specifying which headers to be forwarded in the origin requests."
  value = {
    behavior = {
      for k, v in local.behaviors :
      v => k
    }[aws_cloudfront_origin_request_policy.this.headers_config[0].header_behavior]
    items = try(aws_cloudfront_origin_request_policy.this.headers_config[0].headers[0].items, toset([]))
  }
}

output "forwarding_query_strings" {
  description = "A configuration for specifying which query strings to be forwarded in the origin requests."
  value = {
    behavior = {
      for k, v in local.behaviors :
      v => k
    }[aws_cloudfront_origin_request_policy.this.query_strings_config[0].query_string_behavior]
    items = try(aws_cloudfront_origin_request_policy.this.query_strings_config[0].query_strings[0].items, toset([]))
  }
}

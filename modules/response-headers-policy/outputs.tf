output "id" {
  description = "The identifier for the CloudFront response headers policy."
  value       = aws_cloudfront_response_headers_policy.this.id
}

output "etag" {
  description = "The current version of the response headers policy."
  value       = aws_cloudfront_response_headers_policy.this.etag
}

output "name" {
  description = "The name of the CloudFront response headers policy."
  value       = aws_cloudfront_response_headers_policy.this.name
}

output "description" {
  description = "The description of the response headers policy."
  value       = aws_cloudfront_response_headers_policy.this.comment
}

output "cors" {
  description = "A configuration for a set of HTTP response headers for CORS(Cross-Origin Resource Sharing)."
  value       = var.cors
}

output "custom_headers" {
  description = "A configuration for custom headers in the response headers."
  value       = aws_cloudfront_response_headers_policy.this.custom_headers_config[0].items
}

output "security_headers" {
  description = "A configuration for several security-related HTTP response headers."
  value = {
    content_security_policy   = var.content_security_policy_header
    content_type_options      = var.content_type_options_header
    frame_options             = var.frame_options_header
    referrer_policy           = var.referrer_policy_header
    strict_transport_security = var.strict_transport_security_header
    xss_protection            = var.xss_protection_header
  }
}

output "server_timing_header" {
  description = "A configuration for `Server-Timing` header in HTTP responses sent from CloudFront."
  value       = aws_cloudfront_response_headers_policy.this.server_timing_headers_config[0]
}

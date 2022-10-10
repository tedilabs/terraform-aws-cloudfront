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
  description = "A configuraiton for a set of HTTP response headers for CORS(Cross-Origin Resource Sharing)."
  value       = var.cors
}

output "custom_headers" {
  description = "A configuraiton for custom headers in the response headers."
  value       = aws_cloudfront_response_headers_policy.this.custom_headers_config[0].items
}

output "server_timing_header" {
  description = "A configuraiton for `Server-Timing` header in HTTP responses sent from CloudFront."
  value       = aws_cloudfront_response_headers_policy.this.server_timing_headers_config[0]
}

output "zzz" {
  value = aws_cloudfront_response_headers_policy.this.security_headers_config
}

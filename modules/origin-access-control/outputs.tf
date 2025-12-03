output "arn" {
  description = "The ARN of the origin access control."
  value       = aws_cloudfront_origin_access_control.this.arn
}

output "id" {
  description = "The ID of the origin access control."
  value       = aws_cloudfront_origin_access_control.this.id
}

output "etag" {
  description = "The current version of the origin access control."
  value       = aws_cloudfront_origin_access_control.this.etag
}

output "name" {
  description = "The name of the CloudFront origin access control."
  value       = aws_cloudfront_origin_access_control.this.name
}

output "description" {
  description = "The description of the origin access control."
  value       = aws_cloudfront_origin_access_control.this.description
}

output "origin_type" {
  description = "The type of origin that this origin access control is for."
  value = {
    for k, v in local.origin_types :
    v => k
  }[aws_cloudfront_origin_access_control.this.origin_access_control_origin_type]
}

output "signing_behavior" {
  description = "Specify which requests CloudFront signs (adds authentication information to)."
  value = {
    for k, v in local.signing_behaviors :
    v => k
  }[aws_cloudfront_origin_access_control.this.signing_behavior]
}

output "signing_protocol" {
  description = "The signing protocol of the origin access control."
  value       = upper(aws_cloudfront_origin_access_control.this.signing_protocol)
}

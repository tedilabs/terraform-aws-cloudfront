output "id" {
  description = "The ID of the CloudFront Key-Value Store."
  value       = aws_cloudfront_key_value_store.this.id
}

output "arn" {
  description = "The ARN of the CloudFront Key-Value Store."
  value       = aws_cloudfront_key_value_store.this.arn
}

output "etag" {
  description = "The ETag of the CloudFront Key-Value Store."
  value       = aws_cloudfront_key_value_store.this.etag
}

output "name" {
  description = "The name of the CloudFront Key-Value Store."
  value       = aws_cloudfront_key_value_store.this.name
}

output "description" {
  description = "The description of the CloudFront Key-Value Store."
  value       = aws_cloudfront_key_value_store.this.comment
}

output "exclusive" {
  description = "Whether all keys are managed exclusively."
  value       = var.exclusive
}

output "items" {
  description = "The map of key-value pairs stored in the CloudFront Key-Value Store."
  value       = local.items
}

output "updated_at" {
  description = "The date and time when the CloudFront Key-Value Store was last modified."
  value       = aws_cloudfront_key_value_store.this.last_modified_time
}

# output "debug" {
#   value = {
#     for k, v in aws_cloudfront_key_value_store.this :
#     k => v
#     if !contains(["id", "arn", "name", "comment", "etag", "last_modified_time", "timeouts"], k)
#   }
# }

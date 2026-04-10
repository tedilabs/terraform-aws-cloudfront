output "id" {
  description = "The identifier for the key group."
  value       = aws_cloudfront_key_group.this.id
}

output "etag" {
  description = "The current version of the key group."
  value       = aws_cloudfront_key_group.this.etag
}

output "name" {
  description = "The name of the CloudFront key group."
  value       = aws_cloudfront_key_group.this.name
}

output "description" {
  description = "The comment of the CloudFront key group."
  value       = aws_cloudfront_key_group.this.comment
}

output "public_keys" {
  description = <<EOF
  A set of public keys managed by this key group.
  EOF
  value = {
    for name, key in aws_cloudfront_public_key.this : name => {
      id          = key.id
      etag        = key.etag
      name        = key.name
      description = key.comment
    }
  }
}

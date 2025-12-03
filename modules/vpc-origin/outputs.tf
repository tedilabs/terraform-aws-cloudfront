output "id" {
  description = "The ID of the CloudFront VPC Origin."
  value       = aws_cloudfront_vpc_origin.this.id
}

output "arn" {
  description = "The ARN of the CloudFront VPC Origin."
  value       = aws_cloudfront_vpc_origin.this.arn
}

output "etag" {
  description = "The ETag of the CloudFront VPC Origin."
  value       = aws_cloudfront_vpc_origin.this.etag
}

output "name" {
  description = "The name of the CloudFront VPC Origin."
  value       = aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].name
}

output "endpoint" {
  description = "The ARN of the CloudFront VPC Origin endpoint."
  value       = aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].arn
}

output "protocol_policy" {
  description = "The origin protocol policy applied to the CloudFront VPC Origin."
  value = {
    for k, v in local.protocol_policy :
    v => k
  }[aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].origin_protocol_policy]
}

output "ssl_security_policy" {
  description = "The minimum SSL protocol that CloudFront uses with the origin."
  value       = var.ssl_security_policy
}

output "http_port" {
  description = "The HTTP port of the CloudFront VPC Origin."
  value       = aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].http_port
}

output "https_port" {
  description = "The HTTPS port of the CloudFront VPC Origin."
  value       = aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].https_port
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}

output "sharing" {
  description = <<EOF
  The configuration for sharing of the Cloudfront VPC Origin.
    `status` - An indication of whether the VPC Origin is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are `NOT_SHARED`, `SHARED_BY_ME` or `SHARED_WITH_ME`.
    `shares` - The list of resource shares via RAM (Resource Access Manager).
  EOF
  value = {
    status = length(module.share) > 0 ? "SHARED_BY_ME" : "NOT_SHARED"
    shares = module.share
  }
}

# output "debug" {
#   value = merge({
#     for k, v in aws_cloudfront_vpc_origin.this :
#     k => v
#     if !contains(["id", "arn", "etag", "origin_protocol_policy", "tags", "tags_all", "timeouts"], k)
#     }, {
#     vpc_origin_endpoint_config = {
#       for k, v in aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0] :
#       k => v
#       if !contains(["name", "arn", "origin_protocol_policy", "http_port", "https_port", "origin_ssl_protocols"], k)
#     }
#   })
# }

output "arn" {
  description = "The ARN (Amazon Resource Name) for the distribution. For example: `arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5`."
  value       = aws_cloudfront_distribution.this.arn
}

output "id" {
  description = "The identifier for the CloudFront distribution. For example: `EDFDVBD632BHDS5`."
  value       = aws_cloudfront_distribution.this.id
}

output "etag" {
  description = "The current version of the distribution's information. For example: `E2QWRUHAPOMQZL`."
  value       = aws_cloudfront_distribution.this.etag
}

output "name" {
  description = "The name of the CloudFront distribution."
  value       = var.name
}

output "aliases" {
  description = "A list of alternate domain names for the distribution."
  value       = aws_cloudfront_distribution.this.aliases
}

output "description" {
  description = "The description of the distribution."
  value       = aws_cloudfront_distribution.this.comment
}

output "status" {
  description = "The current status of the distribution. `Deployed` if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = aws_cloudfront_distribution.this.status
}

output "updated_at" {
  description = "The date and time the distribution was last modified."
  value       = aws_cloudfront_distribution.this.last_modified_time
}

output "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  value       = aws_cloudfront_distribution.this.enabled
}

output "price_class" {
  description = "The price class for this distribution."
  value       = var.price_class
}

output "http_version" {
  description = "The supported maximum HTTP version of the distribution."
  value       = var.http_version
}

output "ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  value       = aws_cloudfront_distribution.this.is_ipv6_enabled
}

output "waf_web_acl" {
  description = "The ARN of a web ACL on WAFv2 to associate with this distribution."
  value       = aws_cloudfront_distribution.this.web_acl_id
}

output "zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "domain" {
  description = "The domain name corresponding to the distribution. For example: `d604721fxaaqy9.cloudfront.net`."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "root_object" {
  description = "The object (file name) to return when a viewer requests the root URL(/)."
  value       = aws_cloudfront_distribution.this.default_root_object
}

output "error_responses" {
  description = "The configuration of custom error responses for the distribution."
  value = {
    for response in aws_cloudfront_distribution.this.custom_error_response :
    response.error_code => {
      cache_min_ttl = response.error_caching_min_ttl

      custom_response_code = response.response_code
      custom_response_path = response.response_page_path
    }
  }
}

output "restriction" {
  description = <<EOF
  The restriction configuration for the distribution.
    `type` - The method to restrict distribution of the content by country.
    `locations` - A list of the ISO 3166-1-alpha-2 codes of countries to distribute or not distribute the content.
  EOF
  value = {
    type      = upper(aws_cloudfront_distribution.this.restrictions[0].geo_restriction[0].restriction_type)
    locations = aws_cloudfront_distribution.this.restrictions[0].geo_restriction[0].locations
  }
}

# TODO: update description
output "ssl" {
  description = <<EOF
  The SSL/TLS configuration for the distribution.
    `certificate_provider` - The provider of SSL certificate for the distribution.
  EOF
  value = {
    certificate_provider = var.ssl_certificate_provider
    certificate = {
      "CLOUDFRONT" = null
      "ACM"        = aws_cloudfront_distribution.this.viewer_certificate[0].acm_certificate_arn
      "IAM"        = aws_cloudfront_distribution.this.viewer_certificate[0].iam_certificate_id
    }[var.ssl_certificate_provider]

    security_policy = aws_cloudfront_distribution.this.viewer_certificate[0].minimum_protocol_version
    support_method  = var.ssl_support_method
  }
}

output "origin_access_identity" {
  description = <<EOF
  The information for the origin access identity of the distribution.
  EOF
  value = {
    id   = aws_cloudfront_origin_access_identity.this.id
    name = aws_cloudfront_origin_access_identity.this.comment

    cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    iam_arn                         = aws_cloudfront_origin_access_identity.this.iam_arn
    s3_canonical_user_id            = aws_cloudfront_origin_access_identity.this.s3_canonical_user_id
  }
}

output "origins" {
  description = <<EOF
  The configuration for origins of the distribution.
  EOF
  value = {
    for origin in aws_cloudfront_distribution.this.origin :
    origin.origin_id => {
      id = origin.origin_id

      host = origin.domain_name
      path = origin.origin_path

      custom_headers = {
        for item in origin.custom_header :
        item.name => item.value
      }
      origin_shield = one(origin.origin_shield[*])
    }
  }
}

output "origin_groups" {
  description = <<EOF
  The configuration for origin groups of the distribution.
  EOF
  value = {
    for group in aws_cloudfront_distribution.this.origin_group :
    group.origin_id => {
      id = group.origin_id

      primary_origin        = group.member[0].origin_id
      secondary_origin      = group.member[1].origin_id
      failover_status_codes = group.failover_criteria[0].status_codes
    }
  }
}

output "default_behavior" {
  description = <<EOF
  The configuration for the default behavior of the distribution.
  EOF
  value = {
    target_origin = aws_cloudfront_distribution.this.default_cache_behavior[0].target_origin_id

    compression_enabled      = aws_cloudfront_distribution.this.default_cache_behavior[0].compress
    smooth_streaming_enabled = aws_cloudfront_distribution.this.default_cache_behavior[0].smooth_streaming

    field_level_encryption_configuration = aws_cloudfront_distribution.this.default_cache_behavior[0].field_level_encryption_id
    realtime_log_configuration           = aws_cloudfront_distribution.this.default_cache_behavior[0].realtime_log_config_arn

    viewer_protocol_policy = {
      for k, v in local.viewer_protocol_policy :
      v => k
    }[aws_cloudfront_distribution.this.default_cache_behavior[0].viewer_protocol_policy]
    allowed_http_methods = aws_cloudfront_distribution.this.default_cache_behavior[0].allowed_methods
    cached_http_methods  = aws_cloudfront_distribution.this.default_cache_behavior[0].cached_methods

    cache_policy            = aws_cloudfront_distribution.this.default_cache_behavior[0].cache_policy_id
    origin_request_policy   = aws_cloudfront_distribution.this.default_cache_behavior[0].origin_request_policy_id
    response_headers_policy = aws_cloudfront_distribution.this.default_cache_behavior[0].response_headers_policy_id

    function_associations = var.default_function_associations

    cache_ttl = (var.default_cache_policy == null
      ? {
        min     = aws_cloudfront_distribution.this.default_cache_behavior[0].min_ttl
        default = aws_cloudfront_distribution.this.default_cache_behavior[0].default_ttl
        max     = aws_cloudfront_distribution.this.default_cache_behavior[0].max_ttl
      }
      : null
    )
  }
}

output "ordered_behaviors" {
  description = <<EOF
  The configuration for ordered behaviors of the distribution.
  EOF
  value = [
    for idx, behavior in aws_cloudfront_distribution.this.ordered_cache_behavior : {
      path_pattern  = behavior.path_pattern
      target_origin = behavior.target_origin_id

      compression_enabled      = behavior.compress
      smooth_streaming_enabled = behavior.smooth_streaming

      field_level_encryption_configuration = behavior.field_level_encryption_id
      realtime_log_configuration           = behavior.realtime_log_config_arn

      viewer_protocol_policy = {
        for k, v in local.viewer_protocol_policy :
        v => k
      }[behavior.viewer_protocol_policy]
      allowed_http_methods = behavior.allowed_methods
      cached_http_methods  = behavior.cached_methods

      cache_policy            = behavior.cache_policy_id
      origin_request_policy   = behavior.origin_request_policy_id
      response_headers_policy = behavior.response_headers_policy_id

      function_associations = try(var.ordered_behaviors[idx].function_associations, {})

      cache_ttl = (var.ordered_behaviors[idx].cache_policy == null
        ? {
          min     = behavior.min_ttl
          default = behavior.default_ttl
          max     = behavior.min_ttl
        }
        : null
      )
    }
  ]
}

output "logging" {
  description = <<EOF
  The logging configuration for the distribution.
    `s3` - The configuration to delivery access logs to S3 for the distribution.
  EOF
  value = {
    s3 = {
      enabled = var.logging_s3_enabled
      bucket  = try(aws_cloudfront_distribution.this.logging_config[0].bucket, null)
      prefix  = try(aws_cloudfront_distribution.this.logging_config[0].prefix, null)
    }
  }
}

output "monitoring" {
  description = <<EOF
  The monitoring configuration for the distribution.
    `realtime_metrics_enabled` - Whether to enable additional real-time metrics for the distribution.
  EOF
  value = {
    realtime_metrics_enabled = var.monitoring_realtime_metrics_enabled
  }
}

## TODO: implement
# output "trusted_key_groups" {
#   description = "test"
#   value       = aws_cloudfront_distribution.this.trusted_key_groups
# }
#
# output "zzzz" {
#   description = "The list of log streams for the log group."
#   value = {
#     default_cache_behavior = {
#       for k, v in one(aws_cloudfront_distribution.this.default_cache_behavior[*]) :
#       k => v
#       if !contains(["target_origin_id", "cached_methods", "path_pattern", "compress", "allowed_methods", "viewer_protocol_policy", "smooth_streaming", "cache_policy_id", "origin_request_policy_id", "response_headers_policy_id", "default_ttl", "min_ttl", "max_ttl", "function_association", "lambda_function_association", "field_level_encryption_id", "realtime_log_config_arn"], k)
#     }
#     ordered_cache_behaviors = [
#       for behavior in aws_cloudfront_distribution.this.ordered_cache_behavior[*] : {
#         for k, v in behavior :
#         k => v
#         if !contains(["target_origin_id", "cached_methods", "path_pattern", "compress", "allowed_methods", "viewer_protocol_policy", "smooth_streaming", "cache_policy_id", "origin_request_policy_id", "response_headers_policy_id", "default_ttl", "min_ttl", "max_ttl", "function_association", "lambda_function_association", "field_level_encryption_id", "realtime_log_config_arn"], k)
#       }
#     ]
#   }
# }

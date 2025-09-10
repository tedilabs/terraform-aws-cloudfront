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

output "domain" {
  description = <<EOF
  The domain configuration for the distribution.
    `name` - The domain name corresponding to the distribution. For example: `d604721fxaaqy9.cloudfront.net`.
    `hosted_zone` - The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to.
    `aliases` - A list of CNAME aliases for the distribution.
  EOF
  value = {
    name        = aws_cloudfront_distribution.this.domain_name
    hosted_zone = aws_cloudfront_distribution.this.hosted_zone_id

    aliases = aws_cloudfront_distribution.this.aliases
  }
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

      custom_response = (response.response_code != null
        ? {
          status_code = response.response_code
          path        = response.response_page_path
        }
        : null
      )
    }
  }
}

output "is_staging" {
  description = "Whether the distribution is a staging distribution."
  value       = aws_cloudfront_distribution.this.staging
}

output "continuous_deployment_policy" {
  description = "The ID of a continuous deployment policy."
  value       = aws_cloudfront_distribution.this.continuous_deployment_policy_id
}

output "geographic_restriction" {
  description = <<EOF
  The configuration for CloudFront geographic restrictions.
    `type` - The method to restrict distribution of the content by country.
    `countries` - A list of the ISO 3166-1-alpha-2 codes of countries to distribute or not distribute the content.
  EOF
  value = {
    type      = upper(aws_cloudfront_distribution.this.restrictions[0].geo_restriction[0].restriction_type)
    countries = aws_cloudfront_distribution.this.restrictions[0].geo_restriction[0].locations
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

      origin_access = {
        type = (origin.origin_access_control_id != null
          ? "CONTROL"
          : (length(origin.s3_origin_config) > 0
            ? "IDENTITY"
            : "NONE"
          )
        )
        id = (origin.origin_access_control_id != null
          ? origin.origin_access_control_id
          : (length(origin.s3_origin_config) > 0
            ? origin.s3_origin_config[0].origin_access_identity
            : null
          )
        )
      }
      custom_headers = {
        for item in origin.custom_header :
        item.name => item.value
      }
      origin_shield = one(origin.origin_shield[*])

      connection_attempts = origin.connection_attempts
      connection_timeout  = origin.connection_timeout
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

    legacy_cache_config = (var.default_behavior.legacy_cache_config.enabled
      ? {
        min_ttl     = aws_cloudfront_distribution.this.default_cache_behavior[0].min_ttl
        default_ttl = aws_cloudfront_distribution.this.default_cache_behavior[0].default_ttl
        max_ttl     = aws_cloudfront_distribution.this.default_cache_behavior[0].max_ttl

        forwarding_cookies       = var.default_behavior.legacy_cache_config.forwarding_cookies
        forwarding_headers       = var.default_behavior.legacy_cache_config.forwarding_headers
        forwarding_query_strings = var.default_behavior.legacy_cache_config.forwarding_query_strings
      }
      : null
    )

    function_associations = var.default_behavior.function_associations
  }
}

output "ordered_behaviors" {
  description = <<EOF
  The configuration for ordered behaviors of the distribution.
  EOF
  value = [
    for behavior in var.ordered_behaviors :
    merge(behavior, {
      legacy_cache_config = (behavior.legacy_cache_config.enabled
        ? behavior.legacy_cache_config
        : null
      )
    })
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

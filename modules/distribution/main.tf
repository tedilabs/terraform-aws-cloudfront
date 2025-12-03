locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

locals {
  price_class = {
    "ALL" = "PriceClass_All"
    "200" = "PriceClass_200"
    "100" = "PriceClass_100"
  }
  http_version = {
    "HTTP1.1"   = "http1.1"
    "HTTP2"     = "http2"
    "HTTP2AND3" = "http2and3"
    "HTTP3"     = "http3"
  }
  ssl_support_method = {
    "VIP"       = "vip"
    "SNI_ONLY"  = "sni-only"
    "STATIC_IP" = "static-ip"
  }
  origin_protocol_policy = {
    "HTTP_ONLY"    = "http-only"
    "HTTPS_ONLY"   = "https-only"
    "MATCH_VIEWER" = "match-viewer"
  }
  origin_ssl_security_policy = {
    "SSLv3"   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    "TLSv1"   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    "TLSv1.1" = ["TLSv1.1", "TLSv1.2"]
    "TLSv1.2" = ["TLSv1.2"]
  }
  viewer_protocol_policy = {
    "ALLOW_ALL"         = "allow-all"
    "HTTPS_ONLY"        = "https-only"
    "REDIRECT_TO_HTTPS" = "redirect-to-https"
  }
  cloudfront_events = {
    "VIEWER_REQUEST"  = "viewer-request"
    "ORIGIN_REQUEST"  = "origin-request"
    "ORIGIN_RESPONSE" = "origin-response"
    "VIEWER_RESPONSE" = "viewer-response"
  }
}


###################################################
# CloudFront Distribution
###################################################

# INFO: Not supported attributes
# - `default_cache_behavior.trusted_signers`
# - `ordered_cache_behavior.trusted_signers`
# INFO: Deprecated attributes
# - `default_cache_behavior.forwarded_values`
# - `default_cache_behavior.min_ttl`
# - `default_cache_behavior.default_ttl`
# - `default_cache_behavior.max_ttl`
# - `ordered_cache_behavior.forwarded_values`
# - `ordered_cache_behavior.min_ttl`
# - `ordered_cache_behavior.default_ttl`
# - `ordered_cache_behavior.max_ttl`
# TODO
# - `default_cache_behavior.trusted_key_groups`
# - `ordered_cache_behavior.trusted_key_groups`
resource "aws_cloudfront_distribution" "this" {
  aliases = var.aliases
  comment = var.description
  enabled = var.enabled

  retain_on_delete    = var.retain_on_deletion_enabled
  wait_for_deployment = var.wait_for_deployment_enabled

  price_class     = local.price_class[var.price_class]
  http_version    = local.http_version[var.http_version]
  is_ipv6_enabled = var.ipv6_enabled

  anycast_ip_list_id = var.anycast_static_ip_list
  web_acl_id         = var.waf_web_acl


  ## Deployment
  staging                         = var.is_staging
  continuous_deployment_policy_id = var.continuous_deployment_policy


  ## Default Pages
  default_root_object = var.root_object

  dynamic "custom_error_response" {
    for_each = var.error_responses
    iterator = response

    content {
      error_code            = response.key
      error_caching_min_ttl = response.value.cache_min_ttl

      response_code = (response.value.custom_response != null
        ? response.value.custom_response.status_code
        : null
      )
      response_page_path = (response.value.custom_response != null
        ? response.value.custom_response.path
        : null
      )
    }
  }


  ## Geographic Restriction
  restrictions {
    geo_restriction {
      restriction_type = lower(var.geographic_restriction.type)
      locations        = var.geographic_restriction.countries
    }
  }


  ## SSL / TLS
  viewer_certificate {
    cloudfront_default_certificate = var.ssl_certificate_provider == "CLOUDFRONT"
    acm_certificate_arn            = var.ssl_certificate_provider == "ACM" ? var.ssl_certificate : null
    iam_certificate_id             = var.ssl_certificate_provider == "IAM" ? var.ssl_certificate : null

    minimum_protocol_version = var.ssl_security_policy
    ssl_support_method       = local.ssl_support_method[var.ssl_support_method]
  }


  ## Origins
  # S3 Origins
  dynamic "origin" {
    for_each = var.s3_origins
    iterator = s3

    content {
      origin_id   = s3.key
      domain_name = s3.value.host
      origin_path = s3.value.path

      origin_access_control_id = (s3.value.origin_access.type == "CONTROL"
        ? s3.value.origin_access.id
        : null
      )

      connection_attempts         = s3.value.connection_attempts
      connection_timeout          = s3.value.connection_timeout
      response_completion_timeout = s3.value.response_completion_timeout

      dynamic "custom_header" {
        for_each = s3.value.custom_headers

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "origin_shield" {
        for_each = s3.value.origin_shield != null ? [s3.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.region
        }
      }

      dynamic "s3_origin_config" {
        for_each = s3.value.origin_access.type == "IDENTITY" ? ["go"] : []

        content {
          origin_access_identity = s3.value.origin_access.id
        }
      }
    }
  }

  # VPC Origins
  dynamic "origin" {
    for_each = var.vpc_origins
    iterator = vpc

    content {
      origin_id   = vpc.key
      domain_name = vpc.value.host
      origin_path = vpc.value.path

      connection_attempts         = vpc.value.connection_attempts
      connection_timeout          = vpc.value.connection_timeout
      response_completion_timeout = vpc.value.response_completion_timeout

      dynamic "custom_header" {
        for_each = vpc.value.custom_headers

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "origin_shield" {
        for_each = vpc.value.origin_shield != null ? [vpc.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.region
        }
      }

      vpc_origin_config {
        vpc_origin_id = vpc.value.vpc_origin

        origin_keepalive_timeout = vpc.value.keepalive_timeout
        origin_read_timeout      = vpc.value.response_timeout
      }
    }
  }

  # Custom Origins
  dynamic "origin" {
    for_each = var.custom_origins
    iterator = custom

    content {
      origin_id   = custom.key
      domain_name = custom.value.host
      origin_path = custom.value.path

      origin_access_control_id = (custom.value.origin_access.type == "CONTROL"
        ? custom.value.origin_access.id
        : null
      )

      connection_attempts         = custom.value.connection_attempts
      connection_timeout          = custom.value.connection_timeout
      response_completion_timeout = custom.value.response_completion_timeout

      dynamic "custom_header" {
        for_each = custom.value.custom_headers

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "origin_shield" {
        for_each = custom.value.origin_shield != null ? [custom.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.region
        }
      }

      custom_origin_config {
        http_port       = custom.value.http_port
        https_port      = custom.value.https_port
        ip_address_type = lower(custom.value.ip_address_type)

        origin_protocol_policy = local.origin_protocol_policy[custom.value.protocol_policy]
        origin_ssl_protocols   = local.origin_ssl_security_policy[custom.value.ssl_security_policy]

        origin_keepalive_timeout = custom.value.keepalive_timeout
        origin_read_timeout      = custom.value.response_timeout
      }
    }
  }

  # Origin Groups
  dynamic "origin_group" {
    for_each = var.origin_groups

    content {
      origin_id = origin_group.key

      member {
        origin_id = origin_group.value.primary_origin
      }

      member {
        origin_id = origin_group.value.secondary_origin
      }

      failover_criteria {
        status_codes = origin_group.value.failover_status_codes
      }
    }
  }


  ## Default Behavior
  default_cache_behavior {
    target_origin_id = var.default_behavior.target_origin

    compress         = var.default_behavior.compression_enabled
    smooth_streaming = var.default_behavior.smooth_streaming_enabled

    field_level_encryption_id = (var.default_behavior.viewer_protocol_policy == "HTTPS_ONLY" && contains(var.default_behavior.allowed_http_methods, "POST") && contains(var.default_behavior.allowed_http_methods, "PUT")
      ? var.default_behavior.field_level_encryption_configuration
      : null
    )
    realtime_log_config_arn = var.default_behavior.realtime_log_configuration

    # Viewer
    viewer_protocol_policy = local.viewer_protocol_policy[var.default_behavior.viewer_protocol_policy]
    allowed_methods        = var.default_behavior.allowed_http_methods
    cached_methods         = var.default_behavior.cached_http_methods

    dynamic "grpc_config" {
      for_each = var.default_behavior.grpc_enabled ? ["go"] : []

      content {
        enabled = var.default_behavior.grpc_enabled
      }
    }

    # Policies
    cache_policy_id            = var.default_behavior.cache_policy
    origin_request_policy_id   = var.default_behavior.origin_request_policy
    response_headers_policy_id = var.default_behavior.response_headers_policy

    # Function Associations
    dynamic "lambda_function_association" {
      for_each = {
        for event, f in var.default_behavior.function_associations :
        event => f
        if contains(keys(local.cloudfront_events), event) && f.type == "LAMBDA_EDGE"
      }
      iterator = lambda

      content {
        event_type = local.cloudfront_events[lambda.key]
        lambda_arn = lambda.value.function

        include_body = lambda.value.include_body
      }
    }
    dynamic "function_association" {
      for_each = {
        for event, f in var.default_behavior.function_associations :
        event => f
        if contains(["VIEWER_REQUEST", "VIEWER_RESPONSE"], event) && f.type == "CLOUDFRONT"
      }
      iterator = function

      content {
        event_type   = local.cloudfront_events[function.key]
        function_arn = function.value.function
      }
    }

    # Cache Key & Origin Requests (Legacy)
    min_ttl = (var.default_behavior.legacy_cache_config.enabled
      ? var.default_behavior.legacy_cache_config.min_ttl
      : null
    )
    default_ttl = (var.default_behavior.legacy_cache_config.enabled
      ? var.default_behavior.legacy_cache_config.default_ttl
      : null
    )
    max_ttl = (var.default_behavior.legacy_cache_config.enabled
      ? var.default_behavior.legacy_cache_config.max_ttl
      : null
    )

    dynamic "forwarded_values" {
      for_each = var.default_behavior.legacy_cache_config.enabled ? [var.default_behavior.legacy_cache_config] : []
      iterator = config

      content {
        cookies {
          forward           = lower(config.forwarding_cookies.behavior)
          whitelisted_names = config.value.forwarding_cookies.items
        }

        headers = (config.value.forwarding_query_strings.behavior == "ALL"
          ? ["*"]
          : config.value.forwarding_query_strings.items
        )

        query_string = contains(["ALL", "WHITELIST"], config.value.forwarding_query_strings.behavior)
        query_string_cache_keys = (config.value.forwarding_query_strings.behavior == "ALL"
          ? null
          : config.value.forwarding_query_strings.items
        )
      }
    }
  }


  ## Ordered Behaviors
  dynamic "ordered_cache_behavior" {
    for_each = flatten([
      for behavior in var.ordered_behaviors : [
        for pattern in behavior.path_patterns :
        merge(behavior, {
          path_pattern = pattern
        })
      ]
    ])
    iterator = behavior

    content {
      path_pattern     = behavior.value.path_pattern
      target_origin_id = behavior.value.target_origin

      compress         = behavior.value.compression_enabled
      smooth_streaming = behavior.value.smooth_streaming_enabled

      field_level_encryption_id = (behavior.value.viewer_protocol_policy == "HTTPS_ONLY" && contains(behavior.value.allowed_http_methods, "POST") && contains(behavior.value.allowed_http_methods, "PUT")
        ? behavior.value.field_level_encryption_configuration
        : null
      )
      realtime_log_config_arn = behavior.value.realtime_log_configuration

      # Viewer
      viewer_protocol_policy = local.viewer_protocol_policy[behavior.value.viewer_protocol_policy]
      allowed_methods        = behavior.value.allowed_http_methods
      cached_methods         = behavior.value.cached_http_methods

      dynamic "grpc_config" {
        for_each = behavior.value.grpc_enabled ? ["go"] : []

        content {
          enabled = behavior.value.grpc_enabled
        }
      }

      # Policies
      cache_policy_id            = behavior.value.cache_policy
      origin_request_policy_id   = behavior.value.origin_request_policy
      response_headers_policy_id = behavior.value.response_headers_policy

      # Function Associations
      dynamic "lambda_function_association" {
        for_each = {
          for event, f in behavior.value.function_associations :
          event => f
          if contains(keys(local.cloudfront_events), event) && f.type == "LAMBDA_EDGE"
        }
        iterator = lambda

        content {
          event_type = local.cloudfront_events[lambda.key]
          lambda_arn = lambda.value.function

          include_body = lambda.value.include_body
        }
      }
      dynamic "function_association" {
        for_each = {
          for event, f in behavior.value.function_associations :
          event => f
          if contains(["VIEWER_REQUEST", "VIEWER_RESPONSE"], event) && f.type == "CLOUDFRONT"
        }
        iterator = function

        content {
          event_type   = local.cloudfront_events[function.key]
          function_arn = function.value.function
        }
      }

      # Cache Key & Origin Requests (Legacy)
      min_ttl = (behavior.value.legacy_cache_config.enabled
        ? behavior.legacy_cache_config.min_ttl
        : null
      )
      default_ttl = (behavior.value.legacy_cache_config.enabled
        ? behavior.legacy_cache_config.default_ttl
        : null
      )
      max_ttl = (behavior.value.legacy_cache_config.enabled
        ? behavior.legacy_cache_config.max_ttl
        : null
      )

      dynamic "forwarded_values" {
        for_each = behavior.value.legacy_cache_config.enabled ? [behavior.value.legacy_cache_config] : []
        iterator = config

        content {
          cookies {
            forward           = lower(config.forwarding_cookies.behavior)
            whitelisted_names = config.value.forwarding_cookies.items
          }

          headers = (config.value.forwarding_query_strings.behavior == "ALL"
            ? ["*"]
            : config.value.forwarding_query_strings.items
          )

          query_string = contains(["ALL", "WHITELIST"], config.value.forwarding_query_strings.behavior)
          query_string_cache_keys = (config.value.forwarding_query_strings.behavior == "ALL"
            ? null
            : config.value.forwarding_query_strings.items
          )
        }
      }
    }
  }


  ## Logging
  dynamic "logging_config" {
    for_each = var.logging_s3_enabled ? ["go"] : []

    content {
      bucket = var.logging_s3_bucket
      prefix = var.logging_s3_prefix

      include_cookies = var.logging_include_cookies
    }
  }


  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )

  lifecycle {
    precondition {
      condition     = (length(keys(var.s3_origins)) > 0) || (length(keys(var.custom_origins)) > 0)
      error_message = "One or more origin should be defined."
    }
  }
}

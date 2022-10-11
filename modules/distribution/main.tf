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
# Origin Access Identity for CloudFront Distribution
###################################################

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = var.name
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

  price_class     = local.price_class[var.price_class]
  http_version    = local.http_version[var.http_version]
  is_ipv6_enabled = var.ipv6_enabled
  web_acl_id      = var.waf_web_acl

  retain_on_delete    = var.retain_on_deletion_enabled
  wait_for_deployment = var.wait_for_deployment_enabled


  ## Default Pages
  default_root_object = var.root_object

  dynamic "custom_error_response" {
    for_each = var.error_responses

    content {
      error_code            = custom_error_response.key
      error_caching_min_ttl = try(custom_error_response.value.cache_min_ttl, 10)

      response_code      = try(custom_error_response.value.custom_response_code, null)
      response_page_path = try(custom_error_response.value.custom_response_path, null)
    }
  }


  ## Restriction
  restrictions {
    geo_restriction {
      restriction_type = lower(var.restriction_type)
      locations        = var.restriction_locations
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
      origin_path = try(s3.value.path, null)

      connection_attempts = try(s3.value.connection_attempts, null)
      connection_timeout  = try(s3.value.connection_timeout, null)

      dynamic "custom_header" {
        for_each = try(s3.value.custom_headers, {})

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "origin_shield" {
        for_each = try(s3.value.origin_shield.enabled, false) ? [s3.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.region
        }
      }

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
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
      origin_path = try(custom.value.path, null)

      connection_attempts = try(custom.value.connection_attempts, null)
      connection_timeout  = try(custom.value.connection_timeout, null)

      dynamic "custom_header" {
        for_each = try(custom.value.custom_headers, {})

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "origin_shield" {
        for_each = try(custom.value.origin_shield.enabled, false) ? [custom.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.region
        }
      }

      custom_origin_config {
        http_port  = try(custom.value.http_port, 80)
        https_port = try(custom.value.https_port, 443)
        origin_protocol_policy = try(
          local.origin_protocol_policy[custom.value.protocol_policy],
          local.origin_protocol_policy["MATCH_VIEWER"]
        )
        origin_ssl_protocols = try(
          local.origin_ssl_security_policy[custom.value.ssl_security_policy],
          local.origin_ssl_security_policy["TLSv1.1"]
        )

        origin_keepalive_timeout = try(custom.value.keepalive_timeout, null)
        origin_read_timeout      = try(custom.value.response_timeout, null)
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
    target_origin_id = var.default_target_origin

    compress         = var.default_compression_enabled
    smooth_streaming = var.default_smooth_streaming_enabled

    field_level_encryption_id = (var.default_viewer_protocol_policy == "HTTPS_ONLY" && contains(var.default_allowed_http_methods, "POST") && contains(var.default_allowed_http_methods, "PUT")
      ? var.default_field_level_encryption_configuration
      : null
    )
    realtime_log_config_arn = var.default_realtime_log_configuration

    # Viewer
    viewer_protocol_policy = local.viewer_protocol_policy[var.default_viewer_protocol_policy]
    allowed_methods        = var.default_allowed_http_methods
    cached_methods         = var.default_cached_http_methods

    # Policies
    cache_policy_id            = var.default_cache_policy
    origin_request_policy_id   = var.default_origin_request_policy
    response_headers_policy_id = var.default_response_headers_policy

    # Function Associations
    dynamic "lambda_function_association" {
      for_each = {
        for event, f in try(var.default_function_associations, {}) :
        event => f
        if contains(keys(local.cloudfront_events), event) && f.type == "LAMBDA_EDGE"
      }
      iterator = lambda

      content {
        event_type = local.cloudfront_events[lambda.key]
        lambda_arn = lambda.value.function

        include_body = try(lambda.value.include_body, false)
      }
    }
    dynamic "function_association" {
      for_each = {
        for event, f in try(var.default_function_associations, {}) :
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
    min_ttl = (var.default_cache_policy == null
      ? try(var.default_cache_ttl.min, 0)
      : null
    )
    default_ttl = (var.default_cache_policy == null
      ? try(var.default_cache_ttl.default, 0)
      : null
    )
    max_ttl = (var.default_cache_policy == null
      ? try(var.default_cache_ttl.max, 0)
      : null
    )

    dynamic "forwarded_values" {
      for_each = var.default_cache_policy == null ? ["go"] : []

      content {
        headers      = []
        query_string = true

        cookies {
          forward           = "none"
          whitelisted_names = []
        }
      }
    }
  }


  ## Ordered Behaviors
  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_behaviors
    iterator = behavior

    content {
      path_pattern     = behavior.value.path_pattern
      target_origin_id = behavior.value.target_origin

      compress         = try(behavior.value.compression_enabled, true)
      smooth_streaming = try(behavior.value.smooth_streaming_enabled, false)

      # Viewer
      viewer_protocol_policy = try(
        local.viewer_protocol_policy[behavior.value.viewer_protocol_policy],
        local.viewer_protocol_policy["REDIRECT_TO_HTTPS"],
      )
      allowed_methods = try(
        toset(behavior.value.allowed_http_methods),
        toset(["GET", "HEAD"])
      )
      cached_methods = try(
        toset(behavior.value.cached_http_methods),
        toset(["GET", "HEAD"])
      )

      # Policies
      cache_policy_id            = try(behavior.value.cache_policy, null)
      origin_request_policy_id   = try(behavior.value.origin_request_policy, null)
      response_headers_policy_id = try(behavior.value.response_headers_policy, null)

      # Function Associations
      dynamic "lambda_function_association" {
        for_each = {
          for event, f in try(behavior.value.function_associations, {}) :
          event => f
          if contains(keys(local.cloudfront_events), event) && f.type == "LAMBDA_EDGE"
        }
        iterator = lambda

        content {
          event_type = local.cloudfront_events[lambda.key]
          lambda_arn = lambda.value.function

          include_body = try(lambda.value.include_body, false)
        }
      }
      dynamic "function_association" {
        for_each = {
          for event, f in try(behavior.value.function_associations, {}) :
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
      min_ttl = (behavior.value.cache_policy == null
        ? try(behavior.cache_ttl.min, 0)
        : null
      )
      default_ttl = (behavior.value.cache_policy == null
        ? try(behavior.cache_ttl.default, 0)
        : null
      )
      max_ttl = (behavior.value.cache_policy == null
        ? try(behavior.cache_ttl.max, 0)
        : null
      )

      dynamic "forwarded_values" {
        for_each = behavior.value.cache_policy == null ? ["go"] : []

        content {
          headers      = []
          query_string = true

          cookies {
            forward           = "none"
            whitelisted_names = []
          }
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

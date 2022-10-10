locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
}


###################################################
# Response Headers Policy for CloudFront Distribution
###################################################

resource "aws_cloudfront_response_headers_policy" "this" {
  name    = var.name
  comment = var.description

  dynamic "cors_config" {
    for_each = var.cors.enabled ? [var.cors] : []
    iterator = cors

    content {
      origin_override = cors.value.override

      access_control_allow_credentials = cors.value.access_control_allow_credentials

      access_control_allow_headers {
        items = cors.value.access_control_allow_headers
      }
      access_control_allow_methods {
        items = cors.value.access_control_allow_methods
      }
      access_control_allow_origins {
        items = cors.value.access_control_allow_origins
      }
      dynamic "access_control_expose_headers" {
        for_each = length(cors.value.access_control_expose_headers) > 0 ? [cors.value.access_control_expose_headers] : []

        content {
          items = access_control_expose_headers.value
        }
      }
      access_control_max_age_sec = cors.value.access_control_max_age
    }
  }

  custom_headers_config {
    dynamic "items" {
      for_each = var.custom_headers

      content {
        header   = items.value.name
        value    = items.value.value
        override = items.value.override
      }
    }
  }

  # security_headers_config {
  # }

  server_timing_headers_config {
    enabled       = var.server_timing_header.enabled
    sampling_rate = var.server_timing_header.sampling_rate
  }
}

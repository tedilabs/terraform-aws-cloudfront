locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
}

locals {
  behaviors = {
    "NONE"                                = "none"
    "WHITELIST"                           = "whitelist"
    "BLACKLIST"                           = "allExcept"
    "ALL"                                 = "all"
    "ALL_VIEWER"                          = "allViewer"
    "ALL_VIEWER_AND_CLOUDFRONT_WHITELIST" = "allViewerAndWhitelistCloudFront"
  }
}


###################################################
# Origin Request Policy for CloudFront Distribution
###################################################

resource "aws_cloudfront_origin_request_policy" "this" {
  name    = var.name
  comment = var.description

  cookies_config {
    cookie_behavior = local.behaviors[var.forwarding_cookies.behavior]

    dynamic "cookies" {
      for_each = contains(["WHITELIST"], var.forwarding_cookies.behavior) ? [var.forwarding_cookies] : []

      content {
        items = cookies.value.items
      }
    }
  }
  headers_config {
    header_behavior = local.behaviors[var.forwarding_headers.behavior]

    dynamic "headers" {
      for_each = contains(["WHITELIST", "ALL_VIEWER_AND_CLOUDFRONT_WHITELIST"], var.forwarding_headers.behavior) ? [var.forwarding_headers] : []

      content {
        items = headers.value.items
      }
    }
  }
  query_strings_config {
    query_string_behavior = local.behaviors[var.forwarding_query_strings.behavior]

    dynamic "query_strings" {
      for_each = contains(["WHITELIST"], var.forwarding_query_strings.behavior) ? [var.forwarding_query_strings] : []

      content {
        items = query_strings.value.items
      }
    }
  }
}

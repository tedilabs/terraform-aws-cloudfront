provider "aws" {
  region = "us-east-1"
}


###################################################
# CloudFront Policies
###################################################

module "cache_policy" {
  source = "../../modules/cache-policy"
  # source  = "tedilabs/cloudfront/aws//modules/cache-policy"
  # version = "~> 0.2.0"

  name        = "example-cache-policy"
  description = "Managed by Terraform."

  default_ttl = 60 * 60 * 24
  min_ttl     = 10
  max_ttl     = 60 * 60 * 24 * 3

  supported_compression_formats = ["BROTLI", "GZIP"]

  cache_keys_in_cookies = {
    behavior = "NONE"
  }
  cache_keys_in_headers = {
    behavior = "WHITELIST"
    items    = ["X-User-Id"]
  }
  cache_keys_in_query_strings = {
    behavior = "ALL"
  }
}

module "origin_request_policy" {
  source = "../../modules/origin-request-policy"
  # source  = "tedilabs/cloudfront/aws//modules/origin-request-policy"
  # version = "~> 0.2.0"

  name        = "example-origin-request-policy"
  description = "Managed by Terraform."

  forwarding_cookies = {
    behavior = "NONE"
  }
  forwarding_headers = {
    behavior = "ALL_VIEWER_AND_CLOUDFRONT_WHITELIST"
    items    = ["CloudFront-Viewer-Country-Name"]
  }
  forwarding_query_strings = {
    behavior = "ALL"
  }
}

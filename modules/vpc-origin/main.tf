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
  protocol_policy = {
    "HTTP_ONLY"    = "http-only"
    "HTTPS_ONLY"   = "https-only"
    "MATCH_VIEWER" = "match-viewer"
  }
  ssl_security_policy = {
    "SSLv3"   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    "TLSv1"   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    "TLSv1.1" = ["TLSv1.1", "TLSv1.2"]
    "TLSv1.2" = ["TLSv1.2"]
  }
}


###################################################
# VPC Origin for CloudFront Distribution
###################################################

resource "aws_cloudfront_vpc_origin" "this" {
  vpc_origin_endpoint_config {
    name = var.name
    arn  = var.endpoint

    origin_protocol_policy = local.protocol_policy[var.protocol_policy]
    http_port = (contains(["HTTP_ONLY", "MATCH_VIEWER"], var.protocol_policy)
      ? var.http_port
      : null
    )
    https_port = (contains(["HTTPS_ONLY", "MATCH_VIEWER"], var.protocol_policy)
      ? var.https_port
      : null
    )

    origin_ssl_protocols {
      items    = local.ssl_security_policy[var.ssl_security_policy]
      quantity = length(local.ssl_security_policy[var.ssl_security_policy])
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

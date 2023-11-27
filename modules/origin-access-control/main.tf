locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
}

locals {
  signing_behaviors = {
    "ALWAYS"      = "always"
    "NEVER"       = "never"
    "NO_OVERRIDE" = "no-override"
  }
}


###################################################
# Origin Access Control for CloudFront Distribution
###################################################

resource "aws_cloudfront_origin_access_control" "this" {
  name        = var.name
  description = var.description

  origin_access_control_origin_type = lower(var.origin_type)
  signing_behavior                  = local.signing_behaviors[var.signing_behavior]
  signing_protocol                  = "sigv4"
}

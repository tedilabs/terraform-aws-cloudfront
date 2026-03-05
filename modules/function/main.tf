locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = "${var.type}/${var.name}"
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# CloudFront Function
###################################################

resource "aws_cloudfront_function" "this" {
  count = var.type == "GENERAL" ? 1 : 0

  name    = var.name
  comment = var.description
  publish = var.publish

  runtime = var.runtime
  code    = var.code

  key_value_store_associations = (var.key_value_store != null
    ? [var.key_value_store]
    : null
  )
}


###################################################
# CloudFront Connection Function (CONNECTION)
###################################################

resource "aws_cloudfront_connection_function" "this" {
  count = var.type == "CONNECTION" ? 1 : 0

  name    = var.name
  publish = var.publish

  connection_function_code = var.code

  connection_function_config {
    comment = var.description

    runtime = var.runtime

    dynamic "key_value_store_association" {
      for_each = (var.key_value_store != null) ? ["go"] : []

      content {
        key_value_store_arn = var.key_value_store
      }
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

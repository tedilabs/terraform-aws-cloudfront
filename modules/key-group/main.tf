locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
}


###################################################
# CloudFront Key Group
###################################################

resource "aws_cloudfront_key_group" "this" {
  name    = var.name
  comment = var.description
  items   = values(aws_cloudfront_public_key.this)[*].id
}


###################################################
# Public Keys for CloudFront Key Group
###################################################

# INFO: Not supported attributes
# - `name_prefix`
resource "aws_cloudfront_public_key" "this" {
  for_each = {
    for key in var.public_keys :
    key.name => key
  }

  name        = each.key
  comment     = each.value.description
  encoded_key = each.value.public_key
}

locals {
  metadata = {
    package = "terraform-aws-cloudfront"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
}

locals {
  items = {
    for k, v in var.items :
    k => jsonencode(v)
  }
}


###################################################
# CloudFront Key-Value Store
###################################################

resource "aws_cloudfront_key_value_store" "this" {
  name    = var.name
  comment = var.description

  timeouts {
    create = var.timeouts.create
  }
}


###################################################
# CloudFront Key-Value Store Keys
###################################################

resource "aws_cloudfrontkeyvaluestore_key" "this" {
  for_each = var.exclusive ? {} : local.items

  key_value_store_arn = aws_cloudfront_key_value_store.this.arn

  key   = each.key
  value = each.value
}

resource "aws_cloudfrontkeyvaluestore_keys_exclusive" "this" {
  count = var.exclusive ? 1 : 0

  key_value_store_arn = aws_cloudfront_key_value_store.this.arn

  dynamic "resource_key_value_pair" {
    for_each = local.items
    iterator = item

    content {
      key   = item.key
      value = item.value
    }
  }
}

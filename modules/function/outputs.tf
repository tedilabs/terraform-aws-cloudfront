output "id" {
  description = "The ID of the CloudFront Function."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].name)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].id)
  }[var.type]
}

output "arn" {
  description = "The ARN of the CloudFront Function."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].arn)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].connection_function_arn)
  }[var.type]
}

output "name" {
  description = "The name of the CloudFront Function."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].name)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].name)
  }[var.type]
}

output "description" {
  description = "The comment describing the CloudFront function."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].comment)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].connection_function_config[0].comment)
  }[var.type]
}

output "type" {
  description = "The type of the CloudFront Function."
  value       = var.type
}

output "status" {
  description = "The status of the function. Can be UNPUBLISHED, UNASSOCIATED or ASSOCIATED."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].status)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].status)
  }[var.type]
}

output "runtime" {
  description = "The runtime environment for the function."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].runtime)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].connection_function_config[0].runtime)
  }[var.type]
}

output "key_value_store" {
  description = "The ARN of the CloudFront Key Value Store associated with the function, if any."
  value = try(
    one(aws_cloudfront_function.this[0].key_value_store_associations[*]),
    aws_cloudfront_connection_function.this[0].connection_function_config[0].key_value_store_association[0].key_value_store_arn,
    var.key_value_store,
  )
}

output "etag" {
  description = "The ETag hash of the function. This is the value for the DEVELOPMENT stage of the function."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].etag)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].etag)
  }[var.type]
}

output "live_stage_etag" {
  description = "The ETag hash of the LIVE stage of the function. Will be empty if the function has not been published."
  value = {
    "GENERAL"    = one(aws_cloudfront_function.this[*].live_stage_etag)
    "CONNECTION" = one(aws_cloudfront_connection_function.this[*].live_stage_etag)
  }[var.type]
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}

# output "debug" {
#   value = try(
#     {
#       for k, v in one(aws_cloudfront_function.this[*]) :
#       k => v
#       if !contains(["id", "arn", "name", "comment", "runtime", "etag", "live_stage_etag", "status", "publish", "code", "key_value_store_associations"], k)
#     },
#     {
#       for k, v in one(aws_cloudfront_connection_function.this[*]) :
#       k => v
#       if !contains(["id", "connection_function_arn", "name", "etag", "live_stage_etag", "status", "publish"], k)
#     }
#   )
# }

variable "name" {
  description = "(Required) A unique name to identify the CloudFront Origin Request Policy."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the origin request policy."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "forwarding_cookies" {
  description = <<EOF
  (Optional) A configuration for specifying which cookies in viewer requests to be forwarded in the origin requests. `forwarding_cookies` as defined below.
    (Required) `behavior` - Determine whether any cookies in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`. Defaults to `NONE`.
    (Optional) `items` - A list of cookie names. It only takes effect when `behavior` is `WHITELIST`.
  EOF
  type = object({
    behavior = optional(string, "NONE")
    items    = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "ALL"], var.forwarding_cookies.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST`, and `ALL`."
  }
}

variable "forwarding_headers" {
  description = <<EOF
  (Optional) A configuration for specifying which headers in viewer requests to be forwarded in the origin requests. `forwarding_headers` as defined below.
    (Required) `behavior` - Determine whether any headers in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL_VIEWER` and `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`. Defaults to `NONE`.
    (Optional) `items` - A list of header names. It only takes effect when `behavior` is `WHITELIST` or `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`.
  EOF
  type = object({
    behavior = optional(string, "NONE")
    items    = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "ALL_VIEWER", "ALL_VIEWER_AND_CLOUDFRONT_WHITELIST"], var.forwarding_headers.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST`, `ALL_VIEWER` and `ALL_VIEWER_AND_CLOUDFRONT_WHITELIST`."
  }
}

variable "forwarding_query_strings" {
  description = <<EOF
  (Optional) A configuration for specifying which query strings in viewer requests to be forwarded in the origin requests. `forwarding_query_strings` as defined below.
    (Required) `behavior` - Determine whether any query strings in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`. Defaults to `NONE`.
    (Optional) `items` - A list of query string names. It only takes effect when `behavior` is `WHITELIST`.
  EOF
  type = object({
    behavior = optional(string, "NONE")
    items    = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "ALL"], var.forwarding_query_strings.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST`, and `ALL`."
  }
}

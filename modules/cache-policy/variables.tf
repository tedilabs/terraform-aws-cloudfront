variable "name" {
  description = "(Required) A unique name to identify the CloudFront Cache Policy."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the cache policy."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "default_ttl" {
  description = "(Optional) The default time to live in seconds. The amount of time is that you want objects to stay in the CloudFront cache before another request to the origin to see if the object has been updated. Defaults to `86400` (one day)."
  type        = number
  default     = 86400
  nullable    = false
}

variable "min_ttl" {
  description = "(Optional) The minimum time to live in seconds. The amount of time is that you want objects to stay in the CloudFront cache before another request to the origin to see if the object has been updated. Defaults to `1`."
  type        = number
  default     = 1
  nullable    = false
}

variable "max_ttl" {
  description = "(Optional) The maximum time to live in seconds. The amount of time is that you want objects to stay in the CloudFront cache before another request to the origin to see if the object has been updated. Defaults to `31536000` (one year)."
  type        = number
  default     = 31536000
  nullable    = false
}

variable "supported_compression_formats" {
  description = "(Optional) A list of compression formats to enable CloudFront to request and cache objects that are compressed in these compression formats, when the viewer supports it. These setting also allow CloudFront's automatic compression to work. Valid values are `BROTLI` and `GZIP`."
  type        = set(string)
  default     = ["BROTLI", "GZIP"]
  nullable    = false

  validation {
    condition = alltrue([
      for format in var.supported_compression_formats :
      contains(["BROTLI", "GZIP"], format)
    ])
    error_message = "Valid values are `BROTLI` and `GZIP`."
  }
}

variable "cache_keys_in_cookies" {
  description = <<EOF
  (Optional) A configuraiton for specifying which cookies to use as cache key in viewer requests. The values in the cache key are automatically forwarded in requests to the origin. `cache_keys_in_cookies` as defined below.
    (Required) `behavior` - Determine whether any cookies in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. Valid values are `NONE`, `WHITELIST`, `BLACKLIST`, `ALL`.
    (Optional) `items` - A list of cookie names.
  EOF
  type = object({
    behavior = optional(string, "NONE")
    items    = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "BLACKLIST", "ALL"], var.cache_keys_in_cookies.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST`, `BLACKLIST` and `ALL`."
  }
}

variable "cache_keys_in_headers" {
  description = <<EOF
  (Optional) A configuraiton for specifying which headers to use as cache key in viewer requests. The values in the cache key are automatically forwarded in requests to the origin. `cache_keys_in_headers` as defined below.
    (Required) `behavior` - Determine whether any headers in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. Valid values are `NONE`, `WHITELIST`.
    (Optional) `items` - A list of header names.
  EOF
  type = object({
    behavior = optional(string, "NONE")
    items    = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST"], var.cache_keys_in_headers.behavior)
    error_message = "Valid values for `behavior` are `NONE` and `WHITELIST`."
  }
}

variable "cache_keys_in_query_strings" {
  description = <<EOF
  (Optional) A configuraiton for specifying which query strings to use as cache key in viewer requests. The values in the cache key are automatically forwarded in requests to the origin. `cache_keys_in_query_strings` as defined below.
    (Required) `behavior` - Determine whether any query strings in viewer requests are included in the cache key and automatically included in requests that CloudFront sends to the origin. Valid values are `NONE`, `WHITELIST`, `BLACKLIST`, `ALL`.
    (Optional) `items` - A list of query string names.
  EOF
  type = object({
    behavior = optional(string, "NONE")
    items    = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "BLACKLIST", "ALL"], var.cache_keys_in_query_strings.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST`, `BLACKLIST` and `ALL`."
  }
}

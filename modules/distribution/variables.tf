variable "name" {
  description = "(Required) The name of the CloudFront distribution."
  type        = string
  nullable    = false
}

variable "aliases" {
  description = "(Optional) A list of extra CNAMEs (alternate domain names) that use in URLs for the files served by this distribution."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the distribution. Any comments you want to include about the distribution."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "enabled" {
  description = "(Optional) Whether the distribution is enabled to accept end user requests for content. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "retain_on_deletion_enabled" {
  description = "(Optional) Disable the distribution instead of deleting it when destroying the resource through Terraform. If this is `true`, the distribution needs to be deleted manually afterwards. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "wait_for_deployment_enabled" {
  description = "(Optional) Whether to wait for the distribution status to change from `InProgress` to `Deployed`. Skip the deployment waiting process if disabled. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "price_class" {
  description = "(Optional) The price class for this distribution. Valid values are `ALL`, `200` or `100`. Defaults to `ALL`."
  type        = string
  default     = "ALL"
  nullable    = false

  validation {
    condition     = contains(["ALL", "200", "100"], var.price_class)
    error_message = "Valid values are `ALL`, `200` or `100`."
  }
}

variable "http_version" {
  description = "(Optional) The maximum HTTP version to support on the distribution. Valid values are `HTTP1.1`, `HTTP2`, `HTTP2AND3`, or `HTTP3`. Defaults to `HTTP2`."
  type        = string
  default     = "HTTP2"
  nullable    = false

  validation {
    condition     = contains(["HTTP1.1", "HTTP2", "HTTP2AND3", "HTTP3"], var.http_version)
    error_message = "Valid values are `HTTP1.1`, `HTTP2`, `HTTP2AND3`, or `HTTP3`."
  }
}

variable "ipv6_enabled" {
  description = "(Optional) Whether the IPv6 is enabled for the distribution. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "anycast_static_ip_list" {
  description = "(Optional) The ID of anycast static IP address list to associate with the distribution. You must request to AWS Support to use this feature. Only one of `anycast_static_ip_list`."
  type        = string
  default     = null
  nullable    = true
}

variable "waf_web_acl" {
  description = "(Optional) The ARN of a web ACL on WAFv2 to associate with this distribution. Example: `aws_wafv2_web_acl.example.arn`. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have `waf:GetWebACL` permissions assigned."
  type        = string
  default     = null
  nullable    = true
}

variable "is_staging" {
  description = "(Optional) Whether this distribution is a staging distribution. Staging distributions are used for viewing the latest version of a website or application. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "continuous_deployment_policy" {
  description = "(Optional) The ID of a continuous deployment policy. This argument should only be set on a production distribution."
  type        = string
  default     = null
  nullable    = true
}

variable "root_object" {
  description = "(Optional) The object (file name) to return when a viewer requests the root URL(/) instead of a specific object."
  type        = string
  default     = ""
  nullable    = false
}

variable "error_responses" {
  description = <<EOF
  (Optional) A configurations of custom error responses for the distribution. Each key means the HTTP status code that you want to customize like `404`, `503`. Each value of `error_responses` as defined below.
    (Optional) `cache_min_ttl` - The minimum TTL(Time-to-live) in seconds that you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to `10`.
    (Optional) `custom_response` - A configuration for custom error response. `custom_response` block as defined below.
      (Required) `status_code` - The HTTP status code that you want CloudFront to return to the viewer along with the custom error page. You must specify a value for `status_code`, even if it is the same value as the `error_code`.
      (Required) `path` - The path of the custom error page that you want CloudFront to return to a viewer when your origin returns the corresponding `error_code`. The path must begin with a slash (/).
  EOF
  type = map(object({
    cache_min_ttl = optional(number, 10)
    custom_response = optional(object({
      status_code = number
      path        = string
    }))
  }))
  default  = {}
  nullable = false
}

variable "geographic_restriction" {
  description = <<EOF
  (Optional) A configuration for CloudFront geographic restrictions. `geographic_restriction` as defined below.
    (Optiona) `type` - The method that you want to use to restrict distribution of the content by country. Valid values are `NONE`, `WHITELIST` or `BLACKLIST`. Defaults to `NONE`.
    (Optiona) `countries` - A list of the ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (`WHITELIST`) or not distribute your content (`BLACKLIST`).
  EOF
  type = object({
    type      = optional(string, "NONE")
    countries = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "BLACKLIST"], var.geographic_restriction.type)
    error_message = "Valid values for `geographic_restriction.type` are `NONE`, `WHITELIST`, `BLACKLIST`."
  }
}

variable "ssl_certificate_provider" {
  description = <<EOF
  (Optional) The provider of SSL certificate for the distribution. Valid values are `CLOUDFRONT`, `ACM` or `IAM`. Defaults to `CLOUDFRONT`.
    `CLOUDFRONT` - Associate a certificate from CloudFront. The distribution must use the CloudFront domain name.
    `ACM` - Associate a certificate from AWS Certificate Manager. The certificate must be in the US East (N. Virginia) Region (us-east-1).

    `IAM` - Associate a certificate from AWS IAM.
  EOF
  type        = string
  default     = "CLOUDFRONT"
  nullable    = false

  validation {
    condition     = contains(["CLOUDFRONT", "ACM", "IAM"], var.ssl_certificate_provider)
    error_message = "Valid values are `CLOUDFRONT`, `ACM`, `IAM`."
  }
}

variable "ssl_certificate" {
  description = <<EOF
  (Optional) The ARN of the AWS Certificate Manager certificate to use with this distribution if `ssl_certificate_provider` is `ACM`. The ACM certificate must be in `us-east-1`. The ID of IAM certificate to use with this distribution if `ssl_certificate_provider` is `IAM`. Can only be set if `ssl_certificate_provider` is not `CLOUDFRONT`.
  EOF
  type        = string
  default     = null
}

# INFO: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
variable "ssl_security_policy" {
  description = <<EOF
  (Optional) The security policy determines the SSL or TLS protocol and the specific ciphers that CloudFront uses for HTTPS connections with viewers (clients). Valid values are `SSLv3`, `TLSv1`, `TLSv1_2016`, `TLSv1.1_2016`, `TLSv1.2_2018`, `TLSv1.2_2019`, `TLSv1.2_2021`, `TLSv1.2_2025`, `TLSv1.3_2025`. Only `SSLv3` or `TLSv1` can be specified if `ssl_support_method` is `VIP`. Can only be set if `ssl_certificate_provider` is not `CLOUDFRONT`. Defaults to `TLSv1`.
  EOF
  type        = string
  default     = "TLSv1"
  nullable    = false

  validation {
    condition     = contains(["SSLv3", "TLSv1", "TLSv1_2016", "TLSv1.1_2016", "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021", "TLSv1.2_2025", "TLSv1.3_2025"], var.ssl_security_policy)
    error_message = "Valid values are `SSLv3`, `TLSv1`, `TLSv1_2016`, `TLSv1.1_2016`, `TLSv1.2_2018`, `TLSv1.2_2019`, `TLSv1.2_2021`, `TLSv1.2_2025`, `TLSv1.3_2025`."
  }
}

variable "ssl_support_method" {
  description = <<EOF
  (Optional) The method how you want CloudFront to serve HTTPS requests. Valid values are `VIP`, `SNI_ONLY`, `STATIC_IP`. Can only be set if `ssl_certificate_provider` is not `CLOUDFRONT`. Defaults to `SNI_ONLY`.
    `SNI_ONLY` - The distribution accepts HTTPS connections from only viewers that support SNI(Server Name Indication). This is recommended.
    `VIP` - The distribution accepts HTTPS connections from all viewers including those that dont support SNI. This is not recommended, and results in additional monthly charges from CloudFront.
    `STATIC_IP` - Do not specify this value unless your distribution has been enabled for this feature by the CloudFront team. If you have a usecase that requires static IP addresses for a distribution, contact CloudFront through the AWS Support Center.
  EOF
  type        = string
  default     = "SNI_ONLY"
  nullable    = false

  validation {
    condition     = contains(["VIP", "SNI_ONLY", "STATIC_IP"], var.ssl_support_method)
    error_message = "Valid values are `VIP`, `SNI_ONLY`, `STATIC_IP`."
  }
}

variable "s3_origins" {
  description = <<EOF
  (Optional) A configuration for S3 origins of the distribution. Each key defines a name of each S3 origin. Each value of `s3_origins` as defined below.
    (Required) `host` - The DNS domain name of either the S3 bucket.
    (Optional) `path` - The URL path to append to `host` which the origin domain name for origin requests. Enter the directory path, beginning with a slash (/). Do not add a slash (/) at the end of the path.
    (Optional) `origin_access` - The configuration of origin access for the origin. `origin_access` block as defined below.
      (Optional) `type` - The type of origin access. Valid values are `CONTROL`, `IDENTITY` and `NONE`. Defaults to `CONTROL`.
      (Optional) `id` - The ID of origin access control if `type` is `CONTROL`. The full path of the origin access identity if `type` is `IDENTITY`.
    (Optional) `custom_headers` - A map of custom HTTP headers to include in all requests to the origin. Each key/value is mapping to HTTP header `name`/`value`.
    (Optional) `origin_shield` - Origin Shield is an additional caching layer that can help reduce the load on your origin and help protect its availability. `origin_shield` block as defined below.
      (Required) `enabled` - Whether to enable Origin Shield. Defaults to `false`.
      (Required) `region` - The AWS Region for Origin Shield. To specify a region. For example, specify the US East (Ohio) region as `us-east-2`.
    (Optional) `connection_attempts` - The number of times that CloudFront attempts to connect to the origin, from `1` to `3`. Defaults to `3`.
    (Optional) `connection_timeout` - The number of seconds that CloudFront waits for a response from the origin, from `1` to `10`. Defaults to `10`.
    (Optional) `response_completion_timeout` - A timeout that measures the total duration from when CloudFront begins fetching content from your origin until the last byte is received. This timeout encompasses the entire origin operation, including connection time, request transfer, and response transfer. The number of seconds CloudFront should wait for the complete origin response. Must be greater than or equal to the current `response_timeout` (minimum 30 seconds). Defaults to `0`, which means no timeout is set.
  EOF
  type = map(object({
    host = string
    path = optional(string)
    origin_access = optional(object({
      type = optional(string, "CONTROL")
      id   = optional(string)
    }))
    custom_headers = optional(map(string), {})
    origin_shield = optional(object({
      enabled = bool
      region  = string
    }))
    connection_attempts         = optional(number, 3)
    connection_timeout          = optional(number, 10)
    response_completion_timeout = optional(number, 0)
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for origin in var.s3_origins :
      alltrue([
        substr(origin.path, 0, 1) == "/",
        substr(origin.path, -1, 0) != "/"
      ])
      if origin.path != null
    ])
    error_message = "The value for `path` must begins with a slash and do not end with a slash."
  }

  validation {
    condition = alltrue([
      for origin in var.s3_origins :
      contains(["CONTROL", "IDENTITY", "NONE"], origin.origin_access.type)
    ])
    error_message = "Valid values for `origin_access.type` are `CONTROL`, `IDENTITY` and `NONE`."
  }
}

variable "custom_origins" {
  description = <<EOF
  (Optional) A configuration for custom origins of the distribution. Each key defines a name of each custom origin. Each value of `custom_origins` as defined below.
    (Required) `host` - The DNS domain name of either the web site of your custom origin.
    (Optional) `path` - The URL path to append to `host` which the origin domain name for origin requests. Enter the directory path, beginning with a slash (/). Do not add a slash (/) at the end of the path.
    (Optional) `http_port` - The HTTP port the custom origin listens on. Defaults to `80`.
    (Optional) `https_port` - The HTTPS port the custom origin listens on. Defaults to `443`.
    (Optional) `ip_address_type` - The IP address type that CloudFront uses when connecting to the origin. Valid values are `IPV4`, `IPV6`, `DUALSTACK`. Defaults to `IPV4`.
    (Optional) `origin_access` - The configuration of origin access for the origin. `origin_access` block as defined below.
      (Optional) `type` - The type of origin access. Valid values are `CONTROL` and `NONE`. Defaults to `NONE`.
      (Optional) `id` - The ID of origin access control if `type` is `CONTROL`.
    (Optional) `protocol_policy` - The origin protocol policy to apply to your origin. The origin protocol policy determines the protocol (HTTP or HTTPS) that you want CloudFront to use when connecting to the origin. Valid values are `HTTP_ONLY`, `HTTPS_ONLY` or `MATCH_VIEWER`. Defaults to `MATCH_VIEWER`.
    (Optional) `ssl_security_policy` - The minimum SSL/TLS protocol that CloudFront uses with the origin over HTTPS. Valid values are `SSLv3`, `TLSv1`, `TLSv1.1`, and `TLSv1.2`. Defaults to `TLSv1.1`. Recommend the latest TLS protocol that the origin supports.
    (Optional) `custom_headers` - A map of custom HTTP headers to include in all requests to the origin. Each key/value is mapping to HTTP header `name`/`value`.
    (Optional) `origin_shield` - Origin Shield is an additional caching layer that can help reduce the load on your origin and help protect its availability. `origin_shield` block as defined below.
      (Required) `enabled` - Whether to enable Origin Shield. Defaults to `false`.
      (Required) `region` - The AWS Region for Origin Shield. To specify a region. For example, specify the US East (Ohio) region as `us-east-2`.
    (Optional) `connection_attempts` - The number of times that CloudFront attempts to connect to the origin, from `1` to `3`. Defaults to `3`.
    (Optional) `connection_timeout` - The number of seconds that CloudFront waits for a response from the origin, from `1` to `10`. Defaults to `10`.
    (Optional) `keepalive_timeout` - The number of seconds that CloudFront maintains an idle connection with the origin, from `1` to `60`. But, the maximum can be changed arbitrarily by AWS Support to a much higher value. Defaults to `5`.
    (Optional) `response_timeout` - The number of seconds that CloudFront waits for a response from the origin, from `1` to `120`. Defaults to `30`.
    (Optional) `response_completion_timeout` - A timeout that measures the total duration from when CloudFront begins fetching content from your origin until the last byte is received. This timeout encompasses the entire origin operation, including connection time, request transfer, and response transfer. The number of seconds CloudFront should wait for the complete origin response. Must be greater than or equal to the current `response_timeout` (minimum 30 seconds). Defaults to `0`, which means no timeout is set.
  EOF
  type = map(object({
    host            = string
    path            = optional(string)
    http_port       = optional(number, 80)
    https_port      = optional(number, 443)
    ip_address_type = optional(string, "IPV4")
    origin_access = optional(object({
      type = optional(string, "NONE")
      id   = optional(string)
    }))
    protocol_policy     = optional(string, "MATCH_VIEWER")
    ssl_security_policy = optional(string, "TLSv1.1")
    custom_headers      = optional(map(string), {})
    origin_shield = optional(object({
      enabled = bool
      region  = string
    }))
    connection_attempts         = optional(number, 3)
    connection_timeout          = optional(number, 10)
    keepalive_timeout           = optional(number, 5)
    response_timeout            = optional(number, 30)
    response_completion_timeout = optional(number, 0)
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      alltrue([
        substr(origin.path, 0, 1) == "/",
        substr(origin.path, -1, 0) != "/"
      ])
      if origin.path != null
    ])
    error_message = "The value for `path` must begins with a slash and do not end with a slash."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      alltrue([
        anytrue([
          contains([80, 443], origin.http_port),
          origin.http_port >= 1024 && origin.http_port <= 65535
        ]),
        anytrue([
          contains([80, 443], origin.https_port),
          origin.https_port >= 1024 && origin.https_port <= 65535
        ])
      ])
    ])
    error_message = "Valid values for ports include `80`, `443`, and `1024` to `65535`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      contains(["IPV4", "IPV6", "DUALSTACK"], origin.ip_address_type)
    ])
    error_message = "Valid values for `ip_address_type` are `IPV4`, `IPV6`, and `DUALSTACK`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      contains(["CONTROL", "NONE"], origin.origin_access.type)
    ])
    error_message = "Valid values for `origin_access.type` are `CONTROL` and `NONE`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      contains(["HTTP_ONLY", "HTTPS_ONLY", "MATCH_VIEWER"], origin.protocol_policy)
    ])
    error_message = "Valid values for `protocol_policy` are `HTTP_ONLY`, `HTTPS_ONLY`, and `MATCH_VIEWER`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], origin.ssl_security_policy)
    ])
    error_message = "Valid values for `ssl_security_policy` are `SSLv3`, `TLSv1`, `TLSv1.1`, and `TLSv1.2`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      origin.response_completion_timeout >= origin.response_timeout || origin.response_completion_timeout == 0
    ])
    error_message = "The value of `response_completion_timeout` must be greater than or equal to the value of `response_timeout` when `response_completion_timeout` is set."
  }
}

variable "origin_groups" {
  description = <<EOF
  (Optional) A configuration for origin groups of the distribution. Each key defines a name of each origin group. Each value of `origin_groups` as defined below.
    (Required) `primary_origin` - The ID of Primary Origin.
    (Required) `secondary_origin` - The ID of Secondary Origin.
    (Required) `failover_status_codes` - A list of HTTP status codes for when to failover to the secondary origin.
  EOF
  type = map(object({
    primary_origin        = string
    secondary_origin      = string
    failover_status_codes = set(number)
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for id, group in var.origin_groups :
      alltrue([
        for status_code in group.failover_status_codes :
        contains([400, 403, 404, 416, 500, 502, 503, 504], status_code)
      ])
    ])
    error_message = "Supported status codes for failover criteria are `400`, `403`, `404`, `416`, `500`, `502`, `503`, `504`."
  }

  validation {
    condition = alltrue([
      for id, group in var.origin_groups :
      length(group.failover_status_codes) > 0
    ])
    error_message = "One or more status codes should be defined in `failover_status_codes`."
  }
}

variable "default_behavior" {
  description = <<EOF
  (Required) A default bahavior for the distribution. `default_behavior` as defined below.
    (Required) `target_origin` - The ID of existing origin or origin group that you want CloudFront to route requests to when a request matches the path pattern for the default behavior.
    (Optional) `compression_enabled` - Whether you want CloudFront to automatically compress content for web requests that include `Accept-Encoding: gzip` in the request header. Defaults to `true`.
    (Optional) `smooth_streaming_enabled` - Whether to distribute media files in Microsoft Smooth Streaming format and you do not have an IIS server. Set `false` if your origin is configured to use Microsoft IIS for Smooth Streaming. Defaults to `false`.
    (Optional) `field_level_encryption_configuration` - The ID of field-level encryption configuration. To associate a field-level encryption configuration with a cache behavior, the distribution must be configured to always use HTTPS, and to accept HTTP POST and PUT requests from viewers.
    (Optional) `realtime_log_configuration` -The ARN of real-time log configuration for the default behavior. Real-time logs are delivered to the data stream in Amazon Kinesis Data Streams.
    (Optional) `viewer_protocol_policy` - The protocol policy that viewers can use to access the contents in CloudFront edge locations. Valid values are `ALLOW_ALL`, `HTTPS_ONLY`, and `REDIRECT_TO_HTTPS`. Defaults to `REDIRECT_TO_HTTPS`.
    (Optional) `allowed_http_methods` - A list of HTTP methods to allow. Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Valid values are `["GET", "HEAD"]` , `["GET", "HEAD", "OPTIONS"]`, or `["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]`. Defaults to `["GET", "HEAD"]`.
    (Optional) `cached_http_methods` - A list of HTTP methods to cache. Controls whether CloudFront caches the response to requests using the specified HTTP methods. Valid values are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`. Defaults to `["GET", "HEAD"]`.
    (Optional) `grpc_enabled` - Whether to allow gRPC requests. To enable gRPC for the distribution, must allow the `POST` http method and allow the HTTP/2 version. Defaults to `false`.
    (Optional) `cache_policy` - The ID of the cache policy that you want to attach to the default behavior of the distribution.
    (Optional) `origin_request_policy` - The ID of the origin request policy that you want to attach to the default behavior of the distribution.
    (Optional) `response_headers_policy` - The ID of the response headers policy that you want to attach to the default behavior of the distribution.
    (Optional) `legacy_cache_config` - The legacy cache configuration for the default behavior of the distribution. Recommend using a cache policy and origin request policy to control the cache key and origin requests. `legacy_cache_config` block as defined below.
      (Opitonal) `enabled` - Whether to enable legacy cache configuration. Defaults to `false`.
      (Optional) `min_ttl` - The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to `0`.
      (Optional) `default_ttl` - The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an `Cache-Control max-age` or `Expires` header. Defaults to `86400`.
      (Optional) `max_ttl` - The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of `Cache-Control max-age`, `Cache-Control s-maxage`, and `Expires` headers. Defaults to `31536000`.
      (Optional) `forwarding_cookies` - A configuration for specifying which cookies in viewer requests to be forwarded in the origin requests. `forwarding_cookies` as defined below.
        (Required) `behavior` - Determine whether any cookies in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST` and `ALL`. Defaults to `NONE`.
        (Optional) `items` - A list of cookie names. It only takes effect when `behavior` is `WHITELIST`.
      (Optional) `forwarding_headers` - A configuration for specifying which headers in viewer requests to be forwarded in the origin requests. `forwarding_headers` as defined below.
        (Required) `behavior` - Determine whether any headers in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST` and `ALL`. Defaults to `NONE`.
        (Optional) `items` - A list of header names. It only takes effect when `behavior` is `WHITELIST`.
      (Optional) `forwarding_query_strings` - A configuration for specifying which query strings in viewer requests to be forwarded in the origin requests. `forwarding_query_strings` as defined below.
        (Required) `behavior` - Determine whether any query strings in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`. Defaults to `NONE`.
        (Optional) `items` - A list of query string names. It only takes effect when `behavior` is `WHITELIST`.
    (Optional) `function_associations` - The configuration for function associations to event of the CloudFront distribution. You can configure a Lambda@Edge function or CloudFront function.

    Each key means the CloudFront event. Supported CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE`, and `VIEWER_RESPONSE`.
    - `VIEWER_REQUEST`: When CloudFront receives a request from a viewer.
    - `ORIGIN_REQUEST`: Before CloudFront forwards a request to the origin.
    - `ORIGIN_RESPONSE`: When CloudFront receives a response from the origin.
    - `VIEWER_RESPONSE`: Before CloudFront returns the response to the viewer.

    Each value of `default_function_associtaions` as defined below.
      (Required) `type` - The type of associated function. Valid values are `LAMBDA_EDGE` and `CLOUDFRONT`.
      (Required) `function` - The ARN of the CloudFront function or the Lambda@Edge function.
      (Optional) `include_body` - Whether to expose the request body to the Lambda@Edge function. Only valid when `type` is `LAMBDA_EDGE` on `VIEWER_REQUEST` and `ORIGIN_REQUEST` events. Defaults to `false`.
  EOF
  type = object({
    target_origin = string

    compression_enabled      = optional(bool, true)
    smooth_streaming_enabled = optional(bool, false)

    field_level_encryption_configuration = optional(string)
    realtime_log_configuration           = optional(string)

    viewer_protocol_policy = optional(string, "REDIRECT_TO_HTTPS")
    allowed_http_methods   = optional(set(string), ["GET", "HEAD"])
    cached_http_methods    = optional(set(string), ["GET", "HEAD"])
    grpc_enabled           = optional(bool, false)

    cache_policy            = optional(string)
    origin_request_policy   = optional(string)
    response_headers_policy = optional(string)

    legacy_cache_config = optional(object({
      enabled     = optional(bool, false)
      min_ttl     = optional(number, 0)
      default_ttl = optional(number, 86400)
      max_ttl     = optional(number, 31536000)

      forwarding_cookies = optional(object({
        behavior = optional(string, "NONE")
        items    = optional(set(string), [])
      }), {})
      forwarding_headers = optional(object({
        behavior = optional(string, "NONE")
        items    = optional(set(string), [])
      }), {})
      forwarding_query_strings = optional(object({
        behavior = optional(string, "NONE")
        items    = optional(set(string), [])
      }), {})
    }), {})

    function_associations = optional(map(object({
      type         = string
      function     = string
      include_body = optional(bool, false)
    })), {})
  })
  nullable = false

  validation {
    condition     = contains(["ALLOW_ALL", "HTTPS_ONLY", "REDIRECT_TO_HTTPS"], var.default_behavior.viewer_protocol_policy)
    error_message = <<EOF
    Valid values for `viewer_protocol_policy` are `ALLOW_ALL`, `HTTPS_ONLY` or `REDIRECT_TO_HTTPS`.
    EOF
  }

  validation {
    condition     = contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"]), toset(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])], var.default_behavior.allowed_http_methods)
    error_message = <<EOF
    Valid values for `allowed_http_methods` are `["GET", "HEAD"]`, `["GET", "HEAD", "OPTIONS"]`, `["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"`.
    EOF
  }

  validation {
    condition     = contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"])], var.default_behavior.cached_http_methods)
    error_message = <<EOF
    Valid values for `cached_http_methods` are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`.
    EOF
  }

  validation {
    condition = anytrue([
      !var.default_behavior.grpc_enabled,
      (var.default_behavior.grpc_enabled
        && contains(var.default_behavior.allowed_http_methods, "POST")
        && contains(["HTTP2", "HTTP2AND3"], var.http_version)
      )
    ])
    error_message = "To enable gRPC, you must allow the `POST` http method and allow the HTTP/2 version."
  }

  validation {
    condition = alltrue([
      for event in keys(var.default_behavior.function_associations) :
      contains(["VIEWER_REQUEST", "ORIGIN_REQUEST", "ORIGIN_RESPONSE", "VIEWER_RESPONSE"], event)
    ])
    error_message = "Valid values for CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE` and `VIEWER_RESPONSE`."
  }

  validation {
    condition = alltrue([
      for f in var.default_behavior.function_associations :
      contains(["LAMBDA_EDGE", "CLOUDFRONT"], f.type)
    ])
    error_message = "Valid values for function types are `LAMBDA_EDGE` and `CLOUDFRONT`."
  }

  validation {
    condition     = contains(["NONE", "WHITELIST", "ALL"], var.default_behavior.legacy_cache_config.forwarding_cookies.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST` and `ALL`."
  }

  validation {
    condition     = contains(["NONE", "WHITELIST", "ALL"], var.default_behavior.legacy_cache_config.forwarding_headers.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST` and `ALL`."
  }

  validation {
    condition     = contains(["NONE", "WHITELIST", "ALL"], var.default_behavior.legacy_cache_config.forwarding_query_strings.behavior)
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST` and `ALL`."
  }
}

variable "ordered_behaviors" {
  description = <<EOF
  (Optional) An ordered list of ordered bahaviors for the distribution. Each block of `ordered_behaviors` as defined below.
    (Required) `path_patterns` - A list of patterns that specifies which requests you want this cache behavior to apply to. When CloudFront receives an end-user request, the requested path is compared with path patterns in the order in which cache behaviors are listed in the distribution. The first match determines which cache behavior is applied to that request. Path patterns support wildcard matching: `*` and `?`. Path patterns are case-sensitive, and support the following characters: a-z, A-Z, 0-9, `_-.*$/~"'@:+'"`, & (as `&amp;`).
    (Required) `target_origin` - The ID of existing origin or origin group that you want CloudFront to route requests to when a request matches the path pattern for the behavior.
    (Optional) `compression_enabled` - Whether you want CloudFront to automatically compress content for web requests that include `Accept-Encoding: gzip` in the request header. Defaults to `true`.
    (Optional) `smooth_streaming_enabled` - Whether to distribute media files in Microsoft Smooth Streaming format and you do not have an IIS server. Set `false` if your origin is configured to use Microsoft IIS for Smooth Streaming. Defaults to `false`.
    (Optional) `field_level_encryption_configuration` - The ID of field-level encryption configuration. To associate a field-level encryption configuration with a cache behavior, the distribution must be configured to always use HTTPS, and to accept HTTP POST and PUT requests from viewers.
    (Optional) `realtime_log_configuration` -The ARN of real-time log configuration for the behavior. Real-time logs are delivered to the data stream in Amazon Kinesis Data Streams.
    (Optional) `viewer_protocol_policy` - The protocol policy that viewers can use to access the contents in CloudFront edge locations. Valid values are `ALLOW_ALL`, `HTTPS_ONLY`, and `REDIRECT_TO_HTTPS`. Defaults to `REDIRECT_TO_HTTPS`.
    (Optional) `allowed_http_methods` - A list of HTTP methods to allow. Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Valid values are `["GET", "HEAD"]` , `["GET", "HEAD", "OPTIONS"]`, or `["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]`. Defaults to `["GET", "HEAD"]`.
    (Optional) `cached_http_methods` - A list of HTTP methods to cache. Controls whether CloudFront caches the response to requests using the specified HTTP methods. Valid values are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`. Defaults to `["GET", "HEAD"]`.
    (Optional) `grpc_enabled` - Whether to allow gRPC requests. To enable gRPC for the distribution, must allow the `POST` http method and allow the HTTP/2 version. Defaults to `false`.
    (Optional) `cache_policy` - The ID of the cache policy that you want to attach to the behavior of the distribution.
    (Optional) `origin_request_policy` - The ID of the origin request policy that you want to attach to the behavior of the distribution.
    (Optional) `response_headers_policy` - The ID of the response headers policy that you want to attach to the behavior of the distribution.
    (Optional) `legacy_cache_config` - The legacy cache configuration for the behavior of the distribution. Recommend using a cache policy and origin request policy to control the cache key and origin requests. `legacy_cache_config` block as defined below.
      (Opitonal) `enabled` - Whether to enable legacy cache configuration. Defaults to `false`.
      (Optional) `min_ttl` - The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to `0`.
      (Optional) `default_ttl` - The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an `Cache-Control max-age` or `Expires` header. Defaults to `86400`.
      (Optional) `max_ttl` - The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of `Cache-Control max-age`, `Cache-Control s-maxage`, and `Expires` headers. Defaults to `31536000`.
      (Optional) `forwarding_cookies` - A configuration for specifying which cookies in viewer requests to be forwarded in the origin requests. `forwarding_cookies` as defined below.
        (Required) `behavior` - Determine whether any cookies in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST` and `ALL`. Defaults to `NONE`.
        (Optional) `items` - A list of cookie names. It only takes effect when `behavior` is `WHITELIST`.
      (Optional) `forwarding_headers` - A configuration for specifying which headers in viewer requests to be forwarded in the origin requests. `forwarding_headers` as defined below.
        (Required) `behavior` - Determine whether any headers in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST` and `ALL`. Defaults to `NONE`.
        (Optional) `items` - A list of header names. It only takes effect when `behavior` is `WHITELIST`.
      (Optional) `forwarding_query_strings` - A configuration for specifying which query strings in viewer requests to be forwarded in the origin requests. `forwarding_query_strings` as defined below.
        (Required) `behavior` - Determine whether any query strings in viewer requests are forwarded in the origin requests. Valid values are `NONE`, `WHITELIST`, `ALL`. Defaults to `NONE`.
        (Optional) `items` - A list of query string names. It only takes effect when `behavior` is `WHITELIST`.
    (Optional) `function_associations` - The configuration for function associations to event of the CloudFront distribution. You can configure a Lambda@Edge function or CloudFront function. Each key means the CloudFront event. Supported CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE`, and `VIEWER_RESPONSE`. Each value of `default_function_associtaions` as defined below.
      (Required) `type` - The type of associated function. Valid values are `LAMBDA_EDGE` and `CLOUDFRONT`.
      (Required) `function` - The ARN of the CloudFront function or the Lambda@Edge function.
      (Optional) `include_body` - Whether to expose the request body to the Lambda@Edge function. Only valid when `type` is `LAMBDA_EDGE` on `VIEWER_REQUEST` and `ORIGIN_REQUEST` events. Defaults to `false`.
  EOF
  type = list(object({
    path_patterns = list(string)
    target_origin = string

    compression_enabled      = optional(bool, true)
    smooth_streaming_enabled = optional(bool, false)

    field_level_encryption_configuration = optional(string)
    realtime_log_configuration           = optional(string)

    viewer_protocol_policy = optional(string, "REDIRECT_TO_HTTPS")
    allowed_http_methods   = optional(set(string), ["GET", "HEAD"])
    cached_http_methods    = optional(set(string), ["GET", "HEAD"])
    grpc_enabled           = optional(bool, false)

    cache_policy            = optional(string)
    origin_request_policy   = optional(string)
    response_headers_policy = optional(string)

    legacy_cache_config = optional(object({
      enabled     = optional(bool, false)
      min_ttl     = optional(number, 0)
      default_ttl = optional(number, 86400)
      max_ttl     = optional(number, 31536000)

      forwarding_cookies = optional(object({
        behavior = optional(string, "NONE")
        items    = optional(set(string), [])
      }), {})
      forwarding_headers = optional(object({
        behavior = optional(string, "NONE")
        items    = optional(set(string), [])
      }), {})
      forwarding_query_strings = optional(object({
        behavior = optional(string, "NONE")
        items    = optional(set(string), [])
      }), {})
    }), {})

    function_associations = optional(map(object({
      type         = string
      function     = string
      include_body = optional(bool, false)
    })), {})
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      length(behavior.path_patterns) > 0
    ])
    error_message = "At least one path pattern should be defined in `path_patterns`."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains(["ALLOW_ALL", "HTTPS_ONLY", "REDIRECT_TO_HTTPS"], behavior.viewer_protocol_policy)
    ])
    error_message = <<EOF
    Valid values for `viewer_protocol_policy` are `ALLOW_ALL`, `HTTPS_ONLY` or `REDIRECT_TO_HTTPS`.
    EOF
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"]), toset(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])], behavior.allowed_http_methods)
    ])
    error_message = <<EOF
    Valid values for `allowed_http_methods` are `["GET", "HEAD"]`, `["GET", "HEAD", "OPTIONS"]`, `["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"`.
    EOF
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"])], behavior.cached_http_methods)
    ])
    error_message = <<EOF
    Valid values for `cached_http_methods` are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`.
    EOF
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      anytrue([
        !behavior.grpc_enabled,
        (behavior.grpc_enabled
          && contains(behavior.allowed_http_methods, "POST")
          && contains(["HTTP2", "HTTP2AND3"], var.http_version)
        )
      ])
    ])
    error_message = "To enable gRPC, you must allow the `POST` http method and allow the HTTP/2 version."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      alltrue([
        for event in keys(behavior.function_associations) :
        contains(["VIEWER_REQUEST", "ORIGIN_REQUEST", "ORIGIN_RESPONSE", "VIEWER_RESPONSE"], event)
      ])
    ])
    error_message = "Valid values for CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE` and `VIEWER_RESPONSE`."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      alltrue([
        for f in behavior.function_associations :
        contains(["LAMBDA_EDGE", "CLOUDFRONT"], f.type)
      ])
    ])
    error_message = "Valid values for function types are `LAMBDA_EDGE` and `CLOUDFRONT`."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains(["NONE", "WHITELIST", "ALL"], behavior.legacy_cache_config.forwarding_cookies.behavior)
    ])
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST` and `ALL`."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains(["NONE", "WHITELIST", "ALL"], behavior.legacy_cache_config.forwarding_headers.behavior)
    ])
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST` and `ALL`."
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains(["NONE", "WHITELIST", "ALL"], behavior.legacy_cache_config.forwarding_query_strings.behavior)
    ])
    error_message = "Valid values for `behavior` are `NONE`, `WHITELIST` and `ALL`."
  }
}

variable "logging_s3_enabled" {
  description = "(Optional) Indicates whether you want to enable or disable access logs to S3."
  type        = bool
  default     = false
  nullable    = false
}

variable "logging_s3_bucket" {
  description = "(Optional) The domain name of the S3 bucket to deliver logs to. Example: `myawslogbucket.s3.amazonaws.com`."
  type        = string
  default     = ""
  nullable    = false
}

variable "logging_s3_prefix" {
  description = "(Optional) The prefix to append to the folder name."
  type        = string
  default     = ""
  nullable    = false
}

variable "logging_include_cookies" {
  description = "(Optional) Indicate whether to include cookies in access logs. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "monitoring_realtime_metrics_enabled" {
  description = "(Optional) Whether additional real-time CloudWatch metrics are enabled for the CloudFront distribution."
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}

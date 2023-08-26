variable "name" {
  description = "(Required) The name of the CloudFront distribution."
  type        = string
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
  description = "(Optional) Whether the distribution is enabled to accept end user requests for content."
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

variable "waf_web_acl" {
  description = "(Optional) The ARN of a web ACL on WAFv2 to associate with this distribution. Example: `aws_wafv2_web_acl.example.arn`. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have `waf:GetWebACL` permissions assigned."
  type        = string
  default     = null
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
    (Optional) `custom_response_code` - The HTTP status code to return to the viewer. CloudFront can return a different status code to the viewer than what it received from the origin.
    (Optional) `custom_response_path` - The path to the custom error response page.
  EOF
  type        = any
  default     = {}
  nullable    = false
}

variable "restriction_type" {
  description = "(Optional) The method that you want to use to restrict distribution of the content by country. Valid values are `NONE`, `WHITELIST` or `BLACKLIST`. Defaults to `NONE`"
  type        = string
  default     = "NONE"
  nullable    = false

  validation {
    condition     = contains(["NONE", "WHITELIST", "BLACKLIST"], var.restriction_type)
    error_message = "Valid values are `NONE`, `WHITELIST`, `BLACKLIST`."
  }
}

variable "restriction_locations" {
  description = "(Optional) A list of the ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (`WHITELIST`) or not distribute your content (`BLACKLIST`)."
  type        = set(string)
  default     = []
  nullable    = false
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
  (Optional) The security policy determines the SSL or TLS protocol and the specific ciphers that CloudFront uses for HTTPS connections with viewers (clients). Only `SSLv3` or `TLSv1` can be specified if `ssl_support_method` is `VIP`. Can only be set if `ssl_certificate_provider` is not `CLOUDFRONT`. Defaults to `TLSv1`.
  EOF
  type        = string
  default     = "TLSv1"
  nullable    = false

  validation {
    condition     = contains(["TLSv1", "TLSv1_2016", "TLSv1.1_2016", "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"], var.ssl_security_policy)
    error_message = "Valid values are `TLSv1`, `TLSv1_2016`, `TLSv1.1_2016`, `TLSv1.2_2018`, `TLSv1.2_2019`, `TLSv1.2_2021`."
  }
}

variable "ssl_support_method" {
  description = <<EOF
  (Optional) The method how you want CloudFront to serve HTTPS requests. Valid values are `VIP`, `SNI_ONLY`, `STATIC_IP`. Can only be set if `ssl_certificate_provider` is not `CLOUDFRONT`. Defaults to `SNI_ONLY`.
    `SNI_ONLY` - The distribution accepts HTTPS connections from only viewers that support SNI(Server Name Indication). This is recommended.
    `VIP` - The distribution accepts HTTPS  connections  from  all viewers including those that dont support SNI. This is not recommended, and results in additional monthly charges from CloudFront.
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
    (Optional) `custom_headers` - A map of custom HTTP headers to include in all requests to the origin. Each key/value is mapping to HTTP header `name`/`value`.
    (Optional) `origin_shield` - Origin Shield is an additional caching layer that can help reduce the load on your origin and help protect its availability. `origin_shield` block as defined below.
      (Required) `enabled` - Whether to enable Origin Shield. Defaults to `false`.
      (Required) `region` - The AWS Region for Origin Shield. To specify a region. For example, specify the US East (Ohio) region as `us-east-2`.
    (Optional) `connection_attempts` - The number of times that CloudFront attempts to connect to the origin, from `1` to `3`. Defaults to `3`.
    (Optional) `connection_timeout` - The number of seconds that CloudFront waits for a response from the origin, from `1` to `10`. Defaults to `10`.
  EOF
  type        = any
  default     = {}
  nullable    = false

  validation {
    condition = alltrue([
      for origin in var.s3_origins :
      alltrue([
        substr(origin.path, 0, 1) == "/",
        substr(origin.path, -1, 0) != "/"
      ])
      if try(origin.path, null) != null
    ])
    error_message = "The value for `path` must begins with a slash and do not end with a slash."
  }
}

variable "custom_origins" {
  description = <<EOF
  (Optional) A configuration for custom origins of the distribution. Each key defines a name of each custom origin. Each value of `custom_origins` as defined below.
    (Required) `host` - The DNS domain name of either the web site of your custom origin.
    (Optional) `path` - The URL path to append to `host` which the origin domain name for origin requests. Enter the directory path, beginning with a slash (/). Do not add a slash (/) at the end of the path.
    (Optional) `http_port` - The HTTP port the custom origin listens on. Defaults to `80`.
    (Optional) `https_port` - The HTTPS port the custom origin listens on. Defaults to `443`.
    (Optional) `protocol_policy` - The origin protocol policy to apply to your origin. The origin protocol policy determines the protocol (HTTP or HTTPS) that you want CloudFront to use when connecting to the origin. Valid values are `HTTP_ONLY`, `HTTPS_ONLY` or `MATCH_VIEWER`. Defaults to `MATCH_VIEWER`.
    (Optional) `ssl_security_policy` - The minimum SSL/TLS protocol that CloudFront uses with the origin over HTTPS. Valid values are `SSLv3`, `TLSv1`, `TLSv1.1`, and `TLSv1.2`. Defaults to `TLSv1.1`. Recommend the latest TLS protocol that the origin supports.
    (Optional) `custom_headers` - A map of custom HTTP headers to include in all requests to the origin. Each key/value is mapping to HTTP header `name`/`value`.
    (Optional) `origin_shield` - Origin Shield is an additional caching layer that can help reduce the load on your origin and help protect its availability. `origin_shield` block as defined below.
      (Required) `enabled` - Whether to enable Origin Shield. Defaults to `false`.
      (Required) `region` - The AWS Region for Origin Shield. To specify a region. For example, specify the US East (Ohio) region as `us-east-2`.
    (Optional) `connection_attempts` - The number of times that CloudFront attempts to connect to the origin, from `1` to `3`. Defaults to `3`.
    (Optional) `connection_timeout` - The number of seconds that CloudFront waits for a response from the origin, from `1` to `10`. Defaults to `10`.
    (Optional) `keepalive_timeout` - The number of seconds that CloudFront maintains an idle connection with the origin, from `1` to `60`. But, the maximum can be changed arbitrarily by AWS Support to a much higher value. Defaults to `5`.
    (Optional) `response_timeout` - The number of seconds that CloudFront waits for a response from the origin, from `1` to `60`. Defaults to `30`.
  EOF
  type        = any
  default     = {}
  nullable    = false

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      alltrue([
        substr(origin.path, 0, 1) == "/",
        substr(origin.path, -1, 0) != "/"
      ])
      if try(origin.path, null) != null
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
      if(try(origin.http_port, null) != null) || (try(origin.https_port, null) != null)
    ])
    error_message = "Valid values for ports include `80`, `443`, and `1024` to `65535`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      contains(["HTTP_ONLY", "HTTPS_ONLY", "MATCH_VIEWER"], origin.protocol_policy)
      if try(origin.protocol_policy, null) != null
    ])
    error_message = "Valid values for `protocol_policy` are `HTTP_ONLY`, `HTTPS_ONLY`, and `MATCH_VIEWER`."
  }

  validation {
    condition = alltrue([
      for origin in var.custom_origins :
      contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], origin.ssl_security_policy)
      if try(origin.ssl_security_policy, null) != null
    ])
    error_message = "Valid values for `ssl_security_policy` are `SSLv3`, `TLSv1`, `TLSv1.1`, and `TLSv1.2`."
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

variable "default_target_origin" {
  description = "(Required) The ID of existing origin or origin group that you want CloudFront to route requests to when a request matches the path pattern for the default behavior."
  type        = string
  nullable    = false
}

variable "default_compression_enabled" {
  description = "(Optional) Whether you want CloudFront to automatically compress content for web requests that include `Accept-Encoding: gzip` in the request header. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "default_smooth_streaming_enabled" {
  description = "(Optional) Whether to distribute media files in Microsoft Smooth Streaming format and you do not have an IIS server. Set `false` if your origin is configured to use Microsoft IIS for Smooth Streaming. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "default_field_level_encryption_configuration" {
  description = "(Optional) The ID of field-level encryption configuration. To associate a field-level encryption configuration with a cache behavior, the distribution must be configured to always use HTTPS, and to accept HTTP POST and PUT requests from viewers."
  type        = string
  default     = null
}

variable "default_realtime_log_configuration" {
  description = "(Optional) The ARN of real-time log configuration for the default behavior. Real-time logs are delivered to the data stream in Amazon Kinesis Data Streams."
  type        = string
  default     = null
}

variable "default_viewer_protocol_policy" {
  description = "(Optional) The protocol policy that viewers can use to access the contents in CloudFront edge locations when a request does not matches any path patttern in ordered behaviors. Valid values are `ALLOW_ALL`, `HTTPS_ONLY`, and `REDIRECT_TO_HTTPS`. Defaults to `REDIRECT_TO_HTTPS`."
  type        = string
  default     = "REDIRECT_TO_HTTPS"
  nullable    = false

  validation {
    condition     = contains(["ALLOW_ALL", "HTTPS_ONLY", "REDIRECT_TO_HTTPS"], var.default_viewer_protocol_policy)
    error_message = "Valid values are `ALLOW_ALL`, `HTTPS_ONLY`, `REDIRECT_TO_HTTPS`."
  }
}

variable "default_allowed_http_methods" {
  description = <<EOF
  (Optional) A list of HTTP methods to allow. Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Valid values are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`. Defaults to `["GET", "HEAD"]`.`GET`, `HEAD`, `OPTIONS`, `PUT`, `POST`, `PATCH` and `DELETE`. Defaults to `GET` and `HEAD`.
  EOF
  type        = set(string)
  default     = ["GET", "HEAD"]
  nullable    = false

  validation {
    condition = alltrue([
      for method in var.default_allowed_http_methods :
      contains(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"], method)
    ])
    error_message = "Valid values for `default_allowed_http_methods` are `GET`, `HEAD`, `OPTIONS`, `PUT`, `POST`, `PATCH` and `DELETE`."
  }

  validation {
    condition     = contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"]), toset(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])], var.default_allowed_http_methods)
    error_message = <<EOF
    Valid values for `default_allowed_http_methods` are `["GET", "HEAD"]`, `["GET", "HEAD", "OPTIONS"]` or `["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]`.
    EOF
  }
}

variable "default_cached_http_methods" {
  description = <<EOF
  (Optional) A list of HTTP methods to cache. Controls whether CloudFront caches the response to requests using the specified HTTP methods. Valid values are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`. Defaults to `["GET", "HEAD"]`.
  EOF
  type        = set(string)
  default     = ["GET", "HEAD"]
  nullable    = false

  validation {
    condition = alltrue([
      for method in var.default_cached_http_methods :
      contains(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"], method)
    ])
    error_message = "Valid values for `default_allowed_http_methods` are `GET`, `HEAD`, `OPTIONS`, `PUT`, `POST`, `PATCH` and `DELETE`."
  }

  validation {
    condition     = contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"])], var.default_cached_http_methods)
    error_message = <<EOF
    Valid values for `default_cached_http_methods` are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`.
    EOF
  }
}

variable "default_cache_policy" {
  description = "(Optional) The ID of the cache policy that you want to attach to the default behavior of the distribution."
  type        = string
  default     = null
}

variable "default_origin_request_policy" {
  description = "(Optional) The ID of the origin request policy that you want to attach to the default behavior of the distribution."
  type        = string
  default     = null
}

variable "default_response_headers_policy" {
  description = "(Optional) The ID of the response headers policy that you want to attach to the default behavior of the distribution."
  type        = string
  default     = null
}

variable "default_function_associations" {
  description = <<EOF
  (Optional) The configuration for function associations to event of the CloudFront distribution. You can configure a Lambda@Edge function or CloudFront function when one or more of the following CloudFront events occur:
    - `VIEWER_REQUEST`: When CloudFront receives a request from a viewer.
    - `ORIGIN_REQUEST`: Before CloudFront forwards a request to the origin.
    - `ORIGIN_RESPONSE`: When CloudFront receives a response from the origin.
    - `VIEWER_RESPONSE`: Before CloudFront returns the response to the viewer.

  Each key means the CloudFront event. Supported CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE`, and `VIEWER_RESPONSE`. Each value of `default_function_associtaions` as defined below.
    (Required) `type` - The type of associated function. Valid values are `LAMBDA_EDGE` and `CLOUDFRONT`.
    (Required) `function` - The ARN of the CloudFront function or the Lambda@Edge function.
    (Optional) `include_body` - Whether to expose the request body to the Lambda@Edge function. Only valid when `type` is `LAMBDA_EDGE` on `VIEWER_REQUEST` and `ORIGIN_REQUEST` events. Defaults to `false`.
  EOF
  type        = any
  default     = {}
  nullable    = false

  validation {
    condition = alltrue([
      for event in keys(var.default_function_associations) :
      contains(["VIEWER_REQUEST", "ORIGIN_REQUEST", "ORIGIN_RESPONSE", "VIEWER_RESPONSE"], event)
    ])
    error_message = "Valid values for CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE` and `VIEWER_RESPONSE`."
  }

  validation {
    condition = alltrue([
      for f in var.default_function_associations :
      contains(["LAMBDA_EDGE", "CLOUDFRONT"], f.type)
    ])
    error_message = "Valid values for function types are `LAMBDA_EDGE` and `CLOUDFRONT`."
  }
}

variable "default_cache_ttl" {
  description = <<EOF
  (Optional) The configuration for cache TTL(Time-to-Live) values of the default behavior. `default_cache_ttl` block as defined below.
    (Required) `min` - The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
    (Required) `default` - The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an `Cache-Control max-age` or `Expires` header.
    (Required) `max` - The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of `Cache-Control max-age`, `Cache-Control s-maxage`, and `Expires` headers.
  EOF
  type = object({
    min     = number
    default = number
    max     = number
  })
  default = null
}

variable "ordered_behaviors" {
  description = <<EOF
  (Optional) An ordered list of ordered bahaviors for the distribution. Each block of `ordered_behaviors` as defined below.
    (Required) `path_pattern` - The pattern that specifies which requests you want this cache behavior to apply to. When CloudFront receives an end-user request, the requested path is compared with path patterns in the order in which cache behaviors are listed in the distribution. The first match determines which cache behavior is applied to that request. Path patterns support wildcard matching: `*` and `?`. Path patterns are case-sensitive, and support the following characters: a-z, A-Z, 0-9, `_-.*$/~"'@:+'"`, & (as `&amp;`).
    (Required) `target_origin` - The ID of existing origin or origin group that you want CloudFront to route requests to when a request matches the path pattern for the behavior.
    (Optional) `compression_enabled` - Whether you want CloudFront to automatically compress content for web requests that include `Accept-Encoding: gzip` in the request header. Defaults to `true`.
    (Optional) `smooth_streaming_enabled` - Whether to distribute media files in Microsoft Smooth Streaming format and you do not have an IIS server. Set `false` if your origin is configured to use Microsoft IIS for Smooth Streaming. Defaults to `false`.
    (Optional) `field_level_encryption_configuration` - The ID of field-level encryption configuration. To associate a field-level encryption configuration with a cache behavior, the distribution must be configured to always use HTTPS, and to accept HTTP POST and PUT requests from viewers.
    (Optional) `realtime_log_configuration` -The ARN of real-time log configuration for the behavior. Real-time logs are delivered to the data stream in Amazon Kinesis Data Streams.
    (Optional) `viewer_protocol_policy` - The protocol policy that viewers can use to access the contents in CloudFront edge locations. Valid values are `ALLOW_ALL`, `HTTPS_ONLY`, and `REDIRECT_TO_HTTPS`. Defaults to `REDIRECT_TO_HTTPS`.
    (Optional) `allowed_http_methods` - A list of HTTP methods to allow. Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Valid values are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`. Defaults to `["GET", "HEAD"]`.`GET`, `HEAD`, `OPTIONS`, `PUT`, `POST`, `PATCH` and `DELETE`. Defaults to `GET` and `HEAD`.
    (Optional) `cached_http_methods` - A list of HTTP methods to cache. Controls whether CloudFront caches the response to requests using the specified HTTP methods. Valid values are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`. Defaults to `["GET", "HEAD"]`.
    (Optional) `cache_policy` - The ID of the cache policy that you want to attach to the behavior of the distribution.
    (Optional) `origin_request_policy` - The ID of the origin request policy that you want to attach to the behavior of the distribution.
    (Optional) `response_headers_policy` - The ID of the response headers policy that you want to attach to the behavior of the distribution.
    (Optional) `cache_ttl` - The configuration for cache TTL(Time-to-Live) values of the behavior. `cache_ttl` block as defined below.
      (Required) `min` - The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
      (Required) `default` - The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an `Cache-Control max-age` or `Expires` header.
      (Required) `max` - The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of `Cache-Control max-age`, `Cache-Control s-maxage`, and `Expires` headers.
    (Optional) `function_associations` - The configuration for function associations to event of the CloudFront distribution. You can configure a Lambda@Edge function or CloudFront function. Each key means the CloudFront event. Supported CloudFront events are `VIEWER_REQUEST`, `ORIGIN_REQUEST`, `ORIGIN_RESPONSE`, and `VIEWER_RESPONSE`. Each value of `default_function_associtaions` as defined below.
      (Required) `type` - The type of associated function. Valid values are `LAMBDA_EDGE` and `CLOUDFRONT`.
      (Required) `function` - The ARN of the CloudFront function or the Lambda@Edge function.
      (Optional) `include_body` - Whether to expose the request body to the Lambda@Edge function. Only valid when `type` is `LAMBDA_EDGE` on `VIEWER_REQUEST` and `ORIGIN_REQUEST` events. Defaults to `false`.
  EOF
  type        = any
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains(["ALLOW_ALL", "HTTPS_ONLY", "REDIRECT_TO_HTTPS"], behavior.viewer_protocol_policy)
      if try(behavior.viewer_protocol_policy, null) != null
    ])
    error_message = <<EOF
    Valid values for `viewer_protocol_policy` are `ALLOW_ALL`, `HTTPS_ONLY` or `REDIRECT_TO_HTTPS`.
    EOF
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"]), toset(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])], toset(behavior.allowed_http_methods))
      if try(behavior.allowed_http_methods, null) != null
    ])
    error_message = <<EOF
    Valid values for `allowed_http_methods` are `["GET", "HEAD"]`, `["GET", "HEAD", "OPTIONS"]`, `["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"`.
    EOF
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      contains([toset(["GET", "HEAD"]), toset(["GET", "HEAD", "OPTIONS"])], toset(behavior.cached_http_methods))
      if try(behavior.cached_http_methods, null) != null
    ])
    error_message = <<EOF
    Valid values for `cached_http_methods` are `["GET", "HEAD"]` or `["GET", "HEAD", "OPTIONS"]`.
    EOF
  }

  validation {
    condition = alltrue([
      for behavior in var.ordered_behaviors :
      alltrue([
        for event in keys(behavior.function_associations) :
        contains(["VIEWER_REQUEST", "ORIGIN_REQUEST", "ORIGIN_RESPONSE", "VIEWER_RESPONSE"], event)
      ])
      if try(behavior.function_associations, null) != null
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
      if try(behavior.function_associations, null) != null
    ])
    error_message = "Valid values for function types are `LAMBDA_EDGE` and `CLOUDFRONT`."
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

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}

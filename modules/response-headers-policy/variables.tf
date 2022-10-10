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

variable "cors" {
  description = <<EOF
  (Optional) A configuration for a set of HTTP response headers for CORS(Cross-Origin Resource Sharing). `cors` as defined below.
    (Optional) `enabled` - Whether to enable CORS configuration for the response headers policy .
    (Optional) `override` - Whether CloudFront override the response from the origin which contains one of the CORS headers specified in this policy. Defaults to `true`.
    (Optional) `access_control_allow_credentials` - Whether CloudFront adds the `Access-Control-Allow-Credentials` header in responses to CORS requests. When enabled, CloudFront adds the `Access-Control-Allow-Credentials: true` header in responses to CORS requests. Otherwise, CloudFront doesn't add this header to responses. Defaults to `false`.
    (Optional) `access_control_allow_headers` - A set of HTTP header names for CloudFront to include as values for the `Access-Control-Allow-Headers` HTTP response header in responses to CORS preflight requests. Defaults to `["*"]` (All headers).
    (Optional) `access_control_allow_methods` - A set of HTTP methods for CloudFront to include as values for the `Access-Control-Allow-Methods` header in responses to CORS preflight requests. Valid values are `GET`, `DELETE`, `HEAD`, `OPTIONS`, `PATCH`, `POST`, `PUT`, or `ALL`). Defaults to `ALL` (All methods).
    (Optional) `access_control_allow_origins` - A set of the origins that CloudFront can use as values in the `Access-Control-Allow-Origin` response header. Use `*` value to allow CORS requests from all origins. Defaults to `["*"]` (All origins).
    (Optional) `access_control_expose_headers` - A set of HTTP header names for CloudFront to include as values for the `Access-Control-Expose-Headers` header in responses to CORS requests. Defaults to `[]` (None).
    (Optional) `access_control_max_age` - The number of seconds for CloudFront to use as the value for the `Access-Control-Max-Age` header in responses to CORS preflight requests.
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)

    access_control_allow_credentials = optional(bool, false)
    access_control_allow_headers     = optional(set(string), ["*"])
    access_control_allow_methods     = optional(set(string), ["ALL"])
    access_control_allow_origins     = optional(set(string), ["*"])
    access_control_expose_headers    = optional(set(string), [])
    access_control_max_age           = optional(number, 600)
  })
  default  = {}
  nullable = false

  validation {
    condition     = length(var.cors.access_control_allow_headers) > 0
    error_message = "`access_control_allow_headers` needs to have at least one item."
  }
  validation {
    condition     = length(var.cors.access_control_allow_methods) > 0
    error_message = "`access_control_allow_methods` needs to have at least one item."
  }
  validation {
    condition = alltrue([
      for method in var.cors.access_control_allow_methods :
      contains(["GET", "DELETE", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "ALL"], method)
    ])
    error_message = "Valid value for `access_control_allow_methods` are `GET`, `DELETE`, `HEAD`, `OPTIONS`, `PATCH`, `POST`, `PUT` and `ALL`."
  }
  validation {
    condition     = length(var.cors.access_control_allow_origins) > 0
    error_message = "`access_control_allow_origins` needs to have at least one item."
  }
}

variable "custom_headers" {
  description = <<EOF
  (Optional) A configuration for specifying the custom HTTP headers in HTTP responses sent from CloudFront. Each item of `custom_headers` as defined below.
    (Required) `name` - The HTTP response header name.
    (Optional) `value` - The value for the HTTP response header. If a header value is not provided, CloudFront adds the empty header (with no value) to the response.
    (Optional) `override` - Whether CloudFront overrides a response header with the same name received from the origin with the header specifies here.
  EOF
  type = list(object({
    name     = string
    value    = string
    override = optional(bool, false)
  }))
  default  = []
  nullable = false
}

# INFO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
variable "content_security_policy_header" {
  description = <<EOF
  (Optional) A configuration for `Content-Security-Policy` header in HTTP responses sent from CloudFront. The HTTP `Content-Security-Policy` response header allows web site administrators to control resources the user agent is allowed to load for a given page. With a few exceptions, policies mostly involve specifying server origins and script endpoints. This helps guard against cross-site scripting attacks. `content_security_policy_header` as defined below.
    (Optional) `enabled` - Whether to enable `Content-Security-Policy` response header. Defaults to `false`.
    (Optional) `override` - Whether CloudFront overrides the `Content-Security-Policy` response header with the header received from the origin. Defaults to `true`.
    (Optional) `value` - The value for the `Content-Security-Policy` HTTP response header. The `Content-Security-Policy` header value is limited to 1783 characters.
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)
    value    = optional(string, "")
  })
  default  = {}
  nullable = false
}

# INFO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
variable "content_type_options_header" {
  description = <<EOF
  (Optional) A configuration for `X-Content-Type-Options` header in HTTP responses sent from CloudFront. The `X-Content-Type-Options` response HTTP header is a marker used by the server to indicate that the MIME types advertised in the `Content-Type` headers should be followed and not be changed. The header allows you to avoid MIME type sniffing by saying that the MIME types are deliberately configured. `content_type_options_header` as defined below.
    (Optional) `enabled` - Whether to enable `X-Content-Type-Options` response header. When this setting is `true`, CloudFront adds the `X-Content-Type-Options: nosniff` header to response. (Blocks a request if the request destination is of type style and the MIME type is not text/css, or of type script and the MIME type is not a JavaScript MIME type.) Defaults to `false`.
    (Optional) `override` - Whether CloudFront overrides the `X-Content-Type-Options` response header with the header received from the origin. Defaults to `true`.
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)
  })
  default  = {}
  nullable = false
}

# INFO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
variable "frame_options_header" {
  description = <<EOF
  (Optional) A configuration for `X-Frame-Options` header in HTTP responses sent from CloudFront. The `X-Frame-Options` HTTP response header can be used to indicate whether or not a browser should be allowed to render a page in a `<frame>`, `<iframe>`, `<embed>` or `<object>`. Sites can use this to avoid click-jacking attacks, by ensuring that their content is not embedded into other sites. `frame_options_header` as defined below.
    (Optional) `enabled` - Whether to enable `X-Frame-Options` response header. Defaults to `false`.
    (Optional) `override` - Whether CloudFront overrides the `X-Frame-Options` response header with the header received from the origin. Defaults to `true`.
    (Optional) `value` - The value for the `X-Frame-Options` HTTP response header. Valid values are `DENY` or `SAMEORIGIN`.
      - `DENY`: The page cannot be displayed in a frame, regardless of the site attempting to do
      so.
      - `SAMEORIGIN`: The page can only be displayed if all ancestor frames are same origin to the page itself.
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)
    value    = optional(string, "")
  })
  default  = {}
  nullable = false

  validation {
    condition = (var.frame_options_header.enabled
      ? contains(["DENY", "SAMEORIGIN"], var.frame_options_header.value)
      : true
    )
    error_message = "Valid value for `X-Frame-Options` is `DENY` or `SAMEORIGIN`."
  }
}

# INFO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy
variable "referrer_policy_header" {
  description = <<EOF
  (Optional) A configuration for `Referrer-Policy` header in HTTP responses sent from CloudFront. The `Referrer-Policy` HTTP header controls how much referrer information (sent with the `Referer` header) should be included with requests. Aside from the HTTP header, you can set this policy in HTML. The original header name `Referer` is a misspelling of the word "referrer". The `Referrer-Policy` header does not share this misspelling. `referrer_policy_header` as defined below.
    (Optional) `enabled` - Whether to enable `Referrer-Policy` response header. Defaults to `false`.
    (Optional) `override` - Whether CloudFront overrides the `Referrer-Policy` response header with the header received from the origin. Defaults to `true`.
    (Optional) `value` - The value for the `Referrer-Policy` HTTP response header. Valid values are `no-referrer`, `no-referrer-when-downgrade`, `origin`, `origin-when-cross-origin`, `same-origin`, `strict-origin`, `strict-origin-when-cross-origin`, `unsafe-url`. Defaults to `strict-origin-when-cross-origin`.
    - `strict-origin-when-cross-origin`: Send the origin, path, and querystring when performing a same-origin request. For cross-origin requests send the origin (only) when the protocol security level stays same (HTTPS→HTTPS). Don't send the Referer header to less secure destinations (HTTPS→HTTP).
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)
    value    = optional(string, "strict-origin-when-cross-origin")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["no-referrer", "no-referrer-when-downgrade", "origin", "origin-when-cross-origin", "same-origin", "strict-origin", "strict-origin-when-cross-origin", "unsafe-url"], var.referrer_policy_header.value)
    error_message = "Valid values for `Referrer-Policy` are `no-referrer`, `no-referrer-when-downgrade`, `origin`, `origin-when-cross-origin`, `same-origin`, `strict-origin`, `strict-origin-when-cross-origin` and `unsafe-url`."
  }
}

# INFO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
variable "strict_transport_security_header" {
  description = <<EOF
  (Optional) A configuration for `Strict-Transport-Security` header in HTTP responses sent from CloudFront. The HTTP `Strict-Transport-Security` response header (often abbreviated as HSTS) informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it using HTTP should automatically be converted to HTTPS. Note: This is more secure than simply configuring a HTTP to HTTPS (301) redirect on your server, where the initial HTTP connection is still vulnerable to a man-in-the-middle attack. `strict_transport_security_header` as defined below.
    (Optional) `enabled` - Whether to enable `Strict-Transport-Security` response header. Defaults to `false`.
    (Optional) `override` - Whether CloudFront overrides the `Strict-Transport-Security` response header with the header received from the origin. Defaults to `true`.
    (Optional) `max_age` - The value for the `max-age` directive of this header. The time, in seconds, that the browser should remember that a site is only to be accessed using HTTPS. Defaults to `31536000` (365 days).
    (Optional) `include_subdomains` - Whether CloudFront includes the `includeSubDomains` directive in the value of this header. When this setting is `true`, this rule applies to all of the site's subdomains as well. Defaults to `false`.
    (Optional) `preload` - Whether CloudFront includes the `preload` directive in the header value. However, it is not part of the HSTS specification and should not be treated as official. Defaults to `false`.
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)

    max_age            = optional(number, 60 * 60 * 24 * 365)
    include_subdomains = optional(bool, false)
    preload            = optional(bool, false)
  })
  default  = {}
  nullable = false
}

# INFO: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
variable "xss_protection_header" {
  description = <<EOF
  Non-standard: This feature is non-standard and is not on a standards track. Do not use it on production sites facing the Web: it will not work for every user. There may also be large incompatibilities between implementations and the behavior may change in the future.

  (Optional) A configuration for `X-XSS-Protection` header in HTTP responses sent from CloudFront. The HTTP `X-XSS-Protection` response header is a feature of Internet Explorer, Chrome and Safari that stops pages from loading when they detect reflected cross-site scripting (XSS) attacks. These protections are largely unnecessary in modern browsers when sites implement a strong `Content-Security-Policy` that disables the use of inline JavaScript ('unsafe-inline'). `xss_protection_header` as defined below.
    (Optional) `enabled` - Whether to enable `X-XSS-Protection` response header. Defaults to `false`.
    (Optional) `override` - Whether CloudFront overrides the `X-XSS-Protection` response header with the header received from the origin. Defaults to `true`.
    (Optional) `filtering_enabled` - Whether to enable XSS filtering. The value of `X-XSS-Protection` will be set to `0` (XSS filtering is disabled) or `1` (XSS filtering is enabled). Defaults to `true`.
    (Optional) `block` - Whether to enable `block`, which determines whether CloudFront includes the `mode=block` directive in the header value. Defaults to `false`.
    (Optional) `report` - A reporting URI (in the `report` field), which determines whether CloudFront includes the `report='reporting URI'` directive in the header value. You can't specify a reporting URI when block is enabled.
  EOF
  type = object({
    enabled  = optional(bool, false)
    override = optional(bool, true)

    filtering_enabled = optional(bool, true)
    block             = optional(bool, false)
    report            = optional(string, "")
  })
  default  = {}
  nullable = false

  validation {
    condition     = !(var.xss_protection_header.block && length(var.xss_protection_header.report) > 0)
    error_message = "You can't specify a reporting URI when `block` is enabled."
  }
}

variable "server_timing_header" {
  description = <<EOF
  (Optional) A configuration for `Server-Timing` header in HTTP responses sent from CloudFront. This header can be used to view metrics for insights about CloudFront's behavior and performance. You can see which cache layer served a cache hit, the first byte latency from the origin when there was a cache miss. The metrics in the `Server-Timing` header can help you troubleshoot issues or test the efficiency of the CloudFront configuration. `server_timing_header` as defined below.
    (Optional) `enabled` - Whether to add the `Server-Timing` header in HTTP response that match a cache behavior associated with this response headers policy. Defaults to `false`.
    (Optional) `sampling_rate` - A number from 0 through 100 that specifies the percentage of responses that you want CloudFront to add the `Server-Timing` header to. When you set the sampling rate to `100`, CloudFront adds the `Server-Timing` header to the HTTP response for every request that matches the cache behavior that the response headers policy is attached to. Can have up to four decimal places like `9.9999`.
  EOF
  type = object({
    enabled       = optional(bool, false)
    sampling_rate = optional(number, 0)
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      var.server_timing_header.sampling_rate >= 0,
      var.server_timing_header.sampling_rate <= 100,
    ])
    error_message = "Valid value for `sampling_rate` is between 0 to 100."
  }
}

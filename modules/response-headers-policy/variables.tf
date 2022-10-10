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
  (Optional) A configuraiton for a set of HTTP response headers for CORS(Cross-Origin Resource Sharing). `cors` as defined below.
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
  (Optional) A configuraiton for specifying the custom HTTP headers in HTTP responses sent from CloudFront. Each item of `custom_headers` as defined below.
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

variable "server_timing_header" {
  description = <<EOF
  (Optional) A configuraiton for `Server-Timing` header in HTTP responses sent from CloudFront. This header can be used to view metrics for insights about CloudFront's behavior and performance. You can see which cache layer served a cache hit, the first byte latency from the origin when there was a cache miss. The metrics in the `Server-Timing` header can help you troubleshoot issues or test the efficiency of the CloudFront configuration. `server_timing_header` as defined below.
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

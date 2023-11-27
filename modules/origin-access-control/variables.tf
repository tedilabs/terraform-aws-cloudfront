variable "name" {
  description = "(Required) A name to identify the origin access control."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) A description of the origin access control."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "origin_type" {
  description = "(Optional) The type of origin that this origin access control is for. Valid values are `S3` and `MEDIASTORE`. Defaults to `S3`."
  type        = string
  default     = "S3"
  nullable    = false

  validation {
    condition     = contains(["S3", "MEDIASTORE"], var.origin_type)
    error_message = "Valid values for `origin_type` are `S3` and `MEDIASTORE`."
  }
}

variable "signing_behavior" {
  description = <<EOF
  (Optional) Specify which requests CloudFront signs (adds authentication information to). Valid values are `ALWAYS`, `NEVER`, `NO_OVERRIDE`. Defaults to `ALWAYS`.
    `ALWAYS` - CloudFront signs all origin requests, overwriting the `Authorization` header from the viewer request if one exists.
    `NEVER` - CloudFront doesn't sign any origin requests. This value turns off origin access control for all origins in all distributions that use this origin access control.
    `NO_OVERRIDE` - If the viewer request doesn't contain the `Authorization` header, then CloudFront signs the origin request. If the viewer request contains the Authorization header, then CloudFront doesn't sign the origin request and instead passes along the Authorization header from the viewer request.
  EOF
  type        = string
  default     = "ALWAYS"
  nullable    = false

  validation {
    condition     = contains(["ALWAYS", "NEVER", "NO_OVERRIDE"], var.signing_behavior)
    error_message = "Valid values for `signing_behavior` are `ALWAYS`, `NEVER` and `NO_OVERRIDE`."
  }
}

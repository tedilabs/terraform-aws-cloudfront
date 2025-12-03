variable "name" {
  description = "(Required) The name of the CloudFront VPC Origin."
  type        = string
  nullable    = false
}

variable "endpoint" {
  description = "(Required) The ARN of the VPC origin endpoint to associate with the CloudFront VPC Origin. The VPC origin endpoint must be an Application Load Balancer (ALB), Network Load Balancer (NLB), or EC2 instance in the same AWS Region as the CloudFront distribution."
  type        = string
  nullable    = false
}

variable "protocol_policy" {
  description = "(Optional) The origin protocol policy for the CloudFront VPC origin endpoint configuration. The origin protocol policy determines the protocol (HTTP or HTTPS) that you want CloudFront to use when connecting to the origin. Valid values are `HTTP_ONLY`, `HTTPS_ONLY` or `MATCH_VIEWER`. Defaults to `MATCH_VIEWER`."
  type        = string
  default     = "MATCH_VIEWER"
  nullable    = false

  validation {
    condition     = contains(["HTTP_ONLY", "HTTPS_ONLY", "MATCH_VIEWER"], var.protocol_policy)
    error_message = "Valid values for `protocol_policy` are `HTTP_ONLY`, `HTTPS_ONLY` or `MATCH_VIEWER`."
  }
}

variable "ssl_security_policy" {
  description = "(Optional) The minimum SSL protocol that CloudFront uses with the origin. Valid values are `SSLv3`, `TLSv1`, `TLSv1.1` or `TLSv1.2`. Defaults to `TLSv1.2`."
  type        = string
  default     = "TLSv1.2"
  nullable    = false

  validation {
    condition     = contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], var.ssl_security_policy)
    error_message = "Valid values for `ssl_security_policy` are `SSLv3`, `TLSv1`, `TLSv1.1` or `TLSv1.2`."
  }
}

variable "http_port" {
  description = "(Optional) The HTTP port for the CloudFront VPC origin endpoint configuration. Defaults to `80`."
  type        = number
  default     = 80
  nullable    = false
}

variable "https_port" {
  description = "(Optional) The HTTPS port for the CloudFront VPC origin endpoint configuration. Defaults to `443`."
  type        = number
  default     = 443
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


###################################################
# Resource Sharing by RAM (Resource Access Manager)
###################################################

variable "shares" {
  description = "(Optional) A list of resource shares via RAM (Resource Access Manager)."
  type = list(object({
    name = optional(string)

    permissions = optional(set(string), ["AWSRAMDefaultPermissionCloudfrontVpcOrigin"])

    external_principals_allowed = optional(bool, false)
    principals                  = optional(set(string), [])

    tags = optional(map(string), {})
  }))
  default  = []
  nullable = false
}

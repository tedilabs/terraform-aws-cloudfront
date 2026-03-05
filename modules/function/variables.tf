variable "name" {
  description = "(Required) A unique name for the CloudFront Function."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) A comment to describe the CloudFront Function. Defaults to `Managed by Terraform.`."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "type" {
  description = "(Optional) The type of CloudFront Function to create. Valid values are `GENERAL` and `CONNECTION`. Defaults to `GENERAL`."
  type        = string
  default     = "GENERAL"
  nullable    = false

  validation {
    condition     = contains(["GENERAL", "CONNECTION"], var.type)
    error_message = "Valid values for `type` are `GENERAL` and `CONNECTION`."
  }
}

variable "runtime" {
  description = "(Required) The identifier of the function's runtime. Valid values are `cloudfront-js-1.0` and `cloudfront-js-2.0`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["cloudfront-js-1.0", "cloudfront-js-2.0"], var.runtime)
    error_message = "Valid values for `runtime` are `cloudfront-js-1.0` and `cloudfront-js-2.0`."
  }
}

variable "code" {
  description = "(Required) The source code of the function. Maximum length is 40960 characters for CONNECTION functions."
  type        = string
  nullable    = false
}

variable "publish" {
  description = "(Optional) Whether to publish the function to the LIVE stage after creation or update. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "key_value_store" {
  description = "(Optional) The ARN of CloudFront Key Value Store to associate with the function. AWS limits associations to one key value store per function."
  type        = string
  default     = null
  nullable    = true
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

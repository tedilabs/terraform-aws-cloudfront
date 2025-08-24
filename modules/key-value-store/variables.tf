variable "name" {
  description = "(Required) Unique name of the CloudFront Key-Value Store."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the CloudFront Key-Value Store."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "exclusive" {
  description = "(Optional) Whether to manage all keys exclusively. If `true`, all keys not defined in the `keys` variable will be removed from the key-value store. If `false`, keys are managed individually and can coexist with keys managed outside of Terraform. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "items" {
  description = "(Optional) A map of key-value pairs to store in the CloudFront Key-Value Store. The key is the key name and the value is the value to store. Defaults to `{}`."
  type        = any
  default     = {}
  nullable    = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the CloudFront Key-Value Store to be created."
  type = object({
    create = optional(string, "30m")
  })
  default  = {}
  nullable = false
}

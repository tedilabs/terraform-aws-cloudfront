variable "name" {
  description = "(Required) Desired name for the CloudFront key group."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) The comment for the CloudFront key group. Defaults to `Managed by Terraform.`."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "public_keys" {
  description = <<EOF
  (Required) A list of public keys to create and associate with the key group. Each block of `public_keys` as defined below.
    (Required) `name` - A name to identify the public key.
    (Optional) `description` - A comment to describe the public key. Defaults to `Managed by Terraform.`.
    (Required) `public_key` - The encoded public key that you want to add to CloudFront to use with features like field-level encryption.
  EOF
  type = list(object({
    name        = string
    description = optional(string, "Managed by Terraform.")
    public_key  = string
  }))
  nullable = false

  validation {
    condition     = length(var.public_keys) > 0
    error_message = "At least one public key is required for a key group."
  }

  validation {
    condition     = length(var.public_keys) == length(distinct(var.public_keys[*].name))
    error_message = "Each public key must have a unique `name`."
  }
}

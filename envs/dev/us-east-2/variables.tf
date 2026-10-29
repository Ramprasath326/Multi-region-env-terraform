variable "aws_account_id" {
  description = "The only AWS account Terraform may run against."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "env" {
  description = "Environment name."
  type        = string
}

variable "cidr_block" {
  type = string
}

variable "az_count" {
  type    = number
  default = 2
}

variable "nat_mode" {
  type    = string
  default = "none"
}
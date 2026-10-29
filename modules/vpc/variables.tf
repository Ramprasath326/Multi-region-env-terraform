variable "name" {
  description = "Name prefix for all resources, for example dev-use2."
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR. Must not overlap with any other env or region."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid IPv4 CIDR, for example 10.10.0.0/16."
  }
}

variable "az_count" {
  description = "Number of availability zones to use."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3."
  }
}

variable "tags" {
  description = "Extra tags merged onto every resource."
  type        = map(string)
  default     = {}
}

variable "nat_mode" {
  description = "none, single (one shared NAT) or per_az (one NAT per AZ)."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "single", "per_az"], var.nat_mode)
    error_message = "nat_mode must be none, single or per_az."
  }
}

variable "enable_s3_endpoint" {
  description = "Create a free S3 gateway endpoint on the private route tables."
  type        = bool
  default     = true
}
variable "name" {
  description = "Name prefix, for example dev-use2. Max 25 characters."
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  description = "VPC CIDR. The ALB may only send traffic to targets inside it."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets in at least two AZs."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "An ALB needs public subnets in at least two availability zones."
  }
}

variable "target_port" {
  description = "Port the targets listen on."
  type        = number
  default     = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to reach the listener on port 80."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "deletion_protection" {
  description = "Block deletion of the ALB. Enable in prod."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

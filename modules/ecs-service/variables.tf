variable "name" {
  description = "Name prefix, for example dev-use2. Includes the region because IAM names are account-wide."
  type        = string
}

variable "region" {
  description = "Region for the log driver."
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets for the tasks. Private subnets in normal use."
  type        = list(string)
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "container_image" {
  description = "Full image reference. Prefer an immutable tag."
  type        = string
}

variable "container_port" {
  type    = number
  default = 80
}

variable "cpu" {
  type    = number
  default = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "cpu must be 256, 512, 1024, 2048 or 4096."
  }
}

variable "memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "environment_variables" {
  description = "Plain environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Map of env var name to Secrets Manager or SSM ARN, injected at start."
  type        = map(string)
  default     = {}
}

variable "attach_to_alb" {
  description = "Known at plan time. true registers the service with the target group."
  type        = bool
  default     = false
}

variable "target_group_arn" {
  type    = string
  default = null
}

variable "alb_security_group_id" {
  type    = string
  default = null
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}

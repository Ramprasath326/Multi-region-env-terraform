variable "aws_region" {
  description = "Region where bootstrap files and state bucket live"
  type        = string
  default     = "us-east-2"
}

variable "aws_account_id" {
  description = "AWS account ID where terraform run against"
  type        = string

  validation {
    condition     = length(var.aws_account_id) == 12
    error_message = "AWS account ID must be 12 digits long."
  }
}
variable "project" {
  description = "Project name to use for naming resources"
  type        = string
  default     = "multi-region-env"
}

#variable for state bucket

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
  default     = "ramprasath326-multi-region-tfstate-use2"
}
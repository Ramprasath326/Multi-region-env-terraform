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

#variables for OIDC authentications

variable "github_owner" {
  description = "GitHub user or org that owns the repo."
  type        = string
  default     = "Ramprasath326"
}

variable "github_repo" {
  description = "Repository allowed to assume the roles."
  type        = string
  default     = "Multi-region-env-terraform"
}

variable "environments" {
  description = "Environments that get an apply role."
  type        = set(string)
  default     = ["dev", "stage", "prod"]
}

#adding github repo and user IDs
variable "github_owner_id" {
  description = "Immutable GitHub user ID of the repo owner."
  type        = string
  default     = "164841396"
}

variable "github_repo_id" {
  description = "Immutable GitHub repository ID."
  type        = string
  default     = "1408922232"
}
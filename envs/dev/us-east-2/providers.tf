provider "aws" {
  region              = "us-east-2"
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      Project     = "multi-region-env"
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }
}
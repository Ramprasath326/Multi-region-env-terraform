terraform {
  backend "s3" {
    bucket       = "ramprasath326-multi-region-tfstate-use2"
    key          = "bootstrap/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
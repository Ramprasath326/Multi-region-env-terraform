module "vpc" {
  source = "../../../modules/vpc"

  name       = "${var.env}-use2"
  cidr_block = var.cidr_block
  az_count   = var.az_count
  nat_mode   = var.nat_mode
}
module "ecr" {
  source = "../../../modules/ecr"

  name         = "${var.env}-app"
  force_delete = var.env != "prod"
}

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

module "alb" {
  count  = var.enable_alb ? 1 : 0
  source = "../../../modules/alb"

  name                = "${var.env}-use2"
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.cidr_block
  public_subnet_ids   = values(module.vpc.public_subnet_ids)
  deletion_protection = var.env == "prod"
}

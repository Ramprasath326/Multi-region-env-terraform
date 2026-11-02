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

data "aws_region" "current" {}

# The secret container is managed here. Its VALUE is set out-of-band, because the
# read-only plan role must never be able to read secret values.
resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.env}/app/secret-key"
  recovery_window_in_days = var.env == "prod" ? 30 : 0
}

module "ecs_service" {
  count  = var.enable_service ? 1 : 0
  source = "../../../modules/ecs-service"

  name                  = "${var.env}-use2"
  region                = data.aws_region.current.name
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = values(module.vpc.private_subnet_ids)
  container_image       = var.container_image
  attach_to_alb         = var.enable_alb
  target_group_arn      = one(module.alb[*].target_group_arn)
  alb_security_group_id = one(module.alb[*].security_group_id)
  secrets               = { APP_SECRET = aws_secretsmanager_secret.app.arn }

  # NAT and routes first, and the listener before the service registers
  depends_on = [module.vpc, module.alb]
}

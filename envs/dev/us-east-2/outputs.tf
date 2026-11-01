output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "alb_dns_name" {
  value = one(module.alb[*].dns_name)
}

output "ecs_cluster_name" {
  value = one(module.ecs_service[*].cluster_name)
}

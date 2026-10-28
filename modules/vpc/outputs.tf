output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = { for az, s in aws_subnet.public : az => s.id }
}

output "private_subnet_ids" {
  value = { for az, s in aws_subnet.private : az => s.id }
}

output "private_route_table_ids" {
  value = { for az, rt in aws_route_table.private : az => rt.id }
}

output "azs" {
  value = local.azs
}
output "state_bucket_name" {
  value = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  value = aws_s3_bucket.state.arn
}


output "plan_role_arn" {
  value = aws_iam_role.plan.arn
}

output "apply_role_arns" {
  value = { for env, r in aws_iam_role.apply : env => r.arn }
}
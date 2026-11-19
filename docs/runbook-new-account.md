# Runbook: rebuild in a new AWS account

1. Console: root MFA, IAM user with MFA and one access key, a monthly budget and cost anomaly detection.
2. CLI: `aws configure --profile practice`, then `export AWS_PROFILE=practice` and `export TF_VAR_aws_account_id=<id>`.
3. Pick a new, globally unique state bucket name. Update `bootstrap/variables.tf`, `bootstrap/backend.tf` and every `envs/*/*/backend.tf`.
4. Bootstrap: delete `.terraform` and local state, move `backend.tf` aside, then `init`, `plan` and `apply`. Restore `backend.tf` and run `init -migrate-state`.
5. GitHub: update the `AWS_ACCOUNT_ID` repository variable. Environments (`dev`, `stage`, `prod`) are unchanged.
6. Once: `aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com`.
7. Open a PR. The plan runs with the new plan role. Merge it to apply the base dev infrastructure.
8. Before enabling the service in an environment, set the secret value: `aws secretsmanager put-secret-value --secret-id <env>/app/secret-key --secret-string <value>`.

Gotchas: closed accounts may keep an S3 bucket name reserved for a while. Check that dev.tfvars has every expensive toggle off before the first apply. Never merge before bootstrap is applied.

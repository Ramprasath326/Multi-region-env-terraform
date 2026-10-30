## 001 Directories per env/region, not workspaces
Why: separate state and blast radius.

## 002 Ohio + Oregon
Why: clean slate vs. the old project, real DR geography.

## 003 Public repo + OIDC
Why: free branch protection and environments; no stored credentials.

## 004 Shared GitHub OIDC provider
Why: AWS allows only one GitHub OIDC provider per account, and the old ECS project already created it. This repo reads it through a data source and never manages it.
Trade-off: if the old project is destroyed, the provider disappears and the roles here stop working until it is recreated.

## 005 Trust policies pin immutable GitHub IDs
Why: the OIDC `sub` claim contains GitHub's numeric owner and repo IDs, not just the names. Names can be reused after a rename or delete (repo-jacking), while IDs cannot. Found by reading the claim in a CloudTrail AssumeRoleWithWebIdentity event after the first role assumption failed.

## 006 Apply roles use AdministratorAccess (practice shortcut)
Why: one AWS account, so scoped per-env policies are not worth the time yet. Separation comes from GitHub Environments (main branch only, reviewer on prod).
Trade-off: the dev role could technically change prod. Production setups use separate accounts per environment and scoped policies. Revisit on Day 18.

## 007 Environments restricted to the main branch
Why: the OIDC subject for an environment job does not include the branch, so AWS cannot tell main from a feature branch. GitHub enforces the branch rule instead, which means only reviewed, merged code can reach the apply roles.

## 008 Non-overlapping CIDRs per env and region
dev 10.10.0.0/16, stage 10.20.0.0/16, prod Ohio 10.30.0.0/16, prod Oregon 10.31.0.0/16.
Why: peering or a transit gateway stays possible later without re-addressing anything.

## 009 NAT mode is an input, chosen per environment
dev none or single, stage single, prod per_az, validated in the module.
Trade-off: one shared NAT is cheap, but an AZ failure cuts egress for every private subnet. One NAT per AZ costs more and survives it. A free S3 gateway endpoint keeps S3 traffic off the NAT.

## 010 Known limits of the PR pipeline
Checkov is report-only for now and gets triaged later. Dependabot PRs skip the plan, because they cannot assume the AWS role, so provider bumps are planned locally before merging. Plan comments are public on a public repo, so account IDs are replaced before posting and secrets must never appear in resource names or outputs.

## 011 One required check, no path filter on the trigger
The workflow runs on every PR and a final gate job fails if any job failed. Skipped plan jobs count as passing.
Why: a required check that is skipped never reports, which would block docs-only PRs forever.

## 012 GitHub Actions pinned to commit SHAs
Tags can be moved by whoever controls an action's repo, a commit SHA cannot. The tag is kept in a comment for readability. Updates come through Dependabot.
Trade-off: version bumps need a reviewed PR instead of happening silently.

## 013 Lint locally and in CI, Checkov in CI only
pre-commit runs fmt, tflint and gitleaks on every commit for fast feedback. CI repeats the checks as the enforcement point, because local hooks can be skipped.
Why Checkov stays CI-only: it is slower to install and noisy on a practice account, so it is not worth blocking commits on.

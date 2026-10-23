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

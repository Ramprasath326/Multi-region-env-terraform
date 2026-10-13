data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}


locals {
  oidc_provider_arn = data.aws_iam_openid_connect_provider.github.arn
  repo_sub          = "repo:${var.github_owner}/${var.github_repo}"
}

# Plan role: assumable only by pull-request runs, read-only
data "aws_iam_policy_document" "plan_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["${local.repo_sub}:pull_request"]
    }
  }
}

resource "aws_iam_role" "plan" {
  name               = "gha-tf-plan"
  assume_role_policy = data.aws_iam_policy_document.plan_trust.json
}
resource "aws_iam_role_policy_attachment" "plan_readonly" {
  role       = aws_iam_role.plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# plan takes a state lock, which is a write to *.tflock objects only
data "aws_iam_policy_document" "plan_lock" {
  statement {
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.state.arn}/*.tflock"]
  }
}
resource "aws_iam_role_policy" "plan_lock" {
  name   = "state-lock"
  role   = aws_iam_role.plan.id
  policy = data.aws_iam_policy_document.plan_lock.json
}

# Apply roles: one per environment, assumable only through that GitHub Environment
data "aws_iam_policy_document" "apply_trust" {
  for_each = var.environments

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["${local.repo_sub}:environment:${each.key}"]
    }
  }
}
resource "aws_iam_role" "apply" {
  for_each           = var.environments
  name               = "gha-tf-apply-${each.key}"
  assume_role_policy = data.aws_iam_policy_document.apply_trust[each.key].json
}

resource "aws_iam_role_policy_attachment" "apply_admin" {
  for_each   = var.environments
  role       = aws_iam_role.apply[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

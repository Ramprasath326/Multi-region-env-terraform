# GitHub's OIDC identity provider for this AWS account.
# AWS allows only one per account, and this account has none yet, so bootstrap owns it.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_secretsmanager_secret" "example" {
  name        = "example_secret"
  description = "This is an example secret."
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    username = ""
    password = ""
  })
}

# data "aws_iam_policy_document" "readonly_secret" {
#   statement {
#     actions = [
#       "secretsmanager:GetSecretValue",
#       "secretsmanager:DescribeSecret"
#     ]

#     resources = [
#       aws_secretsmanager_secret.example.arn
#     ]

#     principals {
#       identifiers = ["AWS_Account_ID"]
#       type        = "AWS"
#     }
#   }
# }

# resource "aws_secretsmanager_secret_policy" "example" {
#   secret_arn = aws_secretsmanager_secret.example.arn
#   policy     = data.aws_iam_policy_document.readonly_secret.json
# }

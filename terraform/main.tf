provider "aws" {
  region                      = "us-east-1"
  access_key                  = "fake"
  secret_key                  = "fake"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    kinesis  = "http://localhost:4566"
    iam      = "http://localhost:4566"
  }
}


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.prefix}.localhost.localstack.cloud"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "instance" {
  name               = "${var.prefix}-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_group" "sre" {
  name = "${var.prefix}-group"
}

resource "aws_iam_group_policy" "sre-group-policy" {
  name   = "${var.prefix}-group-policy"
  group  = aws_iam_group.sre.name
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_user" "user" {
  name = "${var.prefix}-user"
}

resource "aws_iam_user_group_membership" "user_name" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.sre.name,
  ]
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]

    }
  }
}
data "aws_iam_policy_document" "cw_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.main.arn]
  }
}
data "aws_iam_policy_document" "task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_s3_bucket_object" "lambda_dotnet_function" {
  bucket = var.lambda_s3_bucket
  key    = local.lambda_s3_key_dotnet_function
}
data "aws_s3_bucket_object" "lambda_dotnet" {
  bucket = var.lambda_s3_bucket
  key    = local.lambda_s3_key_dotnet
}
data "aws_s3_bucket_object" "lambda_nodejs" {
  bucket = var.lambda_s3_bucket
  key    = local.lambda_s3_key_nodejs
}
data "aws_s3_bucket_object" "lambda_python" {
  bucket = var.lambda_s3_bucket
  key    = local.lambda_s3_key_python
}

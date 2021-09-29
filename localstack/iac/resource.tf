# Data source to zip the python function file
data "archive_file" "ping_pong_file_archive" {
  type        = "zip"
  source_file = "./sample.py"
  output_path = "./sample.zip"
}

# Creating a bucket in s3 for uploading zip file
resource "aws_s3_bucket" "zip_file_bucket" {
  bucket = "sample-filebucket-terraform"
  acl    = "private"
}

# Uploading zip file to s3 bucket
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.zip_file_bucket.id
  key    = "sample.zip"
  source = data.archive_file.ping_pong_file_archive.output_path
}

# Creating a IAM Role for lambda for lambda function
resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/*
Creating a lambda function named ping_pong with s3 
location as file source which has the function's 
deployments package

This resource is dependent on  aws_s3_bucket_object
*/
resource "aws_lambda_function" "ping_pong" {
  s3_bucket     = aws_s3_bucket.zip_file_bucket.id
  s3_key        = aws_s3_bucket_object.object.key
  function_name = "ping_pong"
  role          = aws_iam_role.iam_for_lambda_tf.arn
  handler       = "sample.ping_pong"

  runtime = "python3.8"

  depends_on = [
    data.archive_file.ping_pong_file_archive,
    aws_s3_bucket_object.object
  ]

}

# Creating a REST API GATEWAY 
resource "aws_api_gateway_rest_api" "api" {
  name        = "myapi"
  description = "Terraform Serverless Application Example"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Creating api gateway resource
resource "aws_api_gateway_resource" "get_resource" {
  path_part   = "get_resource"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# Creating method for api gateway resource
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.get_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Creating integration with api gateway and lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.get_resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = aws_lambda_function.ping_pong.invoke_arn
}

# Deploying the rest api 
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test"

}


# Setting invoke permisison for rest api to invoke lambda function
resource "aws_lambda_permission" "apigw_lambda_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ping_pong.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

output "url" {
  value = "${var.host}/restapis/${aws_api_gateway_rest_api.api.id}/${aws_api_gateway_deployment.api_deployment.stage_name}/_user_request_/${aws_api_gateway_resource.get_resource.path_part}"
}

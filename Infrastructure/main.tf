terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {

  region = "us-east-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
# DynamoDB Table
resource "aws_dynamodb_table" "visitor_count_ddb" {
  name         = "VisitorsTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "visitors"
    type = "N"
  }

  global_secondary_index {
    name            = "visitors_count"
    hash_key        = "visitors"
    projection_type = "ALL"
    read_capacity   = 1
    write_capacity  = 1
  }

  tags = {
    Name = "Cloud Resume Challenge"
  }
}

# DynamoDB Table Item
resource "aws_dynamodb_table_item" "visitor_count_ddb" {
  table_name = aws_dynamodb_table.visitor_count_ddb.name
  hash_key   = aws_dynamodb_table.visitor_count_ddb.hash_key

  item = <<ITEM
{
  "id": {"S": "visitor_count"},
  "visitors": {"N": "1"}
}
ITEM
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "aws_resume_lamnbda_role"
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

# IAM Policy for Lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "iam_policy_for_aws_resume_lamnbda_role"
  path        = "/"
  description = "AWS IAM Policy for aws lambda to access dynamodb"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "dynamodb:BatchGetItem",
       "dynamodb:GetItem",
       "dynamodb:Query",
       "dynamodb:Scan",
       "dynamodb:BatchWriteItem",
       "dynamodb:PutItem",
       "dynamodb:UpdateItem"
     ],
     "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*" 
   },
   {
     "Effect": "Allow",
     "Action": [
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*" 
   },
   {
     "Effect": "Allow",
     "Action": "logs:CreateLogGroup",
     "Resource": "*"
   }
 ]
}
EOF
}

# Attach IAM Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Archive Lambda Python Code
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

# Lambda Function
resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "lambda_function_payload.zip"
  function_name = "VistorCounter"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  environment {
    variables = {
      databaseName = "VisitorsTable"
    }
  }
}

# API Gateway Configuration
resource "aws_apigatewayv2_api" "visitor_counter_api" {
  name          = "visitor_counter_http_api"
  protocol_type = "HTTP"
  description   = "Visitor counter HTTP API to invoke AWS Lambda function to update & retrieve the visitors count"
  cors_configuration {
    allow_credentials = false
    allow_headers     = []
    allow_methods     = ["GET", "OPTIONS", "POST"]
    allow_origins     = ["*"]
    expose_headers    = []
    max_age           = 0
  }
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.visitor_counter_api.id
  name        = "default"
  auto_deploy = true
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "visitor_counter_api_integration" {
  api_id             = aws_apigatewayv2_api.visitor_counter_api.id
  integration_uri    = aws_lambda_function.terraform_lambda_func.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# API Gateway Route
resource "aws_apigatewayv2_route" "any" {
  api_id    = aws_apigatewayv2_api.visitor_counter_api.id
  route_key = "ANY /VisitorCounter"
  target    = "integrations/${aws_apigatewayv2_integration.visitor_counter_api_integration.id}"
}

# API Gateway Lambda Invocation Permission
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitor_counter_api.execution_arn}/*/*"
}

output "base_url" {
  value = "${aws_apigatewayv2_stage.default.invoke_url}/VisitorCounter"
}

# S3 Bucket for Static Website Hosting
# S3 Bucket Configuration for Static Website Hosting
resource "aws_s3_bucket" "resumeexample" {
  bucket = "prudhvikeshav-cloudresume.info"
  tags = {
    Name = "My S3 bucket for static site"
  }
}

# Block Public Access to ensure policies can be applied
# Block Public Access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "resumeexample" {
  bucket                  = aws_s3_bucket.resumeexample.id
  block_public_acls       = false # Allow public ACLs (necessary for static hosting)
  block_public_policy     = false # Allow public bucket policies
  ignore_public_acls      = false # Do not ignore public ACLs
  restrict_public_buckets = false # Allow public buckets
}

# S3 Bucket Policy: Allows public access to objects and required actions (e.g., PutBucketAcl, PutBucketPolicy)
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.resumeexample.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.resumeexample.arn}/*"
      },
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:PutBucketAcl",
          "s3:PutBucketPolicy"
        ]
        Resource = [
          "arn:aws:s3:::prudhvikeshav-cloudresume.info",
          "arn:aws:s3:::prudhvikeshav-cloudresume.info/*"
        ]
      }
    ]
  })
}


# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "resumeexample" {
  bucket = aws_s3_bucket.resumeexample.id
  index_document {
    suffix = "index.html"
  }
}

# S3 Bucket ACL for Public Read Access
resource "aws_s3_bucket_acl" "public_read_acl" {
  bucket = aws_s3_bucket.resumeexample.id
  acl    = "public-read"
}

# S3 Bucket Ownership Controls (ensure proper ownership)
resource "aws_s3_bucket_ownership_controls" "resumeexample" {
  bucket = aws_s3_bucket.resumeexample.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.resumeexample.bucket
}


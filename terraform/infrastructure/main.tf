provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "merge_function" {
  function_name = "merge-homeless-data"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "${path.module}/lambda_function.zip"

  environment {
    variables = {
      S3_BUCKET_NAME = "friday-ugbebor-datasets"
    }
  }

  tags = {
    Name = "Merge Function"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_s3_bucket" "datasets" {
  bucket = "friday-ugbebor-datasets"

  tags = {
    Name = "Dataset Bucket"
  }
}

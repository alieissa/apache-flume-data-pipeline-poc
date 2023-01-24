resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = var.function.path
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "detect-ingest-event" {
  runtime       = "nodejs18.x"
  function_name = var.function.name
  filename      = data.archive_file.lambda.output_path
  handler       = var.function.handler

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "allow_bucket_access" {
  statement_id  = "AllowExecutionFromS3Bucket1"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket.arn
  function_name = aws_lambda_function.detect-ingest-event.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket.name

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.detect-ingest-event.arn
  }
}
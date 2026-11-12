
# Package the Python upload function into a ZIP file
data "archive_file" "upload" {
  type        = "zip"
  source_file = "${path.module}/../backend/upload/handler.py"
  output_path = "${path.module}/lambda_upload.zip"
}

# Create a CloudWatch log group
resource "aws_cloudwatch_log_group" "upload" {
  name              = "/aws/lambda/lorekeeper-dev-upload"
  retention_in_days = 7
}

# Create the AWS Lambda function
resource "aws_lambda_function" "upload" {
  function_name = "lorekeeper-dev-upload"
  description   = "Generates temporary S3 upload authorisations"

  filename         = data.archive_file.upload.output_path
  source_code_hash = data.archive_file.upload.output_base64sha256

  role    = aws_iam_role.upload_lambda.arn
  handler = "handler.lambda_handler"
  runtime = "python3.12"

  memory_size = 128
  timeout     = 10

  environment {
    variables = {
      DOCUMENT_BUCKET = aws_s3_bucket.documents.bucket
    }
  }

  depends_on = [
    aws_iam_role_policy.upload_permissions,
    aws_iam_role_policy_attachment.upload_logs,
    aws_cloudwatch_log_group.upload
  ]
}

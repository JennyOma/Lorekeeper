
# LoreKeeper - Lambda execution role

# 1. Allow AWS Lambda to assume this role
resource "aws_iam_role" "upload_lambda" {
  name = "lorekeeper-dev-upload-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 2. Allow uploading objects only to the uploads/ prefix
resource "aws_iam_role_policy" "upload_permissions" {
  name = "lorekeeper-dev-upload-permissions"
  role = aws_iam_role.upload_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.documents.arn}/uploads/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.documents.arn
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.eu-west-2.amazonaws.com"
          }
        }
      }
    ]
  })
}

# 3. Allow Lambda to write technical CloudWatch logs
resource "aws_iam_role_policy_attachment" "upload_logs" {
  role       = aws_iam_role.upload_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

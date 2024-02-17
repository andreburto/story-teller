data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/"
  output_path = "${path.module}/index.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  filename      = data.archive_file.zip.output_path
  handler       = "index.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda.arn

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.table.name
      LAMBDA_NAME    = var.function_name
      OPEN_API_KEY   = aws_ssm_parameter.openai_api_key.name
    }
  }

  depends_on = [
    aws_iam_role.lambda,
    aws_cloudwatch_log_group.lambda,
  ]
}

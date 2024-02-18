resource "aws_lambda_function" "lambda" {
  filename      = var.function_file
  function_name = var.function_name
  handler       = "index.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda.arn
  timeout       = 600 # 10 minutes, OpenAI can take a few minutes to respond.

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.table.name
      EMAIL_KEY      = aws_ssm_parameter.email_address.name
      LAMBDA_NAME    = var.function_name
      OPEN_API_KEY   = aws_ssm_parameter.openai_api_key.name
    }
  }

  depends_on = [
    aws_iam_role.lambda,
    aws_cloudwatch_log_group.lambda,
  ]
}

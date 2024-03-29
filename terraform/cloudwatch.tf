# Logs
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 1
}

# EventBridge
resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "${var.function_name}-lambda-event-rule"
  description         = "Run the function every 24 hours."
  schedule_expression = "rate(24 hours)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  arn  = aws_lambda_function.lambda.arn
  rule = aws_cloudwatch_event_rule.lambda.name
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda.arn
}

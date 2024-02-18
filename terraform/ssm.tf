resource "aws_ssm_parameter" "email_address" {
  name  = "/${var.function_name}/email_address"
  type  = "SecureString"
  value = var.email_address
}

resource "aws_ssm_parameter" "openai_api_key" {
  name  = "/${var.function_name}/openai_api_key"
  type  = "SecureString"
  value = var.openai_api_key
}

resource "aws_ssm_parameter" "prompt_key" {
  name  = "/${var.function_name}/prompt_key"
  type  = "SecureString"
  value = var.prompt_key
}

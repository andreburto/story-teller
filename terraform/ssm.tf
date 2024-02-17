resource "aws_ssm_parameter" "openai_api_key" {
  name  = "/${var.function_name}/openai_api_key"
  type  = "SecureString"
  value = var.openai_api_key
}

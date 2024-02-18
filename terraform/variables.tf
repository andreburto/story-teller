variable "email_address" {
  type = string
}

variable "function_file" {
  type    = string
  default = "index.zip"
}

variable "function_name" {
  type    = string
  default = "story-teller"
}

variable "openai_api_key" {
  type = string
}

variable "prompt_key" {
  type = string
}

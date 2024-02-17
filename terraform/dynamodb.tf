resource "aws_dynamodb_table" "table" {
  name           = "${var.function_name}-table"
  hash_key       = "UUID"
  range_key      = "Character"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "UUID"
    type = "S"
  }

  attribute {
    name = "Character"
    type = "S"
  }
}
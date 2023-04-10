resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "student"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "dynamodb-student"
  }
}
# Creating DynamoDB table
resource "aws_dynamodb_table" "books_table" {
  name           = local.dynamodb_name
  billing_mode   = "PROVISIONED"
  hash_key       = "book_id"
  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "book_id"
    type = "S"
  }

  tags = {
    Name        = "BooksTable"
    Environment = "Production"
  }
}

# Creating DynamoDB table items
resource "aws_dynamodb_table_item" "books" {
    for_each =  local.books
    table_name = aws_dynamodb_table.books_table.name
    hash_key = aws_dynamodb_table.books_table.hash_key
    item = jsonencode(each.value)
  
}
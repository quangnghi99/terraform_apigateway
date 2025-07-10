locals {
    environment = "staging"
    api_gateway_stage = "prod"
    api_gateway_name = "book_api_gateway"
    api_gateway_endpoint_type = "REGIONAL"
    lambda_function_name = "my_lambda_function"
    lambda_function_runtime = "python3.12"
    dynamodb_name = "Books_Table"
    json_data = file("${path.module}/books.json")
    books     = jsondecode(local.json_data)
}
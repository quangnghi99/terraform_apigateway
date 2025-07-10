# API gateway
resource "aws_api_gateway_rest_api" "book_api_gateway" {
  name        = local.api_gateway_name
  description = "API Gateway for managing books"
  endpoint_configuration {
    types = [local.api_gateway_endpoint_type]
  }
}

# API resource for the path "/book"
resource "aws_api_gateway_resource" "api-book" {
  rest_api_id = aws_api_gateway_rest_api.book_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.book_api_gateway.root_resource_id
  path_part   = "book"
  
}

# API resource for the path "/books"
resource "aws_api_gateway_resource" "api-books" {
  rest_api_id = aws_api_gateway_rest_api.book_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.book_api_gateway.root_resource_id
  path_part   = "books"
  
}

## GET /book/{bookId}
resource "aws_api_gateway_method" "get_one_method" {
  rest_api_id   = aws_api_gateway_rest_api.book_api_gateway.id
  resource_id   = aws_api_gateway_resource.api-book.id
  http_method   = "GET"
  authorization = "NONE"
  
}

resource "aws_api_gateway_integration" "get_one_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.book_api_gateway.id
  resource_id             = aws_api_gateway_resource.api-book.id
  http_method             = aws_api_gateway_method.get_one_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.book_lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "get_one_method_response" {
  rest_api_id = aws_api_gateway_rest_api.book_api_gateway.id
  resource_id = aws_api_gateway_resource.api-book.id
  http_method = aws_api_gateway_method.get_one_method.http_method
  status_code = "200"

    response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}
resource "aws_api_gateway_integration_response" "GET_one_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.GET_one_method.http_method
  status_code = aws_api_gateway_method_response.GET_one_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.GET_one_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": $input.path('$.statusCode'),
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

################################################################################
## GET ALL /books 
################################################################################

resource "aws_api_gateway_method" "GET_all_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gateway.id
  resource_id   = aws_api_gateway_resource.API-resource-books.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "GET_all_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gateway.id
  resource_id             = aws_api_gateway_resource.API-resource-books.id
  http_method             = aws_api_gateway_method.GET_all_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.book_lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "GET_all_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-books.id
  http_method = aws_api_gateway_method.GET_all_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "GET_all_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-books.id
  http_method = aws_api_gateway_method.GET_all_method.http_method
  status_code = aws_api_gateway_method_response.GET_all_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.GET_all_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

################################################################################
## POST /book
################################################################################

resource "aws_api_gateway_method" "POST_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gateway.id
  resource_id   = aws_api_gateway_resource.API-resource-book.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "POST_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gateway.id
  resource_id             = aws_api_gateway_resource.API-resource-book.id
  http_method             = aws_api_gateway_method.POST_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.book_lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "POST_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.POST_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "POST_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.POST_method.http_method
  status_code = aws_api_gateway_method_response.POST_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.POST_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

################################################################################
## PATCH /book
################################################################################

resource "aws_api_gateway_method" "PATCH_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gateway.id
  resource_id   = aws_api_gateway_resource.API-resource-book.id
  http_method   = "PATCH"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "PATCH_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gateway.id
  resource_id             = aws_api_gateway_resource.API-resource-book.id
  http_method             = aws_api_gateway_method.PATCH_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.book_lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "PATCH_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.PATCH_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "PATCH_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.PATCH_method.http_method
  status_code = aws_api_gateway_method_response.PATCH_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.PATCH_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

################################################################################
## DELETE /book
################################################################################

resource "aws_api_gateway_method" "DELETE_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-gateway.id
  resource_id   = aws_api_gateway_resource.API-resource-book.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "DELETE_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.API-gateway.id
  resource_id             = aws_api_gateway_resource.API-resource-book.id
  http_method             = aws_api_gateway_method.DELETE_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.book_lambda_function.invoke_arn
}

resource "aws_api_gateway_method_response" "DELETE_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.DELETE_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "DELETE_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  resource_id = aws_api_gateway_resource.API-resource-book.id
  http_method = aws_api_gateway_method.DELETE_method.http_method
  status_code = aws_api_gateway_method_response.DELETE_method_response_200.status_code

  depends_on = [aws_api_gateway_integration.DELETE_lambda_integration]

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$.body'))
    {
      \"statusCode\": 200,
      \"body\": $inputRoot,
      \"headers\": {
        \"Content-Type\": \"application/json\"
      }
    }
    EOF
  }
}

################################################################################
# Deployment of the API Gateway
################################################################################
resource "aws_api_gateway_deployment" "example" {

  depends_on = [
    aws_api_gateway_integration.GET_one_lambda_integration,
    aws_api_gateway_integration.GET_all_lambda_integration,
    aws_api_gateway_integration.PATCH_lambda_integration,
    aws_api_gateway_integration.POST_lambda_integration,
    aws_api_gateway_integration.DELETE_lambda_integration
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.API-resource-book,
      aws_api_gateway_method.GET_one_method,
      aws_api_gateway_integration.GET_one_lambda_integration,
      aws_api_gateway_method.GET_all_method,
      aws_api_gateway_integration.GET_all_lambda_integration,
      aws_api_gateway_method.POST_method,
      aws_api_gateway_integration.POST_lambda_integration,
      aws_api_gateway_method.PATCH_method,
      aws_api_gateway_integration.PATCH_lambda_integration,
      aws_api_gateway_method.DELETE_method,
      aws_api_gateway_integration.DELETE_lambda_integration
    ]))
  }

  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
}

################################################################################
# Create a stage for the API Gateway
################################################################################
resource "aws_api_gateway_stage" "my-prod-stage" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.API-gateway.id
  stage_name    = "prod"

  # depends_on = [aws_cloudwatch_log_group.api_gateway_execution_logs]

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_execution_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      responseLength = "$context.responseLength"
    })
  }
}


################################################################################
# Method settings
################################################################################
resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.API-gateway.id
  stage_name  = aws_api_gateway_stage.my-prod-stage.stage_name
  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    data_trace_enabled = true
    metrics_enabled    = true
  }
}
################################################################################
# CloudWatch log group for api execution logs
################################################################################
resource "aws_cloudwatch_log_group" "api_gateway_execution_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.API-gateway.id}/prod"
  retention_in_days = 7
}
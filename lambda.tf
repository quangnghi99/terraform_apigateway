# Compressing lambda function code
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_file = "${path.module}/function.py"
  output_path = "${path.module}/function.zip"
}

# Creating Lambda Function
resource "aws_lambda" "book_lambda_function" {
  function_name = locals.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = locals.lambda_function_runtime
  filename      = data.archive_file.lambda_function_zip.output_path
  memory_size  = 128
  timeout      = 10

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = local.dynamodb_name  # Name of the DynamoDB table
    }
  }

  source_code_hash = data.archive_file.lambda_function_archive.output_base64sha256

  tags = {
    Name        = "BookLambdaFunction"
    Environment = "Production"
  }
  
}

# Creating CloudWatch Log group for Lambda Function
resource "aws_cloudwatch_log_group" "book_lambda_function_cloudwatch" {
  name              = "/aws/lambda/${aws_lambda.book_lambda_function.function_name}"
  retention_in_days = 14

  tags = {
    Name        = "BookLambdaFunctionLogGroup"
    Environment = "Production"
  }
  
}

# Setup Lambda permission to allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.book_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.API-gateway.execution_arn}/*/*"
}
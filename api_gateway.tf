resource "aws_api_gateway_rest_api" "api" {
  name = "students"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "api_resource" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_res_path
  rest_api_id = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_method" "method" {
  count = length(var.api_method)
  authorization = "NONE"
  http_method   = "${var.api_method[count.index]}"
  resource_id   = aws_api_gateway_resource.api_resource[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  
}
resource "aws_api_gateway_integration" "integration" {
  count = length(var.api_method)
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.method[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function[count.index].invoke_arn
}
resource "aws_api_gateway_method_response" "response_200" {
  count = length(var.api_res_path)
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource[count.index].id
  http_method = aws_api_gateway_method.method[count.index].http_method
  status_code = "200"
  response_models  ={
    "application/json" = "Empty"
  }
}
resource "aws_lambda_permission" "apigw" {
  count = length(var.lambda_name)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function[count.index].function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gaterteway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "test"
}
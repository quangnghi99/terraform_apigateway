resource "aws_api_gateway_rest_api" "students" {
    name        = "students"
    description = "Student API Gateway"
}

resource "aws_api_gateway_resource" "api_resource" {
    rest_api_id = aws_api_gateway_rest_api.students.id
    parent_id   = aws_api_gateway_rest_api.students.root_resource_id
    path_part   = var.api_res_path
}

resource "aws_api_gateway_method" "api_method" {
    count = length(var.api_method)
    rest_api_id   = aws_api_gateway_rest_api.students.id
    resource_id   = aws_api_gateway_resource.api_resource.id
    http_method   = "${var.api_method[count.index]}"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
    count = length(var.api_method)
    rest_api_id             = aws_api_gateway_rest_api.students.id
    resource_id             = aws_api_gateway_resource.api_resource.id
    http_method             = aws_api_gateway_method.api_method[count.index].http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.lambda_function[count.index].invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
    count = length(var.api_method)
    rest_api_id = aws_api_gateway_rest_api.students.id
    resource_id = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method[count.index].http_method
    status_code = "200"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.students.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.students.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.students.id
  stage_name    = "test"
}

resource "aws_lambda_permission" "apigw" {
    count = length(var.lambda_name)
    statement_id  = "AllowAPIGatewayInvoke"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda_function[count.index].function_name}"
    principal     = "apigateway.amazonaws.com"

    # The /*/* portion grants access from any method on any resource
    # within the API Gateway "REST API".
    source_arn = "${aws_api_gateway_rest_api.students.execution_arn}/*/*"
}
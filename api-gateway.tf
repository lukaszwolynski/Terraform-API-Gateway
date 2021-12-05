resource "aws_api_gateway_rest_api" "api" {
  name               = "api-gateway"
  binary_media_types = ["*/*"]
}

resource "aws_api_gateway_deployment" "api_ingest_deployment" {
  depends_on = [aws_api_gateway_method.GETMethod,
    aws_api_gateway_integration.integration,

  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"

}

resource "aws_api_gateway_resource" "GETImage" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "image"
}

resource "aws_api_gateway_method" "GETMethod" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.GETImage.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.GETImage.id
  http_method             = aws_api_gateway_method.GETMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.getImage.invoke_arn
}
#x-api-key
resource "aws_api_gateway_usage_plan" "myusageplan" {
  name = "my_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_deployment.api_ingest_deployment.stage_name
  }
}

resource "aws_api_gateway_api_key" "mykey" {
  name = "my_key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.mykey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.myusageplan.id
}

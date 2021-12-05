resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getImage.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/GET/image"
}



resource "aws_lambda_function" "getImage" {
  filename         = "getImage.zip"
  function_name    = "getImage"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "getImage.lambda_handler"
  runtime          = "python3.9"
  timeout          = 10
  source_code_hash = filebase64sha256("getImage.zip")

  environment {
    variables = {
      bucketName = local.bucketName
    }
  }
}


#---------------------------------------------------
resource "aws_iam_role" "lambda_exec" { #and this
  name               = "serverless_lambda2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

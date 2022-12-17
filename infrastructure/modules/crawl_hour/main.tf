resource "aws_lambda_function" "data_crawl_hour" {
  function_name = var.lambda_name
  s3_bucket     = var.s3bucket_source
  s3_key        = var.lambda_src["function"]["hour"]
  role          = "arn:aws:iam::${var.caller_account}:role/LabRole"
  handler       = "crawl.handler"
  timeout       = 900
  memory_size   = 1024
  runtime       = var.comp_runtimes[0]
  layers        = [aws_lambda_layer_version.data_crawl_hour_layer.arn]

  environment {
    variables = {
      SYMBOL_CURRENT = var.symbol_current
    }
  }
}

resource "aws_lambda_layer_version" "data_crawl_hour_layer" {
  layer_name    = "data_crawl_hour_layer"
  s3_bucket     = var.s3bucket_source
  s3_key        = var.lambda_src["layer"]["hour"]

  compatible_runtimes = var.comp_runtimes
}

resource "aws_lambda_permission" "cloudwatch_permission_crawl_hour" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.data_crawl_hour.function_name
    principal = "events.amazonaws.com"
    source_arn = module.cloudwatch_hour.arn
}

output "out" {
  value = {
    "arn": "${aws_lambda_function.data_crawl_hour.arn}",
    "lambda_name": "${aws_lambda_function.data_crawl_hour.function_name}"
  }
}

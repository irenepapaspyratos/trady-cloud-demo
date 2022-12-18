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

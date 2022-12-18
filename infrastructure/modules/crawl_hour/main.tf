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

module "cloudwatch_hour" {
    source = "../cloudwatch_hour"

    cloudwatch_name = var.cloudwatch_name
}

module "lambda_permission" {
    source = "../lambda_permission"

    lambda_name = var.lambda_name
    cloudwatch_arn = module.cloudwatch_hour.out["arn"]
}

module "cloudwatch_target" {
    source = "../cloudwatch_target"

    target_rule = module.cloudwatch_hour.out["name"]
    target_id = var.target_id
    lambda_arn = aws_lambda_function.data_crawl_hour.arn
}

output "out" {
  value = {
    "arn": "${aws_lambda_function.data_crawl_hour.arn}",
    "lambda_name": "${aws_lambda_function.data_crawl_hour.function_name}"
  }
}

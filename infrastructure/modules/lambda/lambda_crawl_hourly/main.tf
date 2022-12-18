resource "aws_lambda_function" "data_crawl_hour" {
  function_name = var.lambda_name
  s3_bucket     = var.s3bucket_source
  s3_key        = var.lambda_src_function
  role          = "arn:aws:iam::${var.caller_account}:role/LabRole"
  handler       = var.crawl_handler
  timeout       = 900
  memory_size   = 1024
  runtime       = var.compatible_runtimes[0]
  layers        = [module.lambda_layer_hourly.out["arn"]]

  environment {
    variables = {
      SYMBOL_CURRENT  = var.symbol_current
      DEFAULT_CRAWL   = var.hour
      INVOCATION = "${var.invocation}"
    }
  }
}

module "lambda_layer_hourly" {
  source = "../lambda_layer_hourly"

  bucket_source = var.s3bucket_source
  key_name      = var.lambda_src_layer
  comp_runtimes = var.compatible_runtimes
}

module "cloudwatch_hour" {
    source = "../../cloudwatch/cloudwatch_hourly"

    cloudwatch_name = var.cloudwatch_name
}

module "lambda_permission" {
    source = "../lambda_permission"

    lambda_name     = var.lambda_name
    cloudwatch_arn  = module.cloudwatch_hour.out["arn"]
}

module "cloudwatch_target" {
    source = "../../cloudwatch/cloudwatch_target"

    target_rule   = module.cloudwatch_hour.out["name"]
    target_id     = var.target_id
    lambda_arn    = aws_lambda_function.data_crawl_hour.arn
}

output "out" {
  value = {
    "arn": "${aws_lambda_function.data_crawl_hour.arn}",
    "lambda_name": "${aws_lambda_function.data_crawl_hour.function_name}"
  }
}

resource "aws_lambda_layer_version" "data_crawl_hour_layer" {
  layer_name    = "data_crawl_hour_layer"
  s3_bucket     = var.bucket_source
  s3_key        = var.key_name
  compatible_runtimes = var.comp_runtimes
}

output "out" {
  value = {"arn": "${aws_lambda_layer_version.data_crawl_hour_layer.arn}"}
}
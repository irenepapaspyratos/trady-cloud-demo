module "lambda_crawl_hour" {
    source = "./modules/lambda_crawl_hour"

    for_each = {for i, v in var.symbols: i=>v}
    
    lambda_name = "crawl_hour_${each.value}"
    symbol_current = "${each.value}"
    comp_runtimes = "${var.compatible_runtimes}"
    s3bucket_source = "${var.s3bucket_src}"
    caller_account = "${local.account_id}"
    target_rule = "crawl_hour_target_${each.value}"
    target_id = "data_crawl_hourly_${each.value}"
    cloudwatch_name = "cloudwatch_hour_${each.value}"
}

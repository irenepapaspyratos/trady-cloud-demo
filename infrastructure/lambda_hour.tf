module "crawl_hour" {
    source = "./modules/crawl_hour"

    for_each = {for i, v in var.symbols: i=>v}
    
    lambda_name = "crawl_hour_${each.value}"
    symbol_current = "${each.value}"
    comp_runtimes = "${var.compatible_runtimes}"
    s3bucket_source = "${var.s3bucket_src}"
    caller_account = "${local.account_id}"
}

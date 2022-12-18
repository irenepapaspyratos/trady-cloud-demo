resource "aws_cloudwatch_event_target" "cloudwatch_target_crawl_hour" {
    rule = var.target_rule
    target_id = var.target_id
    arn = var.lambda_arn
}

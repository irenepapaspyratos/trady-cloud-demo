resource "aws_lambda_permission" "cloudwatch_permission_crawl_hour" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_name
    principal = "events.amazonaws.com"
    source_arn = var.cloudwatch_arn
}

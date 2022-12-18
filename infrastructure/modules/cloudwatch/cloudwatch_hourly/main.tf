resource "aws_cloudwatch_event_rule" "cloudwatch_rule_every_hour" {
    name = var.cloudwatch_name
    description = "Fires every hour with 15 min delay"
    schedule_expression = "cron(15 0/1 * * ? *)"
}

output "out" {
    value = {
        "name": "${aws_cloudwatch_event_rule.cloudwatch_rule_every_hour.name}",
        "arn": "${aws_cloudwatch_event_rule.cloudwatch_rule_every_hour.arn}"
    }
}

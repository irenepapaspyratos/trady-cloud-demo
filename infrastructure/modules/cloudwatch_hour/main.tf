resource "aws_cloudwatch_event_rule" "cloudwatch_rule_every_hour" {
    name = var.cloudwatch_name
    description = "Fires every  min delay"
    schedule_expression = "cron(* * * * ? *)"
}

output "out" {
    value = {
        "name": "${aws_cloudwatch_event_rule.cloudwatch_rule_every_hour.name}",
        "arn": "${aws_cloudwatch_event_rule.cloudwatch_rule_every_hour.arn}"
    }
}
#15 0/1 * * ? *
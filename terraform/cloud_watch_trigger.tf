resource "aws_cloudwatch_event_rule" "cw_as_trigger" {
  name        = "cw_as_trigger"
  description = "CloudWatch trigger for instance state change detection"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": [
      "stopped",
      "terminated"
    ],
    "instance-id": [
      "${aws_instance.az1_cassandra_seed.id}",
      "${aws_instance.az2_cassandra_seed.id}",
      "${aws_instance.az3_cassandra_seed.id}"
    ]
  }
}
PATTERN
}


resource "aws_cloudwatch_event_target" "failover_for_seeds_target" {
  rule = "${aws_cloudwatch_event_rule.cw_as_trigger.name}"
  arn  = "${aws_lambda_function.failover_for_seeds.arn}"
}

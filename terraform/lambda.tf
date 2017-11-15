resource "aws_lambda_function" "failover_for_seeds" {
  filename      = "index.zip"
  description   = "Start stopped seed instance of cassandra"
  function_name = "start_stopped_seed_lambda"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "index.handler"
  runtime       = "nodejs6.10"
  timeout       = 10

  environment {
    variables = {
      CASSANDRA_SEED_TAG     = "${var.seed_tag}"
      CASSANDRA_AMI          = "${var.cassandra_ami}"
      CASSANDRA_KEY          = "${var.key_name}"
      CASSANDRA_INST_TYPE    = "${var.cassandra_instance_type}"
      CASSANDRA_TAG          = "${var.tag}"
      CLOUD_WATCH_EVENT_NAME = "${aws_cloudwatch_event_rule.cw_as_trigger.name}"
    }
  }
}

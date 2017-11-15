resource "aws_launch_configuration" "cassandra_lc" {
  name            = "cassandra_lc"
  image_id        = "${var.cassandra_ami}"
  instance_type   = "${var.cassandra_instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.cassandra_private_sg.id}"]
  user_data       = "${file("./files/cluster_config_non_seeds.sh")}"
}

resource "aws_autoscaling_group" "cassndra_as" {
  name                 = "cassndra_as"
  vpc_zone_identifier  = ["${aws_subnet.az1_subnet_private.id}", "${aws_subnet.az2_subnet_private.id}", "${aws_subnet.az3_subnet_private.id}"]
  launch_configuration = "${aws_launch_configuration.cassandra_lc.name}"
  min_size             = "${var.as_min_size}"
  max_size             = "${var.as_max_size}"

  load_balancers = ["${aws_elb.cassandra_elb.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cassandra_as_policy" {
  name            = "cassandra_as_policy"
  adjustment_type = "ChangeInCapacity"

  autoscaling_group_name  = "${aws_autoscaling_group.cassndra_as.name}"
  policy_type             = "StepScaling"
  metric_aggregation_type = "Average"

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 50
  }

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 50
  }
}

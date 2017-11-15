resource "aws_elb" "cassandra_elb" {
  name            = "cassandraelb"
  subnets         = ["${aws_subnet.az1_subnet_public.id}", "${aws_subnet.az2_subnet_public.id}", "${aws_subnet.az3_subnet_public.id}"]
  internal        = false
  security_groups = ["${aws_security_group.cassandra_elb_sg.id}"]
  instances       = ["${aws_instance.az1_cassandra_seed.id}", "${aws_instance.az2_cassandra_seed.id}", "${aws_instance.az3_cassandra_seed.id}"]

  listener {
    instance_port     = 9160
    instance_protocol = "TCP"
    lb_port           = 9160
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9160"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.tag}"
  }
}

output "webapp_elb_name" {
  value = "${aws_elb.cassandra_elb.dns_name}"
}

# Define security group for cassandra  cluster

resource "aws_security_group" "cassandra_private_sg" {
  name   = "cassandra_private_sg"
  vpc_id = "${aws_vpc.cassandra_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.tag}"
  }
}

# Define sg rules

resource "aws_security_group_rule" "allow_ssh_from_bastions" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.az1_subnet_public.cidr_block}", "${aws_subnet.az2_subnet_public.cidr_block}", "${aws_subnet.az3_subnet_public.cidr_block}"]
  security_group_id = "${aws_security_group.cassandra_private_sg.id}"
}

resource "aws_security_group_rule" "cassandra_7000" {
  type              = "ingress"
  from_port         = 7000
  to_port           = 7000
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.az1_subnet_private.cidr_block}", "${aws_subnet.az2_subnet_private.cidr_block}", "${aws_subnet.az3_subnet_private.cidr_block}"]
  security_group_id = "${aws_security_group.cassandra_private_sg.id}"
}

resource "aws_security_group_rule" "cassandra_7001" {
  type              = "ingress"
  from_port         = 7001
  to_port           = 7001
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.az1_subnet_private.cidr_block}", "${aws_subnet.az2_subnet_private.cidr_block}", "${aws_subnet.az3_subnet_private.cidr_block}"]
  security_group_id = "${aws_security_group.cassandra_private_sg.id}"
}

resource "aws_security_group_rule" "cassandra_7199" {
  type              = "ingress"
  from_port         = 7199
  to_port           = 7199
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.az1_subnet_private.cidr_block}", "${aws_subnet.az2_subnet_private.cidr_block}", "${aws_subnet.az3_subnet_private.cidr_block}"]
  security_group_id = "${aws_security_group.cassandra_private_sg.id}"
}

resource "aws_security_group_rule" "cassandra_9042" {
  type              = "ingress"
  from_port         = 9042
  to_port           = 9042
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.az1_subnet_private.cidr_block}", "${aws_subnet.az2_subnet_private.cidr_block}", "${aws_subnet.az3_subnet_private.cidr_block}"]
  security_group_id = "${aws_security_group.cassandra_private_sg.id}"
}

resource "aws_security_group_rule" "cassandra_9160" {
  type              = "ingress"
  from_port         = 9160
  to_port           = 9160
  protocol          = "tcp"
  cidr_blocks       = ["${aws_subnet.az1_subnet_private.cidr_block}", "${aws_subnet.az2_subnet_private.cidr_block}", "${aws_subnet.az3_subnet_private.cidr_block}", "${aws_subnet.az1_subnet_public.cidr_block}", "${aws_subnet.az2_subnet_public.cidr_block}", "${aws_subnet.az3_subnet_public.cidr_block}"]
  security_group_id = "${aws_security_group.cassandra_private_sg.id}"
}

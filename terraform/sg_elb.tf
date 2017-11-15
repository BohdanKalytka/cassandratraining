resource "aws_security_group" "cassandra_elb_sg" {
  vpc_id = "${aws_vpc.cassandra_vpc.id}"
  name   = "cassandra_elb_sg"

  ingress {
    from_port   = 9160
    to_port     = 9160
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 9160
    to_port     = 9160
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_network_interface" "az1_cassandra_seed_eni" {
  description     = "az1_cassandra_seed_seed_1_eni"
  subnet_id       = "${aws_subnet.az1_subnet_private.id}"
  private_ips     = ["10.0.1.50"]
  security_groups = ["${aws_security_group.cassandra_private_sg.id}"]

  tags {
    Name = "${var.seed_tag}"
  }
}

resource "aws_network_interface" "az2_cassandra_seed_eni" {
  description     = "az2_cassandra_seed_2_eni"
  subnet_id       = "${aws_subnet.az2_subnet_private.id}"
  private_ips     = ["10.0.2.50"]
  security_groups = ["${aws_security_group.cassandra_private_sg.id}"]

  tags {
    Name = "${var.seed_tag}"
  }
}

resource "aws_network_interface" "az3_cassandra_seed_eni" {
  description     = "az3_cassandra_seed_3_eni"
  subnet_id       = "${aws_subnet.az3_subnet_private.id}"
  private_ips     = ["10.0.3.50"]
  security_groups = ["${aws_security_group.cassandra_private_sg.id}"]

  tags {
    Name = "${var.seed_tag}"
  }
}

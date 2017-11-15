resource "aws_instance" "az1_cassandra_seed" {
  ami               = "${var.cassandra_ami}"
  instance_type     = "${var.cassandra_instance_type}"
  key_name          = "${var.key_name}"
  availability_zone = "${var.azs[0]}"

  network_interface {
    network_interface_id = "${aws_network_interface.az1_cassandra_seed_eni.id}"
    device_index         = 0
  }

  user_data = "${file("./files/cluster_config.sh")}"

  tags {
    Name = "${var.seed_tag}"
  }
}

resource "aws_instance" "az2_cassandra_seed" {
  ami               = "${var.cassandra_ami}"
  instance_type     = "${var.cassandra_instance_type}"
  key_name          = "${var.key_name}"
  availability_zone = "${var.azs[1]}"

  network_interface {
    network_interface_id = "${aws_network_interface.az2_cassandra_seed_eni.id}"
    device_index         = 0
  }

  user_data = "${file("./files/cluster_config.sh")}"

  tags {
    Name = "${var.seed_tag}"
  }
}

resource "aws_instance" "az3_cassandra_seed" {
  ami               = "${var.cassandra_ami}"
  instance_type     = "${var.cassandra_instance_type}"
  key_name          = "${var.key_name}"
  availability_zone = "${var.azs[2]}"

  network_interface {
    network_interface_id = "${aws_network_interface.az3_cassandra_seed_eni.id}"
    device_index         = 0
  }

  user_data = "${file("./files/cluster_config.sh")}"

  tags {
    Name = "${var.seed_tag}"
  }
}

resource "aws_eip" "az1_nat_gw_ip" {
  vpc = true
}

resource "aws_nat_gateway" "az1_nat_gw" {
  allocation_id = "${aws_eip.az1_nat_gw_ip.id}"
  subnet_id     = "${aws_subnet.az1_subnet_public.id}"

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_eip" "az2_nat_gw_ip" {
  vpc = true
}

resource "aws_nat_gateway" "az2_nat_gw" {
  allocation_id = "${aws_eip.az2_nat_gw_ip.id}"
  subnet_id     = "${aws_subnet.az2_subnet_public.id}"

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_eip" "az3_nat_gw_ip" {
  vpc = true
}

resource "aws_nat_gateway" "az3_nat_gw" {
  allocation_id = "${aws_eip.az3_nat_gw_ip.id}"
  subnet_id     = "${aws_subnet.az3_subnet_public.id}"

  tags {
    Name = "${var.tag}"
  }
}

# Define IGW for public subnet

resource "aws_internet_gateway" "public_igw" {
  vpc_id = "${aws_vpc.cassandra_vpc.id}"

  tags {
    Name = "${var.tag}"
  }
}

# Tables for private subnets

resource "aws_route_table" "az1_private_rt" {
  vpc_id = "${aws_vpc.cassandra_vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.az1_nat_gw.id}"
  }

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_route_table_association" "az1_private_rt_as" {
  subnet_id      = "${aws_subnet.az1_subnet_private.id}"
  route_table_id = "${aws_route_table.az1_private_rt.id}"
}

resource "aws_route_table" "az2_private_rt" {
  vpc_id = "${aws_vpc.cassandra_vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.az2_nat_gw.id}"
  }

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_route_table_association" "az2_private_rt_as" {
  subnet_id      = "${aws_subnet.az2_subnet_private.id}"
  route_table_id = "${aws_route_table.az2_private_rt.id}"
}

resource "aws_route_table" "az3_private_rt" {
  vpc_id = "${aws_vpc.cassandra_vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.az3_nat_gw.id}"
  }

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_route_table_association" "az3_private_rt_as" {
  subnet_id      = "${aws_subnet.az3_subnet_private.id}"
  route_table_id = "${aws_route_table.az3_private_rt.id}"
}

# Tables for public  subnets

resource "aws_route_table" "az1_public_rt" {
  vpc_id = "${aws_vpc.cassandra_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public_igw.id}"
  }

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_route_table_association" "az1_public_rt_as" {
  subnet_id      = "${aws_subnet.az1_subnet_public.id}"
  route_table_id = "${aws_route_table.az1_public_rt.id}"
}

resource "aws_route_table_association" "az2_public_rt_as" {
  subnet_id      = "${aws_subnet.az2_subnet_public.id}"
  route_table_id = "${aws_route_table.az1_public_rt.id}"
}

resource "aws_route_table_association" "az3_public_rt_as" {
  subnet_id      = "${aws_subnet.az3_subnet_public.id}"
  route_table_id = "${aws_route_table.az1_public_rt.id}"
}

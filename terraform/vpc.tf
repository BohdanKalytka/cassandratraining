# VPC creation

resource "aws_vpc" "cassandra_vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.tag}"
  }
}

# Defining private subnets for cassandra

resource "aws_subnet" "az1_subnet_private" {
  vpc_id            = "${aws_vpc.cassandra_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.azs[0]}"

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_subnet" "az2_subnet_private" {
  vpc_id            = "${aws_vpc.cassandra_vpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.azs[1]}"

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_subnet" "az3_subnet_private" {
  vpc_id            = "${aws_vpc.cassandra_vpc.id}"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.azs[2]}"

  tags {
    Name = "${var.tag}"
  }
}

# Defining public subnets for bastion

resource "aws_subnet" "az1_subnet_public" {
  vpc_id                  = "${aws_vpc.cassandra_vpc.id}"
  cidr_block              = "10.0.4.0/28"
  availability_zone       = "${var.azs[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_subnet" "az2_subnet_public" {
  vpc_id                  = "${aws_vpc.cassandra_vpc.id}"
  cidr_block              = "10.0.4.16/28"
  availability_zone       = "${var.azs[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.tag}"
  }
}

resource "aws_subnet" "az3_subnet_public" {
  vpc_id                  = "${aws_vpc.cassandra_vpc.id}"
  cidr_block              = "10.0.4.32/28"
  availability_zone       = "${var.azs[2]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.tag}"
  }
}

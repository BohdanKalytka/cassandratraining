resource "aws_instance" "az1_bastion" {
  ami               = "${var.bastion_ami}"
  instance_type     = "${var.bastion_instance_type}"
  key_name          = "${var.key_name}"
  availability_zone = "${var.azs[0]}"
  subnet_id         = "${aws_subnet.az1_subnet_public.id}"

  vpc_security_group_ids = ["${aws_security_group.bastion_public_sg.id}"]

  tags {
    Name = "${var.tag}_bastion"
  }
}

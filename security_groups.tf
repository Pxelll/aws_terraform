# Public security group ->

resource "aws_security_group" "public_sg" {
  vpc_id      = aws_vpc.vpc_workspace.id
  name        = "http_ssh"
  description = "Allow inbound traffic from the internet"

  tags = {
    "Name" = "Public SG"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_ping_in_public" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_public_hosts" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "anything_can_go_out_public" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# Private security group ->
resource "aws_security_group" "private_sg" {
  vpc_id      = aws_vpc.vpc_workspace.id
  name        = "private"
  description = "Do not allow inbound traffic from the internet"

  tags = {
    "Name" = "Private SG"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ping_private" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.vpc_workspace.cidr_block
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_private_subnet_vpc_only" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.vpc_workspace.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_out_private" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.vpc_workspace.cidr_block
  ip_protocol       = "-1"
}
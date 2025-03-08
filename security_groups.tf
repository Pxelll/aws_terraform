# Security groups: public_sg, private_sg

resource "aws_security_group" "public_sg" {
  vpc_id      = aws_vpc.vpc_workspace.id
  name        = "http_ssh"
  description = "Allow inbound traffic from the internet"
}

resource "aws_security_group" "private_sg" {
  vpc_id      = aws_vpc.vpc_workspace.id
  name        = "private"
  description = "Do not allow inbound traffic from the internet"
}

# Ingress rules for public_sg

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_public" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_private" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = aws_vpc.vpc_workspace.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "anything_can_go_out_public" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Ingress rules for private_sg

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_private" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.vpc_workspace.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "anything_can_go_out_private" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  #cidr_ipv4         = aws_security_group.private_sg.id 
  ip_protocol = "-1"
}

resource "aws_security_group_rule" "allow_ssh_public_to_private" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.public_sg.id
  
}
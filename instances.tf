resource "tls_private_key" "aws_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "aws_key"
  public_key = tls_private_key.aws_key.public_key_openssh
  tags = {
    "Goal" = "ssh access"
  }
}

resource "local_sensitive_file" "aws_key_pem" {
  content         = tls_private_key.aws_key.private_key_pem
  filename        = "${path.module}/aws_key.pem"
  file_permission = "600"
}

resource "aws_instance" "public_ec2" {
  instance_type          = "t2.micro"
  ami                    = var.ami_image
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo useradd -m ${var.user}
              echo "${var.user}:noble6" | sudo chpasswd
              sudo usermod -aG wheel ${var.user}
              mkdir -p /home/${var.user}/.ssh
              cp /home/ec2-user/.ssh/authorized_keys /home/${var.user}/.ssh/authorized_keys
              chown -R ${var.user}:${var.user} /home/${var.user}/.ssh
              chmod 700 /home/${var.user}/.ssh
              chmod 600 /home/${var.user}/.ssh/authorized_keys
              sudo chsh -s /bin/bash ${var.user}
              sudo usermod -aG sudo ${var.user}
              EOF

  tags = {
    Name = "Public EC2"
  }

}

resource "aws_instance" "private_ec2" {
  instance_type          = "t2.micro"
  ami                    = var.ami_image
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo useradd -m ${var.user}
              echo "${var.user}:noble6" | sudo chpasswd
              sudo usermod -aG wheel ${var.user}
              mkdir -p /home/${var.user}/.ssh
              cp /home/ec2-user/.ssh/authorized_keys /home/${var.user}/.ssh/authorized_keys
              chown -R ${var.user}:${var.user} /home/${var.user}/.ssh
              chmod 700 /home/${var.user}/.ssh
              chmod 600 /home/${var.user}/.ssh/authorized_keys
              sudo chsh -s /bin/bash ${var.user}
              sudo usermod -aG sudo ${var.user}
              EOF

  tags = {
    Name = "Private EC2"
  }

}

output "public_ec2_ip" {
  value = aws_instance.public_ec2.public_ip
}
output "private_ec2_ip" {
  value = aws_instance.private_ec2.private_ip
}
# resource "aws_key_pair" "ec2_key" {
#   key_name   = "aws_key"
#   public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuVsNwK2W49hvgdFJRl7blPDX4bLWJ3YqptbhDvgoe5 Thiago@aorus"
#   tags = {
#     "Goal" = "ssh access"
#   }
# }

resource "aws_instance" "public_ec2" {
  instance_type          = "t2.micro"
  ami                    = "ami-04b4f1a9cf54c11d0"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = "aws-key"

  user_data = <<-EOF
              #!/bin/bash
              sudo useradd -m adam
              echo "adam:noble6" | sudo chpasswd
              sudo usermod -aG wheel adam
              mkdir -p /home/adam/.ssh
              cp /home/ec2-user/.ssh/authorized_keys /home/adam/.ssh/authorized_keys
              chown -R adam:adam /home/adam/.ssh
              chmod 700 /home/adam/.ssh
              chmod 600 /home/adam/.ssh/authorized_keys              
              EOF

  tags = {
    Name = "Public EC2"
  }

}

resource "aws_instance" "private_ec2" {
  instance_type          = "t2.micro"
  ami                    = "ami-04b4f1a9cf54c11d0"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "aws-key"

  user_data = <<-EOF
              #!/bin/bash
              sudo useradd -m adam
              echo "adam:noble6" | sudo chpasswd
              sudo usermod -aG wheel adam
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
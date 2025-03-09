variable "ami_image" {
  description = "The AMI image to use for the EC2 instance"
  default     = "ami-08b5b3a93ed654d19" # Amazon Linux 2023 AMI 2023.6.20250303.0 x86_64 HVM kernel-6.1
  # "ami-04b4f1a9cf54c11d0" # Ubuntu Server 24.04 LTS
}

variable "user" {
  description = "The user to create on the EC2 instance"
  default     = "adam"
}
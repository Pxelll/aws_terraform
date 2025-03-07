# aws_terraform
This project was started with the goal to create a good infrastructure template for AWS.

---

Here we will create 1 VPC with 2 subnets:

- **Public subnet**:  
  You can SSH with `aws_key.pem` which Terraform will generate in this folder! The instances here will have internet access and will have ports 22 and 80 open.

- **Private subnet**:  
  You can login from an instance inside the public subnet only. This subnet only has port 22 open for the VPC which Terraform will create! It does not have access to the internet.

Feel free to take a look at the .tf files. I have security groups, some EC2 instances configured to launch, IP outputs, private key creation, and more!

**Prerequisites**:

- Terraform
- AWS CLI

You need to login to AWS CLI and have Terraform on your PATH on your machine. Use:

- `aws configure`  
  Here you need to set your credentials.

- `terraform plan`  
  To see what all these .tf files will do.

- `terraform apply --auto-approve`  
  To apply these changes.

- `terraform destroy --auto-approve`  
  To delete everything you have created with Terraform.
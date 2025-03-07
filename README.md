# aws_terraform
This project was started with the goal for create a good infrastructure template for AWS.
---
Here will create 1 VPC with 2 subnets:
    - public subnet:
        You can ssh with aws_key.pem which terraform will generate on this folder! the instances here will have internet and will have port 22 and 80 port open.
    - private subnet:
        You can login from a instance inside public subnet only, this subnet only have 22 port open for VPC which terraform will create! dont have access to internet.
    
    fell free to take a look at .tf files, i have security groups, some ec2 instances, configured to launch, ip's outputs, private key creation and more!

prerequisites:
    - terraform
    - aws-cli

You need to login in aws-cli and need terraform on your PATH at you machine. use:
    - aws-cli configure
        Here you need to set your credentials here
    - terraform plan 
        To see what all these .tf files will do
    - terraform apply --auto-approve
        To apply these changes
    - terraform destroy --auto-approve
        To delete all what you have created with terraform

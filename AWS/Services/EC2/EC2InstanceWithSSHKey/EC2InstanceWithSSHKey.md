## EC2InstanceWithSSHKey: Creating an EC2 Instance With SSH Key

### Instructions:
Using Terraform, create a script that provisions an EC2 instance on AWS.

### Requirements:
- The instance should be in a specific AWS region. ✅
- Use an AMI of your choice. ✅
- The instance must have a specific instance type. ✅
- Assign a tag to the instance with a custom name. ✅
- Configure an SSH key pair to access the instance. ✅

## Commands:
- aws configure
- terraform init
- terraform plan
- terraform apply
- terraform output -raw simple_ec2_private_key > simple-ec2-key.pem
Use EIP or Bastion to SSH
- ssh -i "simple-ec2-key.pem" ec2-user@ec2-my-best-public-dns.compute-1.amazonaws.com
- terraform destroy

## References:
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter
- https://registry.terraform.io/providers/hashicorp/tls/latest/docs
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
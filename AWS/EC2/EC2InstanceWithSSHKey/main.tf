terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

#Get AWS SSM Parameter Store parameter AL2023 AMI to allow creation with the most recent image
data "aws_ssm_parameter" "al2023_ami_kernel_6_1_x86_64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "tls_private_key" "simple_ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "simple_ec2_generated_key" {
  key_name   = "simple-ec2-key"
  public_key = tls_private_key.simple_ec2.public_key_openssh
}

resource "aws_instance" "simple_ec2" {
  ami           = data.aws_ssm_parameter.al2023_ami_kernel_6_1_x86_64.value
  instance_type = "t3.micro"
  key_name      = aws_key_pair.simple_ec2_generated_key.key_name

  tags = {
    Name = var.tagname
  }
}

output "simple_ec2_private_key" {
  value     = tls_private_key.simple_ec2.private_key_pem
  sensitive = true
}
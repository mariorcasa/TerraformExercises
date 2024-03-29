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


data "aws_availability_zones" "available" {}

#Get AWS SSM Parameter Store parameter AL2023 AMI to allow creation with the most recent image
data "aws_ssm_parameter" "al2023_ami_kernel_6_1_x86_64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

#Network
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 tags = {
   Name = var.tagname
 }
}

resource "aws_internet_gateway" "main" { 
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.tagname
  }
}

resource "aws_route" "main_ig_route" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.main.id
  
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}



#EC2 Key Generation
resource "tls_private_key" "ec2_nginx" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_nginx_generated_key" {
  key_name   = "ec2_nginx_private_key"
  public_key = tls_private_key.ec2_nginx.public_key_openssh
}



#EC2
resource "aws_instance" "ec2_nginx" {
  ami           = data.aws_ssm_parameter.al2023_ami_kernel_6_1_x86_64.value
  instance_type = "t3.small"
  key_name      = aws_key_pair.ec2_nginx_generated_key.key_name
  user_data = file("userdata.tpl")
  network_interface {
    network_interface_id = aws_network_interface.ec2_nginx.id
    device_index         = 0
  }
  tags = {
    Name = var.tagname
  }
}

resource "aws_network_interface" "ec2_nginx" {
  subnet_id       = aws_subnet.public_subnets.0.id
  security_groups = [aws_security_group.ec2_nginx.id]
  tags = {
    Name = "primary_network_interface"
  }
}



#EC2 Security Group
resource "aws_security_group" "ec2_nginx" {
  name        = "ec2_nginx"
  description = "Allow traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_nginx_alb_relation" {
  security_group_id = aws_security_group.ec2_nginx.id
  referenced_security_group_id = aws_security_group.alb_ec2_nginx.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ec2_nginx_ssh" {
  security_group_id = aws_security_group.ec2_nginx.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_nginx.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



#Application Load Balancer (ALB)
resource "aws_lb" "ec2_nginx" {
  name               = "alb-ec2-nginx"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  security_groups    = [aws_security_group.alb_ec2_nginx.id]
  tags = {
    Name = var.tagname
  }

}

resource "aws_lb_target_group" "ec2_nginx" {
  name     = "alb-tg-ec2-nginx"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "ec2_nginx" {
  load_balancer_arn = aws_lb.ec2_nginx.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_nginx.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_nginx" {
  target_group_arn = aws_lb_target_group.ec2_nginx.arn
  target_id        = aws_instance.ec2_nginx.id
  port             = 80
}



#ALB Security Group
resource "aws_security_group" "alb_ec2_nginx" {
  name        = "alb_ec2_nginx"
  description = "Allow traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ec2_nginx" {
  security_group_id = aws_security_group.alb_ec2_nginx.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "alb_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_ec2_nginx.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

## ALBWithEC2Attachment: Creating a Application Load Balancer (ALB) With Nginx and expose service

### Instructions:
Using Terraform, create a script that configures an Application Load Balancer (ALB) on AWS that connect to a service.

### Requirements:
- The load balancer should be available in at least two availability zones. ✅
- Configure a target group for the load balancer. ✅
- Assign a tag to the load balancer. ✅
- Configure a listener to redirect traffic to an EC2 instance. ✅
- Install Nginx in the EC2. ✅

## Commands:
- aws configure
- terraform init
- terraform plan
- terraform apply
- (Wait some minutes after to apply, can take 10 minutes, is necessary run userdata.tpl and that is AWS process, to validate, use EIP to connect or see health checks in the target group)
- terraform output -raw ec2_nginx_private_key > ec2_nginx_private_key.pem
- ssh -i "ec2_nginx_private_key.pem" ec2-user@ec2-my-best-public-dns.compute-1.amazonaws.com
- terraform destroy

## References:
### Network
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment

### EC2
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter
- https://registry.terraform.io/providers/hashicorp/tls/latest/docs
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
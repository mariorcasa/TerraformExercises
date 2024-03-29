output "ec2_nginx_private_key" {
  value     = tls_private_key.ec2_nginx.private_key_pem
  sensitive = true
}
#!/bin/bash
yum update -y
yum install -y nginx
sudo systemctl start nginx.service
sudo systemctl status nginx.service
sudo systemctl enable nginx.service
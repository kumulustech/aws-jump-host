provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

resource "aws_eip" "public_ip" {
  domain = "vpc"
  tags = {
    Name = "jump-public-ip"
  }
}

resource "aws_route53_record" "jump" {
  zone_id = "ZABACAB" # Replace with the actual Zone ID for polycloud.io
  name    = "jump.example.com"
  type    = "A"
  ttl     = "300"

  records = [aws_eip.public_ip.public_ip]
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}


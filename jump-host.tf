provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-008fe2fc65df48dac"
  instance_type = "m5.xlarge"
  key_name      = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #cloud-config
              users:
                - name: rstarmer
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: rstarmer
                - name: robert
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: rstarmer
                - name: john
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: johnstarmer
                - name: corbin
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: MostAwesomeDude
                - name: erik
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: emccormickva
                - name: anurag
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: vaarik1005
              ssh_pwauth: false
              chpasswd:
                list: |
                  rstarmer:RANDOM
                  robert:RANDOM
                  john:RANDOM
                  corbin:RANDOM
                  erik:RANDOM
                  anurag:RANDOM
                expire: False
              EOF

  associate_public_ip_address = true

  tags = {
    Name = "jump.polycloud.io"
  }
}


resource "aws_route53_record" "jump" {
  zone_id = "Z2TH6C2ISUQOZU" # Replace with the actual Zone ID for polycloud.io
  name    = "jump.polycloud.io"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.ubuntu.public_ip]
}

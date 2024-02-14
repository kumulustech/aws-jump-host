provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

data "aws_eip" "public_ip" {
  filter {
    name   = "tag:Name"
    values = ["jump-public-ip"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-008fe2fc65df48dac"
  instance_type = "m5.large"
  key_name      = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #cloud-config
              users:
                - name: rstarmer
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: gh:rstarmer
                - name: robert
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: gh:rstarmer
                - name: john
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: gh:johnstarmer
                - name: corbin
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: gh:MostAwesomeDude
                - name: erik
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: gh:emccormickva
                - name: anurag
                  sudo: ['ALL=(ALL) NOPASSWD:ALL']
                  ssh_import_id: gh:vaarik1005
              ssh_pwauth: false
              EOF

  tags = {
    Name = "jump.polycloud.io"
  }

  associate_public_ip_address = false
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ubuntu.id
  allocation_id = data.aws_eip.public_ip.id
}


output "eip" {
  value = data.aws_eip.public_ip.public_ip
}

output "associated_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

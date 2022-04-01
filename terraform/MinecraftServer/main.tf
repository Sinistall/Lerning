provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "MinecraftServer" {
  ami           = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.GroupMinecraft.id]
  instance_type = "t2.micro"
  user_data = file("user_data.sh")
  key_name = "keyfrankfurt"

  tags = {
    Name = "Minecraft Server"
    Owner="Diadyk Andriy"
  }

  lifecycle {
    ignore_changes = [ami]
    create_before_destroy = true
  }
}

resource "aws_security_group" "GroupMinecraft" {
name        = "SG_for_MinecraftWebServer"
description = "My Security Group for Terraform script"

dynamic "ingress" {
  for_each = ["22", "25565"]
  content {
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Owner="Diadyk Andriy"
  }
}

output "my-ip"{
  value = aws_instance.MinecraftServer.public_ip
}

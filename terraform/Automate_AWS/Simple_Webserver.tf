provider "aws" {
  region = "eu-central-1"
}

resource "aws_eip" "webserver_eip" {
  instance = aws_instance.myweb-server.id
  tag = {
    Owner = "Diadyk Andriy"
  }
}

resource "aws_instance" "myweb-server" {
  ami                    = "ami-0dcc0ebde7b2e00db"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_Web-server.id]
  user_data              = file("user_data.sh")
  tags = {
    Name="Linux_Webserver"
    ENV="prod"
    Owner="Diadyk Andriy"
  }
  lifecycle {
    ignore_changes = ["ami"]
    create_before_destroy = true
  }
}

resource "aws_security_group" "For_Web-server" {
  name        = "SG_for_webserver"
  description = "My Security Group for Terraform script"

  dynamic "ingress" {
    for_each = ["22", "80", "8080"]
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
    Name="SG_Webserver"
    Owner="Diadyk Andriy"
  }
}
 

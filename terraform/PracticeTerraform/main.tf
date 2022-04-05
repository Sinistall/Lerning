provider "aws" {
  region = var.region
}

data "aws_ami" "latest" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = [var.find-ami-prefix]
  }
}

resource "aws_instance" "Test_WebServer" {
  ami = data.aws_ami.latest.id
  instance_type = var.instance_type
  user_data = templatefile("user_data.sh.tpl", var.common-tags)
  vpc_security_group_ids = [aws_security_group.WebServer.id]
  key_name = "keyfrankfurt"

  tags = merge(var.common-tags, {
    Name = "Test WebServer ${var.common-tags["ENV"]}"
    })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "WebServer" {
  name = "SG for WebServer Nginx"
  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.cidr]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

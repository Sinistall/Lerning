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

resource "aws_instance" "Flask_WebServer" {
  ami = data.aws_ami.latest.id
  instance_type = var.instance_type
  user_data = template_file("user_data.sh.tpl")

  tags = merge(var.common-tags, {
    Name = "Flask WebServer ${var.common-tags["env"]}"
    })
  lifecycle {
    create_before_destroy = true
  }
}

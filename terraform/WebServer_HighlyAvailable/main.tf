provider "aws" {}

data "aws_availability_zones" "for_web_server" {}

data "aws_ami" "for_web_server" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }
}

resource "aws_security_group" "for_web_server" {
  name        = "Security Group for WebServer"

  dynamic "ingress" {
    for_each = ["80", "433"]
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
    Creator = "Andriy Diadyk"
    Env = "Demo"
  }
}

resource "aws_launch_configuration" "for_web_server" {
    name_prefix = "HighlyAvailable-WebServer-"
    image_id = data.aws_ami.for_web_server.id
    instance_type = "t2.micro"
    security_groups = [aws_security_group.for_web_server.id]
    user_data = file("user_data.sh")

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "for_web_server" {
  name                 = "ASG_for_${aws_launch_configuration.for_web_server.name}"
  launch_configuration = aws_launch_configuration.for_web_server.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az-1.id, aws_default_subnet.default_az-2.id]
  load_balancers        = [aws_elb.for_web_server.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer created by ASG"
      Owner  = "Andriy Diadyk"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "for_web_server" {
    name = "HightlyAvailable-WebServer"
    availability_zones = [data.aws_availability_zones.for_web_server.names[0], data.aws_availability_zones.for_web_server.names[1]]
    security_groups = [aws_security_group.for_web_server.id]
    listener {
      instance_port = 80
      instance_protocol = "tcp"
      lb_port = 80
      lb_protocol = "tcp"
    }
    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:80/"
      interval = 10
    }
    tags = {
      Owner = "Andriy Diadyk"
    }
}

resource "aws_default_subnet" "default_az-1" {
  availability_zone = data.aws_availability_zones.for_web_server.names[0]
}

resource "aws_default_subnet" "default_az-2" {
  availability_zone = data.aws_availability_zones.for_web_server.names[1]
}


output "dns_name_elb" {
  value = aws_elb.for_web_server.dns_name
}

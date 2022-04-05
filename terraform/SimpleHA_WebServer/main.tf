provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }
}

resource "aws_security_group" "forWebServer" {
  name = "HTTP-SG"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "available" {
  name_prefix   = "WebServer-LC-"
  image_id      = data.aws_ami.latest.id
  instance_type = "t2.micro"
  user_data = file("web_page.sh")
  security_groups = [aws_security_group.forWebServer.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  name                 = "WebServer-ASG"
  launch_configuration = aws_launch_configuration.available.name
  min_size             = 1
  max_size             = 3
  load_balancers = [aws_elb.available.id]
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier = [aws_default_subnet.subnet1.id, aws_default_subnet.subnet2.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_default_subnet" "subnet1" { availability_zone = data.aws_availability_zones.available.names[0] }
resource "aws_default_subnet" "subnet2" { availability_zone = data.aws_availability_zones.available.names[1] }
resource "aws_default_subnet" "subnet3" { availability_zone = data.aws_availability_zones.available.names[2] }

resource "aws_elb" "available" {
  name               = "WebServer-ELB"
  availability_zones = data.aws_availability_zones.available.names
  security_groups = [aws_security_group.forWebServer.id]

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 80

  tags = {
    Name = "WebServer ELB"
  }
}

output "myip" {
  value = aws_elb.available.dns_name
}

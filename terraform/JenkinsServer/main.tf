provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "jenkins-ssh" {
    name = "Jenkins-SG"
    dynamic "ingress" {
      for_each = ["8080", "22"]
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
    }
}

resource "aws_instance" "ServerJenkins" {
    ami = "ami-065deacbcaac64cf2"
    instance_type = "t2.micro"
    key_name = "keyfrankfurt"
    vpc_security_group_ids = [aws_security_group.jenkins-ssh.id]
    user_data = file("user_data.sh")

    lifecycle {
      create_before_destroy = true
    }

    depends_on = [aws_security_group.jenkins-ssh]

    tags = {
      Name = "ServerETC"
      Terraform = "True"
    }
}

output "public_ip_instance" {
  value = aws_instance.ServerJenkins.public_ip
}

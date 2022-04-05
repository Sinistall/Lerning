provider "aws" {}

resource "aws_instance" "from_amazon_ami" {
  ami           = "ami-03a71cec707bfc3d7"
  instance_type = "t2.small"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Andriy Diadyk"
  }
}

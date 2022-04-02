variable "region" {
  default = "eu-central-1"
}
variable "find-ami-prefix" {
  description = "Prefix for find Latest AMI"
  type = string
  default = "amzn2-ami-kernel-5.10-hvm-*"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "common-tags" {
  type = map
  default = {
    Owner = "Andriy Diadyk"
    ENV = "DEV"
  }
}

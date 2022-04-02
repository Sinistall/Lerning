output "ami_latest" {
  value = data.aws_ami.latest.name
}

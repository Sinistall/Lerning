output "ami_latest" {
  value = data.aws_ami.latest.name
}
output "public_ip" {
  value = aws_instance.Test_WebServer.public_ip
}

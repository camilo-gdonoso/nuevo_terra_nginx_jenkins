# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}
output "aws_instance_public_ip" {
  value = aws_instance.aws_ubuntu.public_ip
}
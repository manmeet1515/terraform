output "aws_instance_public_ip" {
  value = aws_instance.my_test_instance.public_ip
}
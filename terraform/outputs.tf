output "ip" {
  description = "The private ipv4 address"
  value       = aws_instance.ec2_instance.private_ip
}

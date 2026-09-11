output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "Public IPv4 address of the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.this.public_dns
}

output "website_url" {
  description = "HTTP URL for the Apache test page."
  value       = "http://${aws_instance.this.public_ip}"
}

output "security_group_id" {
  description = "ID of the instance security group."
  value       = aws_security_group.instance.id
}
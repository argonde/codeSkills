output "public_ip" {
  description = "The Public IP address used to access the instance"
  value       = aws_instance.webserver.public_ip
}

output "private_ip" {
  value       = aws_instance.webserver.private_ip
  description = "The private IP of the web server"
}

output "security_group" {
  value = aws_security_group.sg_8080.id
}
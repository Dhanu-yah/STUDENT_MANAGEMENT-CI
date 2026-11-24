output "server_public_ips" {
  value = aws_instance.my_servers[*].public_ip
}

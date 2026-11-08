output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web_private_ips" {
  value = aws_instance.web[*].private_ip
}

output "app_private_ips" {
  value = aws_instance.app[*].private_ip
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_alb_dns_name" {
  value = module.load_balancers.public_alb_dns
}

output "public_alb_url" {
  value = "http://${module.load_balancers.public_alb_dns}"
}

output "private_alb_dns_name" {
  value = module.load_balancers.private_alb_dns
}

output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "web_private_ips" {
  value = module.compute.web_private_ips
}

output "app_private_ips" {
  value = module.compute.app_private_ips
}

output "db_private_ip" {
  value = module.compute.db_private_ip
}

output "ssh_to_bastion" {
  value = "ssh -i ${var.key_name}.pem ec2-user@${module.compute.bastion_public_ip}"
}

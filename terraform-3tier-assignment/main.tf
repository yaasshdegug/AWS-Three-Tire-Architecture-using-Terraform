data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  admin_cidr = var.admin_cidr == "auto" ? "${chomp(data.http.my_ip.response_body)}/32" : var.admin_cidr
}

# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "main" {
#   key_name   = var.key_name
#   public_key = tls_private_key.ssh.public_key_openssh
#   tags       = { Name = var.key_name }
# }

# resource "local_file" "private_key" {
#   content         = tls_private_key.ssh.private_key_pem
#   filename        = "${path.module}/${var.key_name}.pem"
#   file_permission = "0400"
# }

module "vpc" {
  source              = "./modules/vpc"
  name                = var.project
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  web_subnet_cidrs    = var.web_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
}

module "security_groups" {
  source     = "./modules/security_groups"
  name       = var.project
  vpc_id     = module.vpc.vpc_id
  admin_cidr = local.admin_cidr
}

module "load_balancers" {
  source             = "./modules/load_balancers"
  name               = var.project
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.app_subnet_ids
  public_alb_sg_id   = module.security_groups.public_alb_sg_id
  private_alb_sg_id  = module.security_groups.private_alb_sg_id
}

module "compute" {
  source               = "./modules/compute"
  name                 = var.project
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  key_name             = var.key_name
  public_subnet_ids    = module.vpc.public_subnet_ids
  web_subnet_ids       = module.vpc.web_subnet_ids
  app_subnet_ids       = module.vpc.app_subnet_ids
  db_subnet_ids        = module.vpc.db_subnet_ids
  bastion_sg_id        = module.security_groups.bastion_sg_id
  web_sg_id            = module.security_groups.web_sg_id
  app_sg_id            = module.security_groups.app_sg_id
  db_sg_id             = module.security_groups.db_sg_id
  web_target_group_arn = module.load_balancers.web_target_group_arn
  app_target_group_arn = module.load_balancers.app_target_group_arn
  depends_on           = [module.vpc]
}

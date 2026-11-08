variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project name, used in resource names and tags"
  type        = string
  default     = "yash-3tier"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag (your name)"
  type        = string
  default     = "Yash"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnets (public ALB, NAT gateways, bastion)"
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "web_subnet_cidrs" {
  description = "Private subnets for the web tier"
  type        = list(string)
  default     = ["172.16.11.0/24", "172.16.12.0/24"]
}

variable "app_subnet_cidrs" {
  description = "Private subnets for the application tier"
  type        = list(string)
  default     = ["172.16.21.0/24", "172.16.22.0/24"]
}

variable "db_subnet_cidrs" {
  description = "Private subnets for the database tier"
  type        = list(string)
  default     = ["172.16.31.0/24", "172.16.32.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID. Leave empty to use the latest Amazon Linux 2023"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
  default     = "laptop"
}

variable "admin_cidr" {
  description = "Admin IP allowed to SSH to the bastion, e.g. 1.2.3.4/32. Use auto to detect your current IP"
  type        = string
  default     = "auto"
}

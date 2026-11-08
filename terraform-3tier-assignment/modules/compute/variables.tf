variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "web_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "bastion_sg_id" {
  type = string
}

variable "web_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "db_sg_id" {
  type = string
}

variable "web_target_group_arn" {
  type = string
}

variable "app_target_group_arn" {
  type = string
}

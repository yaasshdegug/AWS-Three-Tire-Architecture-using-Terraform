data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

locals {
  ami = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
}

resource "aws_instance" "bastion" {
  ami                         = local.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags                        = { Name = "${var.name}-bastion" }
}

resource "aws_instance" "web" {
  count                  = 2
  ami                    = local.ami
  instance_type          = var.instance_type
  subnet_id              = var.web_subnet_ids[count.index]
  vpc_security_group_ids = [var.web_sg_id]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    echo "<h1>Web Tier - Server ${count.index + 1}</h1>" > /var/www/html/index.html
    systemctl start httpd
  EOF

  tags = { Name = "${var.name}-web-${count.index + 1}" }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = 2
  target_group_arn = var.web_target_group_arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

resource "aws_instance" "app" {
  count                  = 2
  ami                    = local.ami
  instance_type          = var.instance_type
  subnet_id              = var.app_subnet_ids[count.index]
  vpc_security_group_ids = [var.app_sg_id]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    echo "<h1>Application Tier - Server ${count.index + 1}</h1>" > /var/www/html/index.html
    systemctl start httpd
  EOF

  tags = { Name = "${var.name}-app-${count.index + 1}" }
}

resource "aws_lb_target_group_attachment" "app" {
  count            = 2
  target_group_arn = var.app_target_group_arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}

resource "aws_instance" "db" {
  ami                    = local.ami
  instance_type          = var.instance_type
  subnet_id              = var.db_subnet_ids[0]
  vpc_security_group_ids = [var.db_sg_id]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y mariadb105-server
    systemctl enable mariadb
    systemctl start mariadb
  EOF

  tags = { Name = "${var.name}-db" }
}

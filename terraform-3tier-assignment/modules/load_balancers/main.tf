resource "aws_lb" "public" {
  name               = "${var.name}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_subnet_ids
  tags               = { Name = "${var.name}-public-alb" }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = { Name = "${var.name}-web-tg" }
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb" "private" {
  name               = "${var.name}-private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.private_alb_sg_id]
  subnets            = var.private_subnet_ids
  tags               = { Name = "${var.name}-private-alb" }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.name}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = { Name = "${var.name}-app-tg" }
}

resource "aws_lb_listener" "private" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

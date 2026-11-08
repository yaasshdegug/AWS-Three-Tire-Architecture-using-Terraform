output "public_alb_dns" {
  value = aws_lb.public.dns_name
}

output "private_alb_dns" {
  value = aws_lb.private.dns_name
}

output "web_target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "app_target_group_arn" {
  value = aws_lb_target_group.app.arn
}

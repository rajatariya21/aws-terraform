output "load_balancer_ip" {
  value = aws_alb.default.dns_name
}
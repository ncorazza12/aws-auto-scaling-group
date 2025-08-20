output "lb_fqdn" {
  value       = "http://${aws_lb.ec2-lb.dns_name}"
  description = "FQDN público do Load Balancer"
}
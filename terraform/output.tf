output "lb_fqdn" {
  value       = module.app.lb_fqdn
  description = "FQDN público do Load Balancer"
}
output "loadbalancer" {
  value = azurerm_lb.loadbalancer
  description = "Load Balancer object"
}

output "loadbalancer_health_probe" {
  value = azurerm_lb_probe.loadbalancer-lbhp
  description = "Load Balancer  health probe object"
}

output "loadbalancer_backend_address_pool" {
  value = azurerm_lb_backend_address_pool.loadbalancer-lbbp
  description = "Load Balancer backend address pool object"
}

output "loadbalancer_backend_rule" {
  value = azurerm_lb_rule.loadbalancer-lbr
  description = "Load Balancer backend rule object"
}
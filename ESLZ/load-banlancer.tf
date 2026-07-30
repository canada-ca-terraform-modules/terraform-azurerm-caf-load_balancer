terraform {
  required_version = ">= 1.9"
}

variable "load_balancers" {
  type        = any
  default     = {}
  description = "Value for load balancer. This is a collection of values as defined in load_balancer.tfvars"
}

module "load_balancer" {
  for_each = var.load_balancers
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-load_balancer.git?ref=v2.0.0"

  location          = var.location
  subnets           = local.subnets
  resource_groups   = local.resource_groups_all
  userDefinedString = each.key
  tags              = var.tags
  env               = var.env
  load_balancer     = each.value
}

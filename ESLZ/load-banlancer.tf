variable "load_balancers" {
  type = any
  default = {}
  description = "Value for load balancer. This is a collection of values as defined in load_balancer.tfvars"
}

module "load_balancer" {
  for_each = var.load_balancers
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-load_balancer.git"

  location          = var.location
  subnets           = local.subnets
  resource_groups   = local.resource_groups_all
  userDefinedString = each.key
  tags              = var.tags
  env               = var.env
  group             = var.group
  project           = var.project
  load_balancer      = each.value
  custom_data       = try(each.value.custom_data, false) != false ? base64encode(file("${path.cwd}/${each.value.custom_data}")) : null
  user_data         = try(each.value.user_data, false) != false ? base64encode(file("${path.cwd}/${each.value.user_data}")) : null
}
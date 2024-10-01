locals {
  # If resource_group was an ID, then parse the ID for the name, if not, then search in the provided resource_groups object
  resource_group_name = strcontains(var.load_balancer.resource_group_name, "/resourceGroups/") ? regex("[^\\/]+$", var.load_balancer.resource_group_name) :  var.resource_groups[var.load_balancer.resource_group_name].name

}
locals {
  load_balancer_regex     = "/[//\"'\\[\\]:|<>+=;,?*@&]/" # Can't include those characters in windows_virtual_machine name: \/"'[]:|<>+=;,?*@&
  env_4                = substr(var.env, 0, 4)
  postfix_3            = substr(var.load_balancer.postfix, 0, 3)
  userDefinedString_54 = substr(var.userDefinedString, 0, 54 - length(local.postfix_3))
  load_balancer_name            = try(var.load_balancer.custom_name, replace("${local.env_4}-${local.userDefinedString_54}${local.postfix_3}", local.load_balancer_regex, ""))
}

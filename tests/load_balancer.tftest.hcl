mock_provider "azurerm" {}

variables {
  resource_groups   = { rg-test = { name = "rg-test", location = "canadacentral" } }
  subnets           = { MAZ = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/MAZ" } }
  location          = "canadacentral"
  env               = "Dev"
  userDefinedString = "lb"
}

run "naming_convention" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "01"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.name == "Dev-lb01-lb"
    error_message = "Name must follow {env4}-{userDefinedString}{postfix}-lb convention"
  }
}

run "default_values" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "01"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.sku == "Standard"
    error_message = "sku must default to Standard"
  }
}

run "public_frontend_no_subnet" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "02"
      frontend_ip_configuration = {
        feipc1 = {
          public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/publicIPAddresses/pip1"
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.frontend_ip_configuration[0].subnet_id == null
    error_message = "subnet_id must be null when subnet key is omitted (public frontend)"
  }
}

run "rules_use_v5_attribute_names" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "03"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
      probes = {
        tcp443 = {
          protocol = "Tcp"
          port     = 443
        }
      }
      rules = {
        tcp443 = {
          frontend_ip_configuration_name = "feipc1"
          protocol                       = "Tcp"
          frontend_port                  = 443
          backend_port                   = 443
          probe_name                     = "tcp443"
          enable_floating_ip             = true
          enable_tcp_reset               = true
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb_rule.loadbalancer-lbr["tcp443"].floating_ip_enabled == true
    error_message = "floating_ip_enabled must be set from the enable_floating_ip caller key (azurerm v5 rename)"
  }

  assert {
    condition     = azurerm_lb_rule.loadbalancer-lbr["tcp443"].tcp_reset_enabled == true
    error_message = "tcp_reset_enabled must be set from the enable_tcp_reset caller key (azurerm v5 rename)"
  }
}

run "custom_resource_names" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name       = "rg-test"
      postfix                   = "04"
      backend_address_pool_name = "my-existing-lbbp"
      frontend_ip_configuration = {
        feipc1 = {
          name                          = "my-existing-lbfe"
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
      probes = {
        tcp443 = {
          name     = "my-existing-lbhp"
          protocol = "Tcp"
          port     = 443
        }
      }
      rules = {
        tcp443 = {
          name                           = "my-existing-lbr"
          frontend_ip_configuration_name = "feipc1"
          protocol                       = "Tcp"
          frontend_port                  = 443
          backend_port                   = 443
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.frontend_ip_configuration[0].name == "my-existing-lbfe"
    error_message = "frontend_ip_configuration name override not applied"
  }
  assert {
    condition     = azurerm_lb_probe.loadbalancer-lbhp["tcp443"].name == "my-existing-lbhp"
    error_message = "probe name override not applied"
  }
  assert {
    condition     = azurerm_lb_backend_address_pool.loadbalancer-lbbp.name == "my-existing-lbbp"
    error_message = "backend_address_pool_name override not applied"
  }
  assert {
    condition     = azurerm_lb_rule.loadbalancer-lbr["tcp443"].name == "my-existing-lbr"
    error_message = "rule name override not applied"
  }
  assert {
    condition     = azurerm_lb_rule.loadbalancer-lbr["tcp443"].frontend_ip_configuration_name == "my-existing-lbfe"
    error_message = "rule frontend_ip_configuration_name must follow the overridden frontend name"
  }
}

run "caller_sku_override" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "05"
      sku                 = "Gateway"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.sku == "Gateway"
    error_message = "sku must read from var.load_balancer.sku (top-level), not var.load_balancer.lb.sku"
  }
}

run "tunnel_interface_gateway_lb" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "06"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
      tunnel_interface = {
        ti1 = {
          identifier = 800
          type       = "Internal"
          protocol   = "VXLAN"
          port       = 2000
        }
      }
    }
  }

  assert {
    condition     = length(azurerm_lb_backend_address_pool.loadbalancer-lbbp.tunnel_interface) == 1
    error_message = "tunnel_interface must read from var.load_balancer.tunnel_interface (matches ESLZ tfvars key), not tunnel_interfaces"
  }
}
